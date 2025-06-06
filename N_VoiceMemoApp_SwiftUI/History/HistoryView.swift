//
//  HistoryView.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 6/7/25.
//

import SwiftUI

struct HistoryView: View {
    @StateObject var viewModel: HistoryViewModel = HistoryViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("History")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.bk)
                    .padding(.top, Constants.ControlHeight * 39)
                    .padding(.leading, Constants.ControlWidth * 30)
                    .padding(.bottom, Constants.ControlHeight * 54)
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                VStack(spacing: 10) {
                    Text("Todo")
                        .font(.system(size: 17))
                        .foregroundColor(.bk)
                    
                    Text("\(viewModel.todoCount)")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(.bk)
                }
                .frame(width: Constants.ControlWidth * 131)
                
                
                VStack(spacing: 10) {
                    Text("Memo")
                        .font(.system(size: 17))
                        .foregroundColor(.bk)
                    
                    Text("\(viewModel.memoCount)")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(.bk)
                }
                .frame(width: Constants.ControlWidth * 131)
                
                
                VStack(spacing: 10) {
                    Text("Recording")
                        .font(.system(size: 17))
                        .foregroundColor(.bk)
                    
                    Text("\(viewModel.recordingCount)")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(.bk)
                }
                .frame(width: Constants.ControlWidth * 131)
                
            }
            
            Spacer()
        }
        .onAppear(){
            viewModel.process(.loadData)
        }
    }
}

#Preview {
    HistoryView()
}
