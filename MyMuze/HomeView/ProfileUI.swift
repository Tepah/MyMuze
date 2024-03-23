//
//  ProfileUI.swift
//  MyMuze
//
//  Created by Diamond Ly on 2/22/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileUI: View {
    @EnvironmentObject var authManager: AuthManager
    
    @State private var uid: String = ""
    @State private var currentUser: UserData? = nil
    
    var body: some View {
        BackgroundView()
            .overlay(
                VStack {
                    Text("@" + (currentUser?.username ?? "Current User"))
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
                            // Set isLoggedIn to false
                            UserDefaults.standard.set(false, forKey: "isLoggedIn")
                            UserDefaults.standard.set("", forKey: "uid")
                            authManager.userExists = nil
                            try Auth.auth().signOut()
                        } catch {
                            print("Error signing out: \(error.localizedDescription)")
                        }
                    }
                }
                    .onAppear {
                        loadProfileData()
                    }
            )
        }
    
    func loadProfileData() {
        Task {
            do {
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    currentUser = try await getCurrentUserInfo(uid: uid)
                }
            } catch {
                    print("Error loading data:", error.localizedDescription)
            }
            
        }
        
    }
}

#Preview {
    ProfileUI()
}
