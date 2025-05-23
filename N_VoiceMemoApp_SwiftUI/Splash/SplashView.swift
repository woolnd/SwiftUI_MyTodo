//
//  SplashView.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 5/23/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: Constants.ControlWidth * 250)
    }
}

#Preview {
    SplashView()
}
