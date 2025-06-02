//
//  MemoCreateView.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 6/2/25.
//

import SwiftUI

struct MemoCreateView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: MemoCreateViewModel = MemoCreateViewModel()
    
    @State private var memoTitle: String = ""
    @State private var memoContent: String = ""
    @State private var showingTitleAlert = false
    @State private var showingContentAlert = false
    
    var formattedToday: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 (E) - a h시 m분"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            MemoCreateMainView(memoTitle: $memoTitle, memoContent: $memoContent, formattedToday: formattedToday)
            
            Button {
                
                guard !memoTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
                    showingTitleAlert = true
                    return
                }
                
                guard !memoContent.trimmingCharacters(in: .whitespaces).isEmpty else {
                    showingContentAlert = true
                    return
                }
                
                let newMemo = memo(
                    id: UUID().uuidString,
                    title: memoTitle,
                    content: memoContent,
                    date: formattedToday
                )
                
                viewModel.process(.createMemo(newMemo)) { success in
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
        .alert(isPresented: $showingTitleAlert) {
            Alert(
                title: Text("제목을 입력해주세요."),
                message: Text("메모를 추가하려면 제목이 필요합니다."),
                dismissButton: .default(Text("확인"))
            )
        }
        .alert(isPresented: $showingContentAlert) {
            Alert(
                title: Text("내용을 입력해주세요."),
                message: Text("메모를 추가하려면 내용이 필요합니다."),
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

struct MemoCreateMainView: View {
    @Binding var memoTitle: String
    @Binding var memoContent: String
    
    var formattedToday: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("새로운 메모를\n추가해 보세요.")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.bk)
                    .padding(.leading, Constants.ControlWidth * 30)
                    .padding(.top, Constants.ControlHeight * 39)
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                TextField(text: $memoTitle) {
                    Text("제목을 입력하세요.")
                }
                .padding(.leading, Constants.ControlWidth * 30)
                .padding(.top, Constants.ControlHeight * 20)
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                
                TextEditor(text: $memoContent)
                    .foregroundColor(memoContent.isEmpty ? .iconOn : .bk) // 아이콘 색 or 일반 색
                    .frame(height: Constants.ControlHeight * 400)
                    .padding(.horizontal, Constants.ControlWidth * 25)
                    .padding(.top, Constants.ControlHeight * 20)
                    .overlay(
                        Group {
                            if memoContent.isEmpty {
                                Text("내용을 입력하세요.")
                                    .foregroundColor(.iconOn)
                                    .padding(.leading, Constants.ControlWidth * 30)
                                    .padding(.top, Constants.ControlHeight * 30)
                            }
                        }, alignment: .topLeading
                    )
                
                Spacer()
            }
            
            
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("현재 날짜 및 시간")
                        .font(.system(size: 16))
                        .foregroundColor(.iconOn)
                    Text(formattedToday)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.key)
                }
                
                Spacer()
            }
            .padding(.leading, Constants.ControlWidth * 30)
            .padding(.top, Constants.ControlHeight * 20)
            
            
            Spacer()
        }
    }
}

#Preview {
    MemoCreateView()
}
