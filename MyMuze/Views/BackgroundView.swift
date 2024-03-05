//
//  BackgroundView.swift
//  MyMuze
//
//  Created by Pete Potipitak on 2/2/24.
//

import SwiftUI

struct BackgroundView: View {
    // Background View used for entirety of the app
    var body: some View {
        LinearGradient(colors: [Color(hex: 0x121212), Color.myMuzeBlack], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
