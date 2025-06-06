//
//  TimerView.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 6/6/25.
//

import SwiftUI

struct TimerView: View {
    @State var timerStart: Bool = false
    
    // 시, 분, 초 상태값
    @State var selectedHour: Int = 0
    @State var selectedMinute: Int = 0
    @State var selectedSecond: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("타이머")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.bk)
                    .padding(.top, Constants.ControlHeight * 39)
                    .padding(.leading, Constants.ControlWidth * 30)
                    .padding(.bottom, timerStart ? Constants.ControlHeight * 204 : Constants.ControlHeight * 99)
                
                Spacer()
            }
            
            if timerStart {
                TimerStartView(timerStart: $timerStart,
                               selectedHour: $selectedHour,
                               selectedMinute: $selectedMinute,
                               selectedSecond: $selectedSecond)
            } else {
                TimerSettingView(timerStart: $timerStart,
                                 selectedHour: $selectedHour,
                                 selectedMinute: $selectedMinute,
                                 selectedSecond: $selectedSecond)
            }
            
            Spacer()
        }
    }
}

struct TimerSettingView: View {
    @Binding var timerStart: Bool
    @Binding var selectedHour: Int
    @Binding var selectedMinute: Int
    @Binding var selectedSecond: Int
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // 시 Picker
                Picker("시", selection: $selectedHour) {
                    ForEach(0..<24) { hour in
                        Text("\(hour) 시간").tag(hour)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
                
                // 분 Picker
                Picker("분", selection: $selectedMinute) {
                    ForEach(0..<60) { minute in
                        Text("\(minute) 분").tag(minute)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
                
                // 초 Picker
                Picker("초", selection: $selectedSecond) {
                    ForEach(0..<60) { second in
                        Text("\(second) 초").tag(second)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
            }
            .padding(.horizontal)
            
            Button {
                timerStart = true
            } label: {
                Text("설정하기")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.key)
                    .padding(.top, Constants.ControlHeight * 21)
            }
            
        }
    }
}

struct TimerStartView: View {
    @Binding var timerStart: Bool
    @Binding var selectedHour: Int
    @Binding var selectedMinute: Int
    @Binding var selectedSecond: Int
    
    @State var timerPause: Bool = false
    
    @State private var remainingSeconds: Int = 0
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var targetEndDate: Date? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            Text(timeString(from: remainingSeconds))
                .font(.system(size: 28))
                .foregroundColor(.iconOn)
                .onReceive(timer) { _ in
                    guard !timerPause else { return }
                    
                    if remainingSeconds > 0 {
                        remainingSeconds -= 1
                    } else {
                        // 타이머 종료 처리
                        timerPause = true
                        timerStart = false
                        // 여기에 "타이머 끝났다" 처리 넣어도 됨
                    }
                }
            
            HStack(spacing: 0) {
                Image(systemName: "bell.fill")
                    .foregroundColor(.iconOn)
                Text(targetEndDateString())
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.iconOn)
            }
            .padding(.top, Constants.ControlHeight * 15)
            
            
            HStack(spacing: 9) {
                Button {
                    timerPause = false
                    timerStart = false
                } label: {
                    Circle()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Constants.ControlWidth * 70)
                        .foregroundColor(.gray1)
                        .overlay {
                            Text("취소")
                                .font(.system(size: 14))
                                .foregroundColor(.iconOn)
                        }
                }
                
                Spacer()
                
                Button {
                    timerPause.toggle()
                    if !timerPause {
                        // 재생 시 현재 시점에서 다시 targetEndDate 업데이트
                        targetEndDate = Date().addingTimeInterval(TimeInterval(remainingSeconds))
                    }
                } label: {
                    Circle()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Constants.ControlWidth * 70)
                        .foregroundColor(.key)
                        .overlay {
                            Text(timerPause ? "재생" : "일시정지")
                                .font(.system(size: 14))
                                .foregroundColor(.iconOn)
                        }
                }
            }
            .padding(.top, Constants.ControlHeight * 120)
            .padding(.horizontal, Constants.ControlWidth * 35)
        }
        .onAppear {
            // 타이머 시작 시점에 remainingSeconds 초기화
            remainingSeconds = (selectedHour * 3600) + (selectedMinute * 60) + selectedSecond
            timerPause = false
            targetEndDate = Date().addingTimeInterval(TimeInterval(remainingSeconds))
        }
    }
    
    // 시:분:초 포맷팅 함수
    func timeString(from seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func targetEndDateString() -> String {
        guard let targetEndDate else { return "--:--" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 원하는 포맷으로 (예: "오전 10:30"도 가능)
        return formatter.string(from: targetEndDate)
    }
}

#Preview {
    TimerView()
}
