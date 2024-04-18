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
                        NotificationRow(notifications: $notifications, notification: notification)
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
        @Binding var notifications: [Notification]
        let notification: Notification
        
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
                    newRequest(notifications: $notifications, notification: notification)
                } else if notification.type == "accept" {
                    newAccept(notification: notification)
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
        let notification: Notification
        
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
                    Text(notification.user ?? "nil")
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
        let notification: Notification
        
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
                    Text(notification.user ?? "nil")
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
        @Binding var notifications: [Notification]
        let notification: Notification
        
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
                    Text(notification.user ?? "nil")
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
                            handleAccept()
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
                            handleDelete()
                        }
                }
                .frame(width: 50, height: 50)
            }
        }
        
        func handleAccept() {
            let newNotification = Notification(type: "accept", timestamp: Date().description, uid: notification.receivingUID, receivingUID: notification.uid, user: notification.currentUser);
            createNotification(notification: newNotification);
            handleDelete();
            // TODO: add follower to account
        }
        
        func handleDelete() {
            deleteNotification(notification: notification.notificationID!);
            notifications.removeAll { $0.notificationID == notification.notificationID };
        }
    }
    
    /// Creates the newComment notification used in NotificationRows to display a new comment notification.
    ///
    /// - Parameters:
    ///     - notification: The notification data needing user, postID, and message
    /// - Returns: A view that displays a new comment Notification
    struct newComment: View {
        let notification: Notification
        
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
                    Text(notification.user ?? "nil")
                        .foregroundColor(Color.myMuzeAccent) +
                    Text(" commented: ")
                        .foregroundColor(Color.myMuzeWhite)
                    Text(notification.message ?? "nil")
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
        let notification: Notification
        
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
                    Text(notification.user ?? "nil")
                        .foregroundColor(Color.myMuzeAccent) +
                    Text(" started following you")
                        .foregroundColor(Color.myMuzeWhite)
                }
                Spacer()
            }
        }
    }
    
    /// Creates the newFollower notification used in NotificationRows to display a new follower notification.
    ///
    /// - Parameters:
    ///     - notification: The notification data needing user
    /// - Returns: A view that displays a new follower Notification
    struct newAccept: View {
        let notification: Notification
        
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
                    Text(notification.user ?? "nil")
                        .foregroundColor(Color.myMuzeAccent) +
                    Text(" accepted your follow")
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
    
    
}

#Preview {
    NotificationsView(notifications: [Notification]())
}
