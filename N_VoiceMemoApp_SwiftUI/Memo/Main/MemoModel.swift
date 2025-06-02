//
//  MemoModel.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 6/2/25.
//

import Foundation

struct MemoResponse: Codable {
    var memo: [memo]
}

struct memo: Codable, Identifiable {
    let id: String
    let title: String
    let content: String
    let date: String
}


