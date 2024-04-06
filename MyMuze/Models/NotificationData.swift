//
//  NotificationData.swift
//  MyMuze
//
//  Created by Pete Potipitak on 4/5/24.
//

import Foundation

struct Notification: Codable {
    // Notification data
    var type: String
    var timestamp: String
    var uid: String
    var message: String?
    var follower: String?
    var postID: String?
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "type" : type,
            "timestamp" : timestamp,
            "uid" : uid,
            "message" : message ?? "",
            "follower" : follower ?? "",
            "postID" : postID ?? ""
        ]

        return dictionary
    }
}
