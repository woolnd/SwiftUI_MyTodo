//
//  MainView.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 5/23/25.
//

import SwiftUI

struct MainView: View {
    @State private var currentTab = 0
    
    var body: some View {
        TabView(selection: $currentTab){
            TodoMainView()
                .tabItem {
                    Image( currentTab == 0 ? "Todo_On" : "Todo_Off")
                }
                .tag(0)
            
            MemoMainView()
                .tabItem {
                    Image( currentTab == 1 ? "Memo_On" : "Memo_Off")
                }
                .tag(1)
            
            Text("recording")
                .tabItem {
                    Image( currentTab == 2 ? "VoiceIcon_On" : "VoiceIcon_Off")
                }
                .tag(2)
            
            Text("timer")
                .tabItem {
                    Image( currentTab == 3 ? "Alarm_On" : "Alarm_Off")
                }
                .tag(3)
            
            Text("setting")
                .tabItem {
                    Image( currentTab == 4 ? "Setting_On" : "Setting_Off")
                }
                .tag(4)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MainView()
}
