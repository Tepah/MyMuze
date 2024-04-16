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
    @State var notifications: [Notification]
    let user = Auth.auth().currentUser
    
    init (notifications: [Notification]) {
        self.notifications = notifications;
        print(self.notifications.count);
    }
    
    var body: some View {
        BackgroundView()
            .overlay(
                VStack {
                    HStack {
                        Spacer()
                        if notifications.count > 0 {
                            Button(action: {
                                handleClearAll()
                            }) {
                                Rectangle()
                                    .frame(width: 80, height: 30)
                                    .cornerRadius(10)
                                    .foregroundColor(Color.myMuzeGrey)
                                    .overlay(
                                        Text("Clear")
                                            .foregroundColor(Color.myMuzeWhite)
                                    )
                            }
                            .padding(15)
                        }
                    }
                    List(notifications, id: \.self.notificationID) { notification in
                        NotificationRow(notification: notification)
                            .listRowBackground(Color.clear)
                            .padding(5)
                            .gesture(
                                DragGesture()
                                    .onEnded { gesture in
                                        if gesture.translation.width < -100 || gesture.translation.width > 100 {
                                            handleNotificationSwipe(notification: notification)
                                        }
                                    }
                            )
                    }
                    .listStyle(PlainListStyle())
                    Spacer()
                }
                .navigationBarTitle("Notifications")
                .navigationBarTitleTextColor(.white)
            )
    }
    
    func handleNotificationSwipe(notification: Notification) {
        deleteNotification(notification: notification.notificationID!);
        notifications.removeAll { $0.notificationID == notification.notificationID }
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
                } else if notification.type == "confirm" {
                    newConfirm(notification: notification)
                } else if notification.type == "request" {
                    newRequest(notification: notification)
                }
                Spacer()
            }
        }
    }
    
    /// Creates the newLike notification used in NotificationRows to display a new like notification.
    ///
    /// - Parameters:
    ///     - notification: The notification data needing user and Post
    /// - Returns: A view that displays a new Like Notification
    struct newLike: View {
        let user: String
        let post: String
        
        init(notification: Notification) {
            self.user = notification.user!
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
                    Text(user)
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
    
    /// Creates the confirmFollow notification used in NotificationRows to display a Confirmed Follow notification.
    ///
    /// - Parameters:
    ///     - notification: The notification data needing user
    /// - Returns: A view that displays a new Confirmed following
    struct newConfirm: View {
        let user: String
        
        init(notification: Notification) {
            self.user = notification.user!
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
                    Text(user)
                        .foregroundColor(Color.myMuzeAccent) +
                    Text(" accepted your follow.")
                        .foregroundColor(Color.myMuzeWhite)
                }
                Spacer()
            }
        }
    }
    
    /// Creates the request notification used in NotificationRows to display a Confirmed request notification.
    ///
    /// - Parameters:
    ///     - notification: The notification data needing user
    /// - Returns: A view that displays a new request following
    struct newRequest: View {
        let notification: Notification
        
        init(notification: Notification) {
            self.notification = notification
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
                    Text(notification.user!)
                        .foregroundColor(Color.myMuzeAccent) +
                    Text(" wants to follow you.")
                        .foregroundColor(Color.myMuzeWhite)
                }
                Spacer()
                VStack {
                    Rectangle()
                        .frame(width: 80, height: 30)
                        .cornerRadius(10)
                        .foregroundColor(Color.myMuzeAccent)
                        .overlay(
                            Text("Accept")
                                .foregroundColor(Color.myMuzeWhite)
                        )
                        .onTapGesture {
                            // Handle Accepting request
                        }
                    Rectangle()
                        .frame(width: 80, height: 30)
                        .cornerRadius(10)
                        .foregroundColor(Color.myMuzeGrey)
                        .overlay(
                            Text("Decline")
                                .foregroundColor(Color.myMuzeWhite)
                        )
                        .onTapGesture {
                            // Handle Declining request
                        }
                }
                .frame(width: 50, height: 50)
            }
        }
    }
    
    /// Creates the newComment notification used in NotificationRows to display a new comment notification.
    ///
    /// - Parameters:
    ///     - notification: The notification data needing user, postID, and message
    /// - Returns: A view that displays a new comment Notification
    struct newComment: View {
        let user: String
        let postID: String
        let message: String
        
        init(notification: Notification) {
            self.user = notification.user!
            self.postID = notification.postID!
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
                    Text(user)
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
    
    /// Creates the newFollower notification used in NotificationRows to display a new follower notification.
    ///
    /// - Parameters:
    ///     - notification: The notification data needing user
    /// - Returns: A view that displays a new follower Notification
    struct newFollower: View {
        let user: String
        
        init(notification: Notification) {
            self.user = notification.user!
            print(self.user)
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
                    Text(user)
                        .foregroundColor(Color.myMuzeAccent) +
                    Text(" started following you")
                        .foregroundColor(Color.myMuzeWhite)
                }
                Spacer()
            }
        }
    }
    
    /// Handles the clear all button in the NotificationsView
    func handleClearAll() {
        while notifications.count > 0 {
            handleNotificationSwipe(notification: notifications[0])
        }
    }
                
    func loadProfileData() {
        
    }
}

#Preview {
    NotificationsView(notifications: [Notification]())
}
