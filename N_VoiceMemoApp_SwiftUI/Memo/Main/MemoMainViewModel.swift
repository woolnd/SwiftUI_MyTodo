//
//  MemoMainViewModel.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 6/2/25.
//

import Foundation
import FirebaseFirestore

final class MemoMainViewModel: ObservableObject {
    
    @Published var memoViewModels: [memo] = []  // 직접 여기로 올려!
    
    enum Action {
        case loadData
        case getDataSuccess(MemoResponse)
        case getDataFailure(Error)
        case deleteMemo(String)
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
        case let .deleteMemo(id):
            deleteMemo(id)
        }
    }
    
    deinit{
        loadDataTask?.cancel()
    }
}

extension MemoMainViewModel {
    private func loadData() {
        loadDataTask = Task {
            do {
                let db = Firestore.firestore()
                let docRef = db.collection("Memo").document("List")
                
                let snapshot = try await docRef.getDocument()
                guard let response = try? snapshot.data(as: MemoResponse.self)
                else { throw NSError(domain: "DecodingError", code: -1) }
                
                process(.getDataSuccess(response))
                
            } catch{
                process(.getDataFailure(error))
            }
        }
    }
    
    private func transformResponse(_ response: MemoResponse){
        Task {
            await MainActor.run {
                self.memoViewModels = response.memo.compactMap {
                    memo(id: $0.id, title: $0.title, content: $0.content, date: $0.date)
                }
            }
        }
    }
    
    
    private func deleteMemo(_ id: String) {
        Task {
            let db = Firestore.firestore()
            let docRef = db.collection("Memo").document("List")
            
            do {
                let snapshot = try await docRef.getDocument()
                guard var response = try? snapshot.data(as: MemoResponse.self) else { return }
                
                response.memo.removeAll { $0.id == id }
                
                try docRef.setData(from: response)
                process(.loadData) // 다시 불러와서 갱신
            } catch {
                print("삭제 실패: \(error)")
            }
        }
    }
}
