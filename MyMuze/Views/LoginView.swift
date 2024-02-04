//
//  LoginView.swift
//  MyMuze
//
//  Created by Pete Potipitak on 1/30/24.
//

import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
    var body: some View {
        BackgroundView()
            .overlay (
            VStack {
                Spacer()
                Text("MyMuze")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(100)
                Spacer()
                Button (action: {
                    
                }) {
                    Image("AppleButton")
                        .aspectRatio(contentMode: .fit)
                }
                .padding(5)
                Button (action: {
                    
                }) {
                    Image("GoogleButton")
                        .aspectRatio(contentMode: .fit)
                }
                .padding(5)
                Text("or")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                Button (action: {
                    
                }) {
                    Rectangle()
                        .foregroundColor(Color(hex:0x24CF63))
                        .frame(width:200, height:60)
                        .overlay(
                            Text("Sign in with Phone")
                                .foregroundColor(.black)
                                .fontWeight(.medium)
                                .font(.system(size:20))
                        )
                }
                HStack {
                    Text("No account?")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                    Text("Sign up")
                        .foregroundColor(Color(hex:0x24CF63))
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                }
                .padding(30)
                Spacer()
            }
                .padding()
        )
    }
}

#Preview {
    LoginView()
}
