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
    var message: String?
    var user: String?
    var postID: String?
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["type"] = type
        dictionary["timestamp"] = timestamp
        dictionary["uid"] = uid
        
        if let message = message {
            dictionary["message"] = message
        }
        if let user = user {
            dictionary["user"] = user
        }
        if let postID = postID {
            dictionary["postID"] = postID
        }

        return dictionary
    }
}
