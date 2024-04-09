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
                VStack (spacing: 15) {
                    Text("Profile")
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                        .padding(.leading, 10.0)
                    Divider()
                        .overlay(.white)
                        .frame(height: 2)
                        .background(Color.white)
                    // Temp profile pic
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .background(Color.gray)
                        .clipShape(Circle())
                    Text(currentUser?.name ?? "DisplayName")
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .bold()
                        .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                    Text("@" + (currentUser?.username ?? "username"))
                        .foregroundColor(Color.gray)
                        .padding(.top, -10.0)
                        .frame(maxWidth: .infinity)
//                        .bold()
                        .font(.title3)
                    Divider()
                        .overlay(.gray)
                        .frame(height: 0.5)
                        .background(Color.white)
                    HStack {
                        Text("Following: " + String(currentUser?.following.count ?? -1))
                            .foregroundColor(Color.myMuzeAccent)
                            .frame(maxWidth: .infinity)
                            .bold()
                            .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
                        Text("Following: " + String(currentUser?.followers.count ?? -1))
                            .foregroundColor(Color.myMuzeAccent)
                            .frame(maxWidth: .infinity)
                            .bold()
                            .font(.title3)
                    }
                    Divider()
                        .overlay(.gray)
                        .frame(height: 0.5)
                        .background(Color.white)
                    Text("Profile Playlist:")
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10.0)
                        .bold()
                        .underline()
                        .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                    // Playlist will show here
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
                    currentUser = try await getUser(uid: uid)
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
