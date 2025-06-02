//
//  MemoMainView.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 6/2/25.
//

import SwiftUI

struct MemoMainView: View {
    @StateObject var viewModel: MemoMainViewModel = MemoMainViewModel()
    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("메모를\n추가해 보세요.")
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 26, weight: .bold))
                        .padding(.leading, Constants.ControlWidth * 30)
                        .padding(.top, Constants.ControlHeight * 39)
                    
                    Spacer()
                }
                
                if viewModel.memoViewModels.isEmpty {
                    MemoListEmptyView()
                } else {
                    MemoListView(viewModel: viewModel)
                }
                
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                
                Spacer()
                
                HStack(spacing: 0) {
                    
                    Spacer()
                    
                    Button {
                        AppState.shared.push(.memo(.create))
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

struct MemoListView: View {
    @ObservedObject var viewModel: MemoMainViewModel
    @State private var showingDeleteAlert = false
    @State private var selectedMemoID: String?
    @State private var selectedMemo: memo?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("메모 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, Constants.ControlWidth * 30)
                    .padding(.top, Constants.ControlHeight * 23)
                
                Spacer()
            }
            .padding(.bottom, Constants.ControlHeight * 5)
            
            
            ForEach(Array(viewModel.memoViewModels.enumerated()), id: \.element.id) { index, memo in
                VStack(spacing: 0) {
                    if index == 0 {
                        Rectangle()
                            .fill(Color.gray1)
                            .frame(height: 1)
                    }
                    
                    Button(action: {
                        selectedMemo = memo
                    }, label: {
                        HStack(spacing: 0) {
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(memo.title)
                                    .font(.system(size: 16))
                                    .foregroundColor(.bk)
                                
                                Text("\(memo.date)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.iconOn)
                            }
                            .padding(.leading, Constants.ControlWidth * 30)
                            .onLongPressGesture {
                                selectedMemoID = memo.id
                                showingDeleteAlert = true
                            }
                            
                            Spacer()
                        }
                    })
                    .padding(.top, Constants.ControlHeight * 10)
                    .padding(.bottom, Constants.ControlHeight * 10)
                    .alert(isPresented: $showingDeleteAlert) {
                        Alert(
                            title: Text("삭제하시겠습니까?"),
                            message: Text("\(memo.title) 메모를 삭제하면\n복구할 수 없습니다."),
                            primaryButton: .destructive(Text("삭제")) {
                                if let id = selectedMemoID {
                                    viewModel.process(.deleteMemo(id))
                                }
                            },
                            secondaryButton: .cancel(Text("취소"))
                        )
                    }
                    .sheet(item: $selectedMemo) { memo in
                        MemoDetailView(memo: memo)
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

struct MemoListEmptyView: View {
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
            
            Image("Todo_Pencil")
            
            Text("""
                 “퇴근 9시간 전 메모”
                 “기획서 작성 후 퇴근하기 메모”
                 “밀린 집안일 하기 메모"
                 """)
            .font(.system(size: 14))
            .foregroundColor(.gray2)
            .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}

#Preview {
    MemoMainView()
}
