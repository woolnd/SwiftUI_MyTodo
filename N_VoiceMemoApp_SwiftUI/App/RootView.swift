//
//  RootView.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 5/23/25.
//

import SwiftUI

struct RootView: View {
    @State private var showOnboarding = false //온보딩 전환 여부
    @StateObject var appState = AppState.shared
    
    var body: some View {
        NavigationStack(path: $appState.navigationPath){
            Group{
                if showOnboarding {
                    OnboardingTabView()
                } else {
                    SplashView()
                }
            }
            .onAppear(){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    withAnimation {
                        showOnboarding = true
                    }
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .onboarding(let type):
                    switch type {
                    case .main:
                        MainView()
                    }
                    
                case .todo(let type):
                    switch type {
                    case .create:
                        TodoCreateView()
                    }
                case .memo(let type):
                    switch type {
                    case .create:
                        TodoCreateView()
                    }
                }
            }
        }
    }
}

#Preview {
    RootView()
}
