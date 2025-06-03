//
//  RecordingMainView.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 6/3/25.
//

import SwiftUI

struct RecordingMainView: View {
    @StateObject var viewModel: RecordingMainViewModel = RecordingMainViewModel()
    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("녹음을\n추가해 보세요.")
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 26, weight: .bold))
                        .padding(.leading, Constants.ControlWidth * 30)
                        .padding(.top, Constants.ControlHeight * 39)
                    
                    Spacer()
                }
                
                if viewModel.recordingViewModels.isEmpty {
                    RecordingListEmptyView()
                } else {
                    RecordingListView(viewModel: viewModel)
                }
                
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                
                Spacer()
                
                HStack(spacing: 0) {
                    
                    Spacer()
                    
                    Button {
                        AppState.shared.push(.todo(.create))
                    } label: {
                        Image("Write_btn")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Constants.ControlWidth * 50)
                    }
                    .padding(.trailing, Constants.ControlWidth * 31)
                    .padding(.bottom, Constants.ControlHeight * 39)
                }
            }
            
        }
        .onAppear(){
            viewModel.process(.loadData)
        }
    }
}

struct RecordingListView: View {
    @ObservedObject var viewModel: RecordingMainViewModel
    @State private var showingDeleteAlert = false
    @State private var selectedRecordingID: String?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("녹음 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, Constants.ControlWidth * 30)
                    .padding(.top, Constants.ControlHeight * 23)
                
                Spacer()
            }
            .padding(.bottom, Constants.ControlHeight * 5)
            
            
            ForEach(Array(viewModel.recordingViewModels.enumerated()), id: \.element.id) { index, recording in
                VStack(spacing: 0) {
                    if index == 0 {
                        Rectangle()
                            .fill(Color.gray1)
                            .frame(height: 1)
                    }
                    
                    HStack(spacing: 0) {
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(recording.title)
                                .font(.system(size: 16))
                                .foregroundColor(.bk)
                            
                            Text("\(recording.date)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.iconOn)
                        }
                        .padding(.leading, Constants.ControlWidth * 30)
                                                
                        Spacer()
                        
                        Text("\(recording.time)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.iconOn)
                            .padding(.trailing, Constants.ControlWidth * 30)
                    }
                    .onLongPressGesture {
                        selectedRecordingID = recording.id
                        showingDeleteAlert = true
                    }
                    .padding(.top, Constants.ControlHeight * 10)
                    .padding(.bottom, Constants.ControlHeight * 10)
                    .alert(isPresented: $showingDeleteAlert) {
                        Alert(
                            title: Text("삭제하시겠습니까?"),
                            message: Text("\(recording.title) 녹음을 삭제하면\n복구할 수 없습니다."),
                            primaryButton: .destructive(Text("삭제")) {
                                if let id = selectedRecordingID {
                                    viewModel.process(.deleteRecording(id))
                                }
                            },
                            secondaryButton: .cancel(Text("취소"))
                        )
                    }
                    
                    Rectangle()
                        .fill(Color.gray1)
                        .frame(height: 1)
                }
                
            }
            
            Spacer()
        }
    }
}

struct RecordingListEmptyView: View {
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
            
            Image("Todo_Pencil")
            
            Text("""
                 현재 등록된 음성메모가 없습니다. 
                 하단의 녹음버튼을 눌러 음성메모를 시작해주세요.
                 """)
            .font(.system(size: 14))
            .foregroundColor(.gray2)
            .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}


#Preview {
    RecordingMainView()
}

