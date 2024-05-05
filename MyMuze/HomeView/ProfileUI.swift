//
//  ProfileUI.swift
//  MyMuze
//
//  Created by Diamond Ly on 2/22/24.
//

import SwiftUI
import FirebaseAuth
import URLImage

struct ProfileUI: View {
    @State private var uid: String = ""
    @State private var currentUser: UserData? = nil
    @State var loading = true
    
    var body: some View {
        NavigationView {
            BackgroundView()
                .overlay(
                    VStack (spacing: 15) {
                        if loading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(2)
                        } else {
                            HStack {
                                Text("Profile")
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .bold()
                                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                                    .padding(.leading, 10.0)
                                Spacer()
                                NavigationLink(destination: DebugToolsView(profilePicURL: currentUser!.profilePicture)) {
                                    Image(systemName: "gearshape.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(Color.white)
                                        .padding(10)
                                }
                            }
                            Divider()
                                .overlay(.white)
                                .frame(height: 2)
                                .background(Color.white)
                            if self.currentUser!.profilePicture == "" {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .background(Color.gray)
                                    .clipShape(Circle())
                            } else {
                                URLImage(URL(string: self.currentUser!.profilePicture)!) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                            }
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
                                Text("Followers: " + String(currentUser?.followers.count ?? -1))
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
                        }
                    }
                )
                .onAppear() {
                    loading = true;
                    loadProfileData();
                }
        }
        }
    
    func loadProfileData() {
        Task {
            do {
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    currentUser = try await getUser(uid: uid)
                }
                loading = false;
            } catch {
                    print("Error loading data:", error.localizedDescription)
            }
            
        }
        
    }
}

#Preview {
    ProfileUI()
}
