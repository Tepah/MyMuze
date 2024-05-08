//
//  PostData.swift
//  MyMuze
//
//  Created by Diamond Ly on 5/1/24.
//

import Foundation

struct PostData: Codable, Identifiable {
    var id = UUID()
    var uid: String
    var username: String
    var date: String
    var track: String
    var artist: String
    var cover: String
    var songURL: String?
    var likes: [String]
    var comments: [String]
    var postID: String?
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["username"] = username
        dictionary["date"] = date
        dictionary["uid"] = uid
        dictionary["track"] = track
        dictionary["artist"] = artist
        dictionary["cover"] = cover
        dictionary["likes"] = likes
        dictionary["comments"] = comments
        if let songURL = songURL {
            dictionary["songURL"] = songURL
        }

        return dictionary
    }
}
