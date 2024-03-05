//
//  LoginView.swift
//  MyMuze
//
//  Created by Pete Potipitak on 1/30/24.
//

import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
    // Login Page View
    var body: some View {
        NavigationView {
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
                                .foregroundColor(Color.myMuzeAccent)
                                .frame(width:200, height:60)
                                .overlay(
                                    NavigationLink(destination: PhoneSignInView(), label: {
                                        Text("Sign in with Phone")
                                            .foregroundColor(.black)
                                            .fontWeight(.medium)
                                            .font(.system(size:20))
                                    })
                                )
                        }
                        HStack {
                            Text("No account?")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                            NavigationLink(destination: PhoneSignInView(), label: {
                                Text("Sign Up")
                                .foregroundColor(Color.myMuzeAccent)
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                            })
                        }
                        .padding(30)
                        Spacer()
                    }
                )
        }
    }
}

#Preview {
    LoginView()
}
