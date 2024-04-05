//
//  NotificationData.swift
//  MyMuze
//
//  Created by Pete Potipitak on 4/5/24.
//

import Foundation

struct Notification: Codable {
    // Notification data
    var message: String
    var type: String
    var timestamp: String
    var uid: String
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "message" : message,
            "type" : type,
            "timestamp" : timestamp,
            "uid" : uid
        ]

        return dictionary
    }
}
