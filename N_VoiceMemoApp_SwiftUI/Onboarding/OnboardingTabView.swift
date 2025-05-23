//
//  OnboardingTabView.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 5/23/25.
//

import SwiftUI

struct OnboardingTabView: View {
    @State private var currentPage = 0
    
    var body: some View {
        ZStack{
            TabView(selection: $currentPage) {
                OnboardingFirstView().tag(0)
                
                OnboardingSecondView().tag(1)
                
                OnboardingThirdView().tag(2)
                
                OnboardingLastView().tag(3)
            }
            .tabViewStyle(PageTabViewStyle())
            .ignoresSafeArea()
            
            VStack(spacing: 0){
                Spacer()
                
                HStack(spacing: 8){
                    ForEach(0..<4, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.key : Color.gray.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                }
            }
        }
        .navigationDestination(for: onboardingType.self) { view in
            switch view {
            case .main:
                MainView()
            }
        }
    }
}

struct OnboardingFirstView: View {
    var body: some View {
        ZStack{
            Image("login1")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                Spacer()
                
                Text("오늘의 할일")
                    .font(.system(size: 16, weight: .bold))
                
                Text("To do list로 언제 어디서든 해야할일을 한눈에")
                    .font(.system(size: 16))
                    .padding(.bottom, Constants.ControlWidth * 212)
            }
        }
    }
}

struct OnboardingSecondView: View {
    var body: some View {
        ZStack{
            Image("login2")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                Spacer()
                
                Text("똑똑한 나만의 기록장")
                    .font(.system(size: 16, weight: .bold))
                
                Text("메모장으로 생각나는 기록은 언제든지")
                    .font(.system(size: 16))
                    .padding(.bottom, Constants.ControlWidth * 212)
            }
        }
    }
}

struct OnboardingThirdView: View {
    var body: some View {
        ZStack{
            Image("login3")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                Spacer()
                
                Text("하나라도 놓치지 않도록")
                    .font(.system(size: 16, weight: .bold))
                
                Text("음성메모 기능으로 놓치고 싶지않은 기록까지")
                    .font(.system(size: 16))
                    .padding(.bottom, Constants.ControlWidth * 212)
            }
        }
    }
}

struct OnboardingLastView: View {
    var body: some View {
        ZStack{
            Image("login4")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                Spacer()
                
                Text("정확한 시간의 경과")
                    .font(.system(size: 16, weight: .bold))
                
                Text("타이머 기능으로 원하는 시간을 확인")
                    .font(.system(size: 16))
                    .padding(.bottom, Constants.ControlWidth * 212)
            }
            
            VStack(spacing: 0){
                Spacer()
                
                Button {
                    AppState.shared.navigationPath.append(onboardingType.main)
                } label: {
                    HStack(spacing: 0) {
                        Text("시작하기")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.key)
                        
                        Image(systemName: "arrow.forward")
                            .foregroundColor(.key)
                    }
                }
                .padding(.bottom, Constants.ControlWidth * 92)
            }
        }
    }
}

enum onboardingType {
    case main
}

#Preview {
    OnboardingTabView()
}
