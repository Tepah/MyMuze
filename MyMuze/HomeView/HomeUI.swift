//
//  HomeUI.swift
//  MyMuze
//
//  Created by Diamond Ly on 2/13/24.
//

import SwiftUI

struct HomeUI: View {
    var body: some View {
        Color.black
            .ignoresSafeArea()
            .overlay(
                VStack {
                    Text("Home")
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.leading)
                        .bold()
                        .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                        .padding(.trailing, 250.0)
                    Divider()
                        .overlay(.white)
                    Spacer()
                }
        )
    }
}

#Preview {
    HomeUI()
}
