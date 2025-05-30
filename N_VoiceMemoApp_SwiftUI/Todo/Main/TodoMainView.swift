//
//  TodoMainView.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 5/29/25.
//

import SwiftUI

struct TodoMainView: View {
    @StateObject var viewModel: TodoMainViewModel = TodoMainViewModel()
    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("To do list를\n추가해 보세요.")
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 26, weight: .bold))
                        .padding(.leading, Constants.ControlWidth * 30)
                        .padding(.top, Constants.ControlHeight * 39)
                    
                    Spacer()
                }
                
                if viewModel.todoViewModels.isEmpty {
                    TodoListEmptyView()
                } else {
                    TodoListView(viewModel: viewModel)
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

struct TodoListView: View {
    @ObservedObject var viewModel: TodoMainViewModel
    @State private var showingDeleteAlert = false
    @State private var selectedTodoID: String?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("할일 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, Constants.ControlWidth * 30)
                    .padding(.top, Constants.ControlHeight * 23)
                
                Spacer()
            }
            .padding(.bottom, Constants.ControlHeight * 5)
            
            
            ForEach(Array(viewModel.todoViewModels.enumerated()), id: \.element.id) { index, todo in
                VStack(spacing: 0) {
                    if index == 0 {
                        Rectangle()
                            .fill(Color.gray1)
                            .frame(height: 1)
                    }
                    
                    HStack(spacing: 0) {
                        Image("Check_Off")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Constants.ControlWidth * 25)
                            .padding(.leading, Constants.ControlWidth * 50)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(todo.title)
                                .font(.system(size: 16))
                                .foregroundColor(.bk)
                            
                            Text("\(todo.date) - \(todo.time)")
                                .font(.system(size: 12))
                                .foregroundColor(.iconOn)
                        }
                        .padding(.leading, Constants.ControlWidth * 19)
                        .onLongPressGesture {
                                    selectedTodoID = todo.id
                                    showingDeleteAlert = true
                                }
                        
                        Spacer()
                    }
                    .padding(.top, Constants.ControlHeight * 10)
                    .padding(.bottom, Constants.ControlHeight * 10)
                    .alert(isPresented: $showingDeleteAlert) {
                        Alert(
                            title: Text("삭제하시겠습니까?"),
                            message: Text("\(todo.title) 할 일을 삭제하면\n복구할 수 없습니다."),
                            primaryButton: .destructive(Text("삭제")) {
                                if let id = selectedTodoID {
                                    viewModel.process(.deleteTodo(id))
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

struct TodoListEmptyView: View {
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
            
            Image("Todo_Pencil")
            
            Text("""
                 "매일 아침 8시 운동가라고 알려줘"
                 "내일 8시 수강 신청하라고 알려줘"
                 "1시 반 점심약속 리마인드 해줘"
                 """)
            .font(.system(size: 14))
            .foregroundColor(.gray2)
            .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}


#Preview {
    TodoMainView()
}
