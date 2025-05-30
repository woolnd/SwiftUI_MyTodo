//
//  AppState.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 5/23/25.
//

import Foundation
import SwiftUI

@MainActor
class AppState: ObservableObject {
    static let shared = AppState()
  
    // 네비게이션 스택 경로
    @Published var navigationPath = NavigationPath()
    
    func push(_ route: AppRoute) {
        navigationPath.append(route)
    }
}
