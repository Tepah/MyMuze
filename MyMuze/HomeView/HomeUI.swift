//
//  HomeUI.swift
//  MyMuze
//
//  Created by Diamond Ly on 2/13/24.
//

import SwiftUI

struct HomeUI: View {
    var body: some View {
        NavigationView {
            Color.black
                .ignoresSafeArea()
                .overlay(
                    VStack {
                        Text("Home")
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                            .padding([.leading, .bottom], 10.0)
                        Divider()
                            .overlay(.white)
                            .frame(height: 2)
                            .background(Color.white)
                        
                        ZStack {
                            VStack{
                                NavigationLink(destination: ProfileUI()) {
                                    Text("@diamondly")
                                        .foregroundColor(Color("Accent Color"))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .fontWeight(.bold)
                                }
                                Text("THE END")
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: . infinity, alignment: .topLeading)
                                Text("Alesso, Charlotte Lawrence")
                                    .foregroundColor(Color.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.leading, 10.0)
                        }
                        Divider()
                            .overlay(.white)
                        
                        ZStack {
                            VStack{
                                NavigationLink(destination: ProfileUI()) {
                                    Text("@potipitak")
                                        .foregroundColor(Color("Accent Color"))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .fontWeight(.bold)
                                }
                                Text("golden hour - Fujii Kaze Remix")
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: . infinity, alignment: .topLeading)
                                Text("JVKE, Fujii Kaze")
                                    .foregroundColor(Color.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.leading, 10.0)
                        }
                        Divider()
                            .overlay(.white)
                        
                        ZStack {
                            VStack{
                                NavigationLink(destination: ProfileUI()) {
                                    Text("@dave123")
                                        .foregroundColor(Color("Accent Color"))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .fontWeight(.bold)
                                }
                                Text("Use Somebody")
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: . infinity, alignment: .topLeading)
                                Text("Kings of Leon")
                                    .foregroundColor(Color.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.leading, 10.0)
                        Divider()
                            .overlay(.white)
                        
                        Spacer()
                    }
                )
        }
    }
}
#Preview {
    HomeUI()
}
