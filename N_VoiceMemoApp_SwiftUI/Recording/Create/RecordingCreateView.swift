//
//  RecordingCreateView.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 6/4/25.
//

import SwiftUI

struct RecordingCreateView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: RecordingCreateViewModel = RecordingCreateViewModel()
    
    @State var recordingTitle: String = ""
    @State private var showingAlert = false
    @StateObject var recorder = RecordingManager()
    
    var formattedToday: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 (E) - a h시 m분"
        return formatter.string(from: Date())
    }
    
    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                RecordingCreateMainView(recordingTitle: $recordingTitle, formattedToday: formattedToday, recorder: recorder)
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                Button {
                    guard !recordingTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
                        showingAlert = true
                        return
                    }
                    
                    let recordingID = recorder.currentFileName ?? UUID().uuidString

                    let newRecording = recording(
                        id: recordingID,
                        title: recordingTitle,
                        time: recorder.recordingTime,
                        date: formattedToday
                    )
                    
                    viewModel.process(.recordingCreate(newRecording)) { success in
                        if success {
                            dismiss()
                        }
                    }
                    
                } label: {
                    Text("생성하기")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.wh)
                        .background(){
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.key)
                                .frame(width: Constants.ControlWidth * 330, height: Constants.ControlHeight * 50)
                        }
                    
                }
                .padding(.bottom, Constants.ControlHeight * 50)
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("제목을 입력해주세요."),
                message: Text("녹음을 추가하려면 제목이 필요합니다."),
                dismissButton: .default(Text("확인"))
            )
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark") // 닫기 아이콘
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct RecordingCreateMainView: View {
    @Binding var recordingTitle: String
    var formattedToday: String
    @ObservedObject var recorder: RecordingManager
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("녹음을\n추가해 보세요.")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.bk)
                    .padding(.top, Constants.ControlHeight * 39)
                    .padding(.leading, Constants.ControlWidth * 30)
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                TextField("제목을 입력하세요.", text: $recordingTitle)
                    .padding(.top, Constants.ControlHeight * 20)
                    .padding(.leading, Constants.ControlWidth * 30)
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                Button {
                    recorder.toggleRecordingOrPlayback()
                } label: {
                    HStack(spacing: 0) {
                        if recorder.isRecording {
                            Image("Voice_On")
                            Text("녹음중지")
                        } else if recorder.isPlaying {
                            Image("Voice_On")
                            Text("재생중")
                        } else if recorder.recordedFileURL != nil {
                            Image("Voice_Off")
                            Text("재생하기")
                        } else {
                            Image("Voice_Off")
                            Text("녹음하기")
                        }
                    }
                    .font(.system(size: 30))
                    .foregroundColor(.key)
                }
                
                Spacer()
                
                Button {
                    recorder.resetRecording()
                } label: {
                    Text("초기화")
                        .font(.system(size: 20))
                        .foregroundColor(.accentColor)
                }
            }
            .padding(.leading, Constants.ControlWidth * 30)
            .padding(.top, Constants.ControlHeight * 40)
            .padding(.trailing, Constants.ControlWidth * 40)
                    
            
            HStack(spacing: 0) {
                Text("녹음시간")
                    .font(.system(size: 25, weight: .medium))
                    .foregroundColor(.bk)
                
                Text(recorder.recordingTime)
                    .font(.system(size: 25, weight: .medium))
                    .foregroundColor(.iconOn)
                    .padding(.leading, Constants.ControlWidth * 20)
                
                Spacer()
            }
            .padding(.leading, Constants.ControlWidth * 30)
            .padding(.top, Constants.ControlHeight * 30)
            
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("현재 날짜 및 시간")
                        .font(.system(size: 16))
                        .foregroundColor(.iconOn)
                    
                    Text("\(formattedToday)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.key)
                }
                
                Spacer()
            }
            .padding(.top, Constants.ControlHeight * 84)
            .padding(.leading, Constants.ControlWidth * 30)
        }
    }
}

#Preview {
    RecordingCreateView()
}
