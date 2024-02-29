//
//  ProfileUI.swift
//  MyMuze
//
//  Created by Diamond Ly on 2/22/24.
//

import SwiftUI

struct ProfileUI: View {
    var body: some View {
        Color.black
            .ignoresSafeArea()
            .overlay(
                VStack {
                    Text("User Profile")
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                        .padding([.leading, .bottom], 10.0)
                    Divider()
                        .overlay(.white)
                        .frame(height: 2)
                        .background(Color.white)
                    Spacer()
                }
            )
        }
}

#Preview {
    ProfileUI()
}
