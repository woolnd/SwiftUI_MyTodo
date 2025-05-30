//
//  TodoCreateView.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 5/30/25.
//

import SwiftUI

struct TodoCreateView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: TodoCreateViewModel = TodoCreateViewModel()
    
    @State private var todoTitle: String = ""
    @State private var todoTime = Date()
    @State private var showingAlert = false
    var formattedToday: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 (E)" // 예: 2025년 5월 30일 금요일
        return formatter.string(from: Date())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TodoCreateMainView(todoTitle: $todoTitle, todoTime: $todoTime, formattedToday: formattedToday)
            
            Button {
                
                
                guard !todoTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
                    showingAlert = true
                    return
                }
                
                let newTodo = todo(
                    id: UUID().uuidString,
                    title: todoTitle,
                    date: formattedToday,
                    time: formattedTimeString(from: todoTime),
                    isCompleted: false
                )
                
                viewModel.process(.createTodo(newTodo)) { success in
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
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("제목을 입력해주세요."),
                message: Text("할 일을 추가하려면 제목이 필요합니다."),
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
    
    func formattedTimeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분" // 예: 오후 7시 30분
        return formatter.string(from: date)
    }
}

struct TodoCreateMainView: View {
    @Binding var todoTitle: String
    @Binding var todoTime: Date
    
    var formattedToday: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("새로운 Todo를\n추가해 보세요.")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.bk)
                    .padding(.leading, Constants.ControlWidth * 30)
                    .padding(.top, Constants.ControlHeight * 39)
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                TextField(text: $todoTitle) {
                    Text("제목을 입력하세요.")
                }
                .padding(.leading, Constants.ControlWidth * 30)
                .padding(.top, Constants.ControlHeight * 20)
                
                Spacer()
            }
            
            DatePicker("", selection: $todoTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .environment(\.locale, Locale(identifier: "ko_KR"))
            
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("날짜")
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
    TodoCreateView()
}
