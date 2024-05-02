//
//  ExternalProfileView.swift
//  MyMuze
//
//  Created by Pete Potipitak on 4/18/24.
//

import SwiftUI
import FirebaseAuth

struct ExternalProfileView: View {
    @EnvironmentObject var authManager: AuthManager;
    @State private var user: UserData = UserData(profilePicture: "", username: "", email: "", name: "", userID: "", phone: "", followers: [], following: [], privateAcc: false);
    @State private var loading = true;
    @State private var buttonLoading = false;
    let username: String;
    let uid: String;
    
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
                            // Temp profile pic
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 150, height: 150)
                                .background(Color.gray)
                                .clipShape(Circle())
                            Text(user.name)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .bold()
                                .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                            Text("@" + (user.username))
                                .foregroundColor(Color.gray)
                                .padding(.top, -10.0)
                                .frame(maxWidth: .infinity)
                            //                        .bold()
                                .font(.title3)
                            HStack {
                                if buttonLoading {
                                    Button (action: {})
                                    {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.5)
                                    }
                                } else if user.followers.contains(Auth.auth().currentUser!.uid) {
                                    Button(action: {
                                        handleUnfollow()
                                    })
                                    {
                                        Text("Unfollow")
                                            .foregroundColor(Color.myMuzeWhite)
                                            .padding(10)
                                            .background(Color.myMuzeAccent)
                                            .cornerRadius(10)
                                    }
                                } else {
                                    Button(action: {
                                        handleFollow()
                                    })
                                    {
                                        Text("Follow")
                                            .foregroundColor(Color.myMuzeWhite)
                                            .padding(10)
                                            .background(Color.myMuzeAccent)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            Divider()
                                .overlay(.gray)
                                .frame(height: 0.5)
                                .background(Color.white)
                            if user.privateAcc && !user.followers.contains(authManager.user){
                                Text("Private Account")
                                    .foregroundColor(Color.myMuzeAccent)
                                    .frame(maxWidth: .infinity)
                                    .bold()
                                    .font(.title3)
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color.myMuzeAccent)
                            } else {
                                HStack {
                                    Text("Following: " + String(user.following.count))
                                        .foregroundColor(Color.myMuzeAccent)
                                        .frame(maxWidth: .infinity)
                                        .bold()
                                        .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
                                    Text("Followers: " + String(user.followers.count))
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
                            }
                        }
                        Spacer()
                    }
                    .onAppear {
                        loading = true;
                        loadProfileData()
                    }
                )
        }
        .navigationBarTitle(username)
        .navigationBarTitleTextColor(.white)
    }
    
    func loadProfileData() {
        Task {
            do {
                user = try await getUser(uid: uid);
                if user.username == ""  {
                    print("User not found")
                } else {
                    loading = false
                }
            } catch {
                print("Error loading data:", error.localizedDescription)
            }
            
        }
        
    }
    
    func handleFollow() {
        // TO DO: Implement follow/unfollow functionality
        Task {
            buttonLoading = true;
            if !user.privateAcc {
                if try await checkNotificationExists(toUser: user.userID, fromUser: Auth.auth().currentUser!.uid, type: "follow") {
                    print("Notification already exists")
                } else {
                    let newNotification = Notification(type: "follow", timestamp: Date().description, uid: user.userID, receivingUID: Auth.auth().currentUser!.uid, user: authManager.user);
                    createNotification(notification: newNotification);
                }
                await addFollowerToUserData(uid: user.userID, followerUID: Auth.auth().currentUser!.uid);
                user.followers.append(Auth.auth().currentUser!.uid);
            } else {
                let newNotification = Notification(type: "accept", timestamp: Date().description, uid: user.userID, receivingUID: Auth.auth().currentUser!.uid, user: authManager.user);
                createNotification(notification: newNotification);
                // TODO: Create a request to follow if private, and change button to "Requested"
            }
            buttonLoading = false;
        }
    }
    
    func handleUnfollow() {
        // TO DO: Implement follow/unfollow functionality
        Task {
            buttonLoading = true;
            await removeFollowerFromUserData(uid: user.userID, followerUID: Auth.auth().currentUser!.uid);
            user.followers.removeAll(where: { $0 == Auth.auth().currentUser!.uid });
            buttonLoading = false;
        }
    }
}

#Preview {
    ExternalProfileView(username: "memememe", uid: "dbJeUbxManSwTAFM1WWx5eZh1Rf2")
}
