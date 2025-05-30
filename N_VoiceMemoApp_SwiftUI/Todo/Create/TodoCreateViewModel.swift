//
//  TodoCreateViewModel.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 5/30/25.
//

import Foundation
import FirebaseFirestore

final class TodoCreateViewModel: ObservableObject {
    enum Action{
        case createTodo(todo)
    }
    
    @Published var createTodoViewModels: todo?
    
    func process(_ action: Action, completion: @escaping (Bool) -> Void) {
        switch action {
        case let .createTodo(todo):
            saveTodoToFirestore(todo, completion: completion)
        }
    }
}

extension TodoCreateViewModel {
    private func saveTodoToFirestore(_ todo: todo, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let todoData: [String: Any] = [
            "id": todo.id,
            "title": todo.title,
            "date": todo.date,
            "time": todo.time,
            "isCompleted": todo.isCompleted
        ]
        
        let documentRef = db.collection("Todo").document("List")
        
        documentRef.updateData([
            "todo": FieldValue.arrayUnion([todoData])
        ]) { error in
            if let error = error {
                print("❌ 저장 실패: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Firestore 저장 성공!")
                completion(true)
            }
        }
    }
}
