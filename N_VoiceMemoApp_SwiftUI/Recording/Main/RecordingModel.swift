//
//  RecordingModel.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 6/3/25.
//

import Foundation

struct RecordingResponse: Codable {
    var recording: [recording]
}

struct recording: Codable {
    let id: String
    let title: String
    let time: String
    let date: String
}
