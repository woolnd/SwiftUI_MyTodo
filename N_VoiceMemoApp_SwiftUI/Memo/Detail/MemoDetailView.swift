//
//  MemoDetailView.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 6/2/25.
//

import SwiftUI

struct MemoDetailView: View {
    let memo: memo?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if let title = memo?.title {
                    Text("\(title)")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.bk)
                }
                
                Spacer()
            }
            .padding(.top, Constants.ControlHeight * 39)
            .padding(.leading, Constants.ControlWidth * 30)
            
            HStack(spacing: 0) {
                if let date = memo?.date{
                    Text("\(date)")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.key)
                }
                
                Spacer()
            }
            .padding(.top, Constants.ControlHeight * 20)
            .padding(.leading, Constants.ControlWidth * 30)
            .padding(.trailing, Constants.ControlWidth * 30)
            
            HStack(spacing: 0) {
                if let content = memo?.content{
                    Text("\(content)")
                        .font(.system(size: 17))
                        .foregroundColor(.bk)
                }
                
                Spacer()
            }
            .padding(.top, Constants.ControlHeight * 30)
            .padding(.leading, Constants.ControlWidth * 30)
            
            
            Spacer()
        }
    }
}

#Preview {
    MemoDetailView(memo: memo(id: "", title: "", content: "", date: ""))
}
