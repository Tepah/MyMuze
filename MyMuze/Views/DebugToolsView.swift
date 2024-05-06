//
//  DebugToolsView.swift
//  MyMuze
//
//  Created by Pete Potipitak on 4/6/24.
//

import SwiftUI
import PhotosUI
import FirebaseAuth

struct DebugToolsView: View {
    @EnvironmentObject var authManager: AuthManager
    
    @State private var isShowingPhotoPicker = false
    @State private var selectedImage: UIImage?
    
    let profilePicURL: String
    
    var body: some View {
        BackgroundView()
            .overlay(
        VStack {
            // Profile Picture Change
            PictureChanger(selectedImage: $selectedImage, profilePicURL: profilePicURL)
            
            Button("Save") {
                Task {
                    if let image = selectedImage {
                        let uid = Auth.auth().currentUser?.uid ?? "temp";
                        let profilePicURL = await uploadImageToStorage(image: image, userID: uid);
                        await updateProfilePictureUrl(uid: uid, profilePicURL: profilePicURL);
                    }
                }
            }
            
            // Sign Out Button
            Button(action: {
                do {
                    // Set isLoggedIn to false
                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
                    UserDefaults.standard.set("", forKey: "uid")
                    authManager.userExists = nil
                    authManager.user = ""
                    try Auth.auth().signOut()
                } catch {
                    print("Error signing out: \(error.localizedDescription)")
                }
            }) {
                Rectangle()
                    .foregroundColor(Color.red)
                    .frame(width: 200, height: 50)
                    .cornerRadius(10)
                    .overlay(
                        Text("Sign Out")
                            .foregroundColor(Color.white)
                            .font(.title)
                    )
            }
//            Text("Notifcations")
//                .foregroundColor(Color.white)
//                .font(.title)
//            HStack {
//                Button(action: {
//                    // Make a follower notification (No actual new follower)
//                    let uid = Auth.auth().currentUser?.uid ?? "temp"
//                    print(uid)
//                    let notification = Notification(type: "follow", timestamp: Date().description, uid: uid, receivingUID: "temp", user: "temp")
//                    
//                    createNotification(notification: notification)
//                }) {
//                    Rectangle()
//                        .foregroundColor(Color.green)
//                        .frame(width: 80, height: 30)
//                        .cornerRadius(10)
//                        .overlay(
//                            Text("follower")
//                                .foregroundColor(Color.white)
//                        )
//                }
//                Button(action: {
//                    // Make a request Notification (New request will allow a fake follower)
//                    let uid = Auth.auth().currentUser?.uid ?? "temp"
//                    print(authManager.user);
//                    let notification = Notification(type: "request", timestamp: Date().description, uid: uid, receivingUID: "temp", user: "user", currentUser: authManager.user)
//                    createNotification(notification: notification)
//                }) {
//                    Rectangle()
//                        .foregroundColor(Color.green)
//                        .frame(width: 80, height: 30)
//                        .cornerRadius(10)
//                        .overlay(
//                            Text("request")
//                                .foregroundColor(Color.white)
//                        )
//                }
//                Button(action: {
//                    // Make a comment Notification (On a fake post)
//                    let uid = Auth.auth().currentUser?.uid ?? "temp"
//                    let notification = Notification(type: "comment", timestamp: Data().description, uid: uid, receivingUID: "temp", message: "This is a message", user: "temp", postID: "fakeID")
//                    
//                    createNotification(notification: notification)
//                }) {
//                    Rectangle()
//                        .foregroundColor(Color.green)
//                        .frame(width: 80, height: 30)
//                        .cornerRadius(10)
//                        .overlay(
//                            Text("comment")
//                                .foregroundColor(Color.white)
//                        )
//                }
//                Button(action: {
//                    // Make a comment Notification (On a fake post)
//                    let uid = Auth.auth().currentUser?.uid ?? "temp"
//                    let notification = Notification(type: "like", timestamp: Data().description, uid: uid, receivingUID: "temp", user: "temp", postID: "fakeID")
//                    
//                    createNotification(notification: notification)
//                }) {
//                    Rectangle()
//                        .foregroundColor(Color.green)
//                        .frame(width: 80, height: 30)
//                        .cornerRadius(10)
//                        .overlay(
//                            Text("like")
//                                .foregroundColor(Color.white)
//                        )
//                }
//            }
        }
        )
    }
}

