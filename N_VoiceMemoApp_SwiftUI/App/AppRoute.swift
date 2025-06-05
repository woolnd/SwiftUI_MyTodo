//
//  AppRoute.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 5/30/25.
//

import Foundation

enum AppRoute: Hashable {
    case onboarding(onboardingType)
    case todo(todoMainType)
    case memo(memoMainType)
    case recording(recordingMainType)
}

enum onboardingType: Hashable {
    case main
}

enum todoMainType: Hashable {
    case create
}

enum memoMainType: Hashable {
    case create
}

enum recordingMainType: Hashable {
    case create
}
