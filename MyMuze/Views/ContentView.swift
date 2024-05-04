//
//  ContentView.swift
//  MyMuze
//
//  Created by Pete Potipitak on 1/23/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    var body: some View {
        BackgroundView()
            .overlay(
                TabView {
                    Group {
                        HomeUI()
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
                        PostUI()
                            .tabItem {
                                Label("Post", systemImage: "plus.circle.fill")
                            }
                        ProfileUI()
                            .tabItem {
                                Label("Profile", systemImage: "person.crop.circle.fill")
                            }
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(Color.myMuzeTab, for: .tabBar)
                }
                    .accentColor(Color("Accent Color"))
            )
    }
}

#Preview {
    ContentView()
}
