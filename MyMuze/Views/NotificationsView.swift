//
//  NotificationsView.swift
//  MyMuze
//
//  Created by Pete Potipitak on 4/5/24.
//

import SwiftUI
import FirebaseAuth

struct NotificationsView: View {
    let user = Auth.auth().currentUser
    
    var body: some View {
        BackgroundView()
            .overlay(
                VStack {
                    List(0..<3) {_ in 
                        NotificationRow(notification: Notification(message: "Notification", type: "Type", timestamp: "Timestamp", uid: "UID"))
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
                VStack(alignment: .leading) {
                    Text(notification.message)
                        .foregroundColor(Color.myMuzeWhite)
                        .bold()
                    Text(notification.uid)
                        .foregroundColor(Color.myMuzeAccent)
                        .foregroundColor(Color.gray)
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
