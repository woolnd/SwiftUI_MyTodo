//
//  TodoMainModel.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 5/29/25.
//

import Foundation

struct TodoResponse: Codable {
    var todo: [todo]
}

struct todo: Codable, Identifiable {
    let id: String
    let title: String
    let date: String
    let time: String
    var isCompleted: Bool
}

