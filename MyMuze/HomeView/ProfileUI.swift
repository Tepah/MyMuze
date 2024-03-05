//
//  ProfileUI.swift
//  MyMuze
//
//  Created by Diamond Ly on 2/22/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileUI: View {
    var body: some View {
        BackgroundView()
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
                    Button("Temporary Logout button for testing") {
                        do {
                            try Auth.auth().signOut()
                            // Set isLoggedIn to false
                            UserDefaults.standard.set(false, forKey: "isLoggedIn")
                        } catch {
                            print("Error signing out: \(error.localizedDescription)")
                        }
                    }
                }
            )
        }
}

#Preview {
    ProfileUI()
}
