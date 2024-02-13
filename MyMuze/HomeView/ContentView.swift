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
                VStack {
                    Image(systemName: "music.note")
                        .foregroundColor(Color("Accent Color"))
                        .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("MyMuze")
                        .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                        .fontWeight(.bold)
                        .foregroundColor(Color("Accent Color"))
            }
            .padding())
        
    }
}

#Preview {
    ContentView()
}
