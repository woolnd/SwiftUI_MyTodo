//
//  MemoCreateViewModel.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 6/2/25.
//

import Foundation
import FirebaseFirestore

final class MemoCreateViewModel: ObservableObject {
    
    enum Action{
        case createMemo(memo)
    }
    
    @Published var createMemoViewModels: memo?
    
    
    func process(_ action: Action, completion: @escaping (Bool) -> Void) {
        switch action {
        case let .createMemo(memo):
            saveMemoToFirestore(memo: memo, completion: completion)
        }
    }
}

extension MemoCreateViewModel {
    func saveMemoToFirestore(memo: memo, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let memoData: [String: Any] = [
            "id": memo.id,
            "title": memo.title,
            "content": memo.content,
            "date": memo.date
        ]
        
        let documentRef = db.collection("Memo").document("List")
        
        documentRef.updateData([
            "memo": FieldValue.arrayUnion([memoData])
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
