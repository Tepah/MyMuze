//
//  BackgroundView.swift
//  MyMuze
//
//  Created by Pete Potipitak on 2/2/24.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(colors: [Color(hex: 0x121212), Color(hex:0x1E1E1E)], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
