//
//  NotificationsView.swift
//  MyMuze
//
//  Created by Pete Potipitak on 4/5/24.
//

import SwiftUI
import FirebaseAuth
import URLImage

struct NotificationsView: View {
    let user = Auth.auth().currentUser
    let tempNotifications = [Notification(type: "follow", timestamp: "Timestamp", uid: "", follower: "pete"),
                             Notification(type: "like", timestamp: "PostID", uid: "like", message: "Timestamp", follower: "somebody", postID: ""),
                             Notification(type: "comment", timestamp: "Time", uid: "uid", message: "i luv that song so much it's so great", follower: "Peter", postID: "UID")]
    
    var body: some View {
        BackgroundView()
            .overlay(
                VStack {
                    List(0..<3) {i in
                        NotificationRow(notification: tempNotifications[i])
                            .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                    Spacer()
                }
                .navigationBarTitle("Notifications")
                .navigationBarTitleTextColor(.white)
            )
    }
    
    struct NotificationRow: View {
        let notification: Notification
        
        init (notification: Notification) {
            self.notification = notification
        }
        
        var body: some View {
            HStack {
                if notification.type == "follow" {
                    newFollower(notification: notification)
                } else if notification.type == "like" {
                    newLike(notification: notification)
                } else if notification.type == "comment" {
                    newComment(notification: notification)
                }
                Spacer()
            }
        }
    }
    
    struct newLike: View {
        let follower: String
        let post: String
        
        init(notification: Notification) {
            self.follower = notification.follower!
            self.post = notification.postID!
        }
        
        var body: some View {
            HStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(10)
                    .background(Color.myMuzeBlack)
                    .clipShape(Circle())
                Spacer()
                VStack {
                    Text(follower)
                        .foregroundColor(Color.myMuzeAccent) +
                    Text(" liked your post")
                        .foregroundColor(Color.myMuzeWhite)
                }
                Spacer()
                // Temporary Album pic, replace with actual post image
                URLImage(URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHJdk6qqLMTD2e8MMYZwTq1jsK71M3MLsC_FGLc93dAA&s")!) { image in
                    image
                        .resizable()
                        .frame(width: 55, height: 55)
                        .cornerRadius(10)
                        .padding(5)
                        .overlay(
                            Image(systemName: "heart.fill")
                                .scaleEffect(1.5)
                                .foregroundColor(Color.myMuzeAccent)
                                .rotationEffect(.degrees(-25))
                                .offset(x:25, y:20)
                        )
                }
            }
        }
    }
    
    struct newComment: View {
        let follower: String
        let post: String
        let message: String
        
        init(notification: Notification) {
            self.follower = notification.follower!
            self.post = notification.postID!
            self.message = notification.message!
        }
        
        var body: some View {
            HStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(10)
                    .background(Color.myMuzeBlack)
                    .clipShape(Circle())
                Spacer()
                VStack {
                    Text(follower)
                        .foregroundColor(Color.myMuzeAccent) +
                    Text(" commented: ")
                        .foregroundColor(Color.myMuzeWhite)
                    Text(message)
                        .foregroundColor(Color.myMuzeWhite)
                        .lineLimit(1)
                        .font(.system(size: 12))
                }
                Spacer()
                URLImage(URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHJdk6qqLMTD2e8MMYZwTq1jsK71M3MLsC_FGLc93dAA&s")!) { image in
                    image
                        .resizable()
                        .frame(width: 55, height: 55)
                        .cornerRadius(10)
                        .padding(5)
                        .overlay(
                            Image(systemName: "text.bubble.fill")
                                .scaleEffect(1.5)
                                .foregroundColor(Color.myMuzeAccent)
                                .rotationEffect(.degrees(-15))
                                .offset(x:25, y:20)
                        )
                }
            }
        }
    }
    
    struct newFollower: View {
        let follower: String
        
        init(notification: Notification) {
            self.follower = notification.follower!
        }
        var body: some View {
            HStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(10)
                    .background(Color.myMuzeBlack)
                    .clipShape(Circle())
                Spacer()
                VStack {
                    Text(follower)
                        .foregroundColor(Color.myMuzeAccent) +
                    Text(" started following you")
                        .foregroundColor(Color.myMuzeWhite)
                }
                Spacer()
            }
        }
    }
                
    func loadProfileData() {
        
    }
}

#Preview {
    NotificationsView()
}
