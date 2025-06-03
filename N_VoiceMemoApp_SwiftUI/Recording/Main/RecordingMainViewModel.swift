//
//  RecordingMainViewModel.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 6/3/25.
//

import Foundation
import FirebaseFirestore

final class RecordingMainViewModel: ObservableObject {
    
    @Published var recordingViewModels: [recording] = []  // 직접 여기로 올려!
    
    enum Action {
        case loadData
        case getDataSuccess(RecordingResponse)
        case getDataFailure(Error)
        case deleteRecording(String)
    }
    
    private var loadDataTask: Task<Void, Never>?
    
    func process(_ action: Action) {
        switch action {
        case .loadData:
            loadData()
        case let .getDataSuccess(response):
            transformResponse(response)
        case let .getDataFailure(error):
            print(error)
        case let .deleteRecording(id):
            deleteRecording(id)
        }
    }
    
    deinit{
        loadDataTask?.cancel()
    }
}

extension RecordingMainViewModel {
    private func loadData() {
        loadDataTask = Task {
            do {
                let db = Firestore.firestore()
                let docRef = db.collection("Recording").document("List")
                
                let snapshot = try await docRef.getDocument()
                guard let response = try? snapshot.data(as: RecordingResponse.self)
                else { throw NSError(domain: "DecodingError", code: -1) }
                
                process(.getDataSuccess(response))
                
            } catch{
                process(.getDataFailure(error))
            }
        }
    }
    
    private func transformResponse(_ response: RecordingResponse){
        Task {
            await MainActor.run {
                self.recordingViewModels = response.recording.compactMap {
                    recording(id: $0.id, title: $0.title, time: $0.time, date: $0.date)
                }
            }
        }
    }
    
    private func deleteRecording(_ id: String) {
        Task {
            let db = Firestore.firestore()
            let docRef = db.collection("Recording").document("List")
            
            do {
                let snapshot = try await docRef.getDocument()
                guard var response = try? snapshot.data(as: RecordingResponse.self) else { return }
                
                response.recording.removeAll { $0.id == id }
                
                try docRef.setData(from: response)
                process(.loadData) // 다시 불러와서 갱신
            } catch {
                print("삭제 실패: \(error)")
            }
        }
    }
}
