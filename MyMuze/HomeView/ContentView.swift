//
//  ContentView.swift
//  MyMuze
//
//  Created by Pete Potipitak on 1/23/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Color.black
            .ignoresSafeArea()
            .overlay(
                TabView {
                    Group {
                        HomeUI()
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
                        Text("Post")
                            .tabItem {
                                Label("Post", systemImage: "plus.circle.fill")
                            }
                        ProfileUI()
                            .tabItem {
                                Label("Profile", systemImage: "person.crop.circle.fill")
                            }
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(Color.gray, for: .tabBar
                    )
                }
                    .accentColor(Color("Accent Color"))
            )
    }
}

#Preview {
    ContentView()
}
