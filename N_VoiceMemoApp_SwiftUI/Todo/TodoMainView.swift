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
        .onAppear(){
            viewModel.process(.loadData)
        }
    }
}

struct TodoListView: View {
    @ObservedObject var viewModel: TodoMainViewModel
    
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
            
            
            ForEach(viewModel.todoViewModels) { todo in
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
                    
                    Spacer()
                }
                .padding(.top, Constants.ControlHeight * 5)
                .padding(.bottom, Constants.ControlHeight * 5)
                .border(.gray1, width: 1)
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
