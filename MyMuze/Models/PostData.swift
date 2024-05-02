//
//  PostData.swift
//  MyMuze
//
//  Created by Diamond Ly on 5/1/24.
//

import Foundation

struct PostData: Codable {
    var uid: String
    var username: String
    var timestamp: String
    var track: String
    var likes: Int?
    var comments: [String]?
//    var postID: String?
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["username"] = username
        dictionary["timestamp"] = timestamp
        dictionary["uid"] = uid
        dictionary["track"] = track
        
        if let likes = likes {
            dictionary["likes"] = likes
        }
        if let comments = comments {
            dictionary["comments"] = comments
        }
//        if let postID = postID {
//            dictionary["postID"] = postID
//        }

        return dictionary
    }
}
