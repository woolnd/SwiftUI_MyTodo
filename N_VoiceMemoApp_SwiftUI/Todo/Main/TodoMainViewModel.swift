//
//  TodoMainViewModel.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 5/29/25.
//

import Foundation
import FirebaseFirestore

final class TodoMainViewModel: ObservableObject {
    
    @Published var todoViewModels: [todo] = []  // 직접 여기로 올려!
    
    enum Action {
        case loadData
        case getDataSuccess(TodoResponse)
        case getDataFailure(Error)
        case isCompleteToggle(String)
        case deleteTodo(String)
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
        case let .isCompleteToggle(id):
            toggleComplete(id)
        case let .deleteTodo(id):
            deleteTodo(id)
        }
    }
    
    deinit{
        loadDataTask?.cancel()
    }
}

extension TodoMainViewModel {
    private func loadData() {
        loadDataTask = Task {
            do {
                let db = Firestore.firestore()
                let docRef = db.collection("Todo").document("List")
                
                let snapshot = try await docRef.getDocument()
                guard let response = try? snapshot.data(as: TodoResponse.self)
                else { throw NSError(domain: "DecodingError", code: -1) }
                
                process(.getDataSuccess(response))
                
            } catch{
                process(.getDataFailure(error))
            }
        }
    }
    
    private func transformResponse(_ response: TodoResponse){
        Task {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "a h시 mm분" // 예: 오후 6시 40분
            
            let sortedResponse = response.todo.sorted { todo1, todo2 in
                guard
                    let date1 = formatter.date(from: todo1.time),
                    let date2 = formatter.date(from: todo2.time)
                else {
                    return false
                }
                return date1 < date2
            }
            await MainActor.run {
                self.todoViewModels = sortedResponse.map {
                    todo(id: $0.id, title: $0.title, date: $0.date, time: $0.time, isCompleted: $0.isCompleted)
                }
            }
        }
    }
    
    private func toggleComplete(_ id: String) {
        var todos = self.todoViewModels
        
        if let index = todos.firstIndex(where: { $0.id == id }) {
            // 1. 현재 Todo 가져오기
            var updatedTodo = todos[index]
            // 2. isCompleted 토글
            updatedTodo = todo(
                id: updatedTodo.id,
                title: updatedTodo.title,
                date: updatedTodo.date,
                time: updatedTodo.time,
                isCompleted: !updatedTodo.isCompleted
            )
            // 3. 업데이트된 값 적용
            todos[index] = updatedTodo
            self.todoViewModels = todos
            
            // 4. Firestore에 업데이트
            let db = Firestore.firestore()
            let listRef = db.collection("Todo").document("List")
            
            // nested array 안의 하나만 수정하기 위해서 전체 todo array를 다시 올리는 구조라면:
            Task {
                do {
                    // 전체 데이터 fetch
                    let snapshot = try await listRef.getDocument()
                    guard var response = try? snapshot.data(as: TodoResponse.self) else { return }
                    
                    if let idx = response.todo.firstIndex(where: { $0.id == id }) {
                        response.todo[idx].isCompleted.toggle()
                        
                        try listRef.setData(from: response) // 전체 덮어쓰기
                    }
                } catch {
                    print("Toggle update error: \(error)")
                }
            }
        }
    }
    
    private func deleteTodo(_ id: String) {
        Task {
            let db = Firestore.firestore()
            let docRef = db.collection("Todo").document("List")
            
            do {
                let snapshot = try await docRef.getDocument()
                guard var response = try? snapshot.data(as: TodoResponse.self) else { return }
                
                response.todo.removeAll { $0.id == id }
                
                try docRef.setData(from: response)
                process(.loadData) // 다시 불러와서 갱신
            } catch {
                print("삭제 실패: \(error)")
            }
        }
    }
}
