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

struct LoginBackgroundView: View {
    @State private var yOffset: CGFloat = -200
    @State private var opacity: CGFloat = 0.1
    @State private var middleYoffset: CGFloat = 250
    
    var body: some View {
        LinearGradient(colors: [Color(hex: 0x121212), Color.myMuzeBlack], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            .overlay(
                VStack {
                    ZStack {
                        Image(systemName: "music.note")
                            .font(.system(size: 100))
                            .foregroundColor(.gray)
                            .offset(x: 0, y: middleYoffset)
                            .opacity(opacity)
                            .animation(.linear(duration: 2.0).repeatForever(autoreverses: true))
                            .onAppear() {
                                withAnimation {
                                    middleYoffset = CGFloat(260)
                                }
                            }
                        Image(systemName: "music.note")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                            .offset(x: -150, y: yOffset)
                            .opacity(opacity)
                            .animation(.linear(duration: 4.0).repeatForever(autoreverses: false))
                            .onAppear() {
                                withAnimation {
                                    yOffset = CGFloat(1000)
                                    opacity = 0.4
                                }
                            }
                        Image(systemName: "music.note")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                            .offset(x: 100, y: yOffset)
                            .opacity(opacity)
                            .animation(.linear(duration: 4.5).repeatForever(autoreverses: false))
                            .onAppear() {
                                withAnimation {
                                    yOffset = CGFloat(1000)
                                    opacity = 0.4
                                }
                            }
                        Image(systemName: "music.note")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .offset(x: 50, y: yOffset)
                            .animation(.linear(duration: 3.0).repeatForever(autoreverses: false))
                            .opacity(opacity)
                            .onAppear() {
                                withAnimation {
                                    yOffset = CGFloat(1000)
                                    opacity = 0.4
                                }
                            }
                        Image(systemName: "music.note")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                            .offset(x: -100, y: yOffset)
                            .opacity(opacity)
                            .animation(.linear(duration: 6.0).repeatForever(autoreverses: false))
                            .onAppear() {
                                withAnimation {
                                    yOffset = CGFloat(1000)
                                    opacity = 0.4
                                }
                            }
                        Image(systemName: "music.note")
                            .font(.system(size: 70))
                            .foregroundColor(.gray)
                            .offset(x: 160, y: yOffset)
                            .opacity(opacity)
                            .animation(.linear(duration: 5.0).repeatForever(autoreverses: false))
                            .onAppear() {
                                withAnimation {
                                    yOffset = CGFloat(1000)
                                }
                            }
                    }
                    .offset(x: 0, y: -100)
                    Spacer()
                    }
                )
            }
    
    func startAnimatingY() {
        yOffset = -UIScreen.main.bounds.height // Start above the screen
                
                Timer.scheduledTimer(withTimeInterval: 6.0, repeats: true) { _ in
                    
                    withAnimation(.linear(duration: 6.0)) {
                        yOffset = UIScreen.main.bounds.height // Move to the bottom of the screen
                    }
                }
            }
}

#Preview {
    LoginBackgroundView()
}
