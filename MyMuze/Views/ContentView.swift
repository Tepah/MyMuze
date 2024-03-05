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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Logout") {
                do {
                    try Auth.auth().signOut()
                    // Set isLoggedIn to false
                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
                } catch {
                    print("Error signing out: \(error.localizedDescription)")
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
