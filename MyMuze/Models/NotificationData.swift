//
//  NotificationData.swift
//  MyMuze
//
//  Created by Pete Potipitak on 4/5/24.
//

import Foundation

struct Notification: Codable {
    // Notification data
    var notificationID: String?
    var type: String
    var timestamp: String
    var uid: String
    var receivingUID: String
    var message: String?
    var user: String?
    var currentUser: String?
    var postID: String?
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["type"] = type
        dictionary["timestamp"] = timestamp
        dictionary["uid"] = uid
        dictionary["receivingUID"] = receivingUID
        
        if let message = message {
            dictionary["message"] = message
        }
        if let user = user {
            dictionary["user"] = user
        }
        if let postID = postID {
            dictionary["postID"] = postID
        }
        if let currentUser = currentUser {
            dictionary["currentUser"] = currentUser
        }

        return dictionary
    }
}
