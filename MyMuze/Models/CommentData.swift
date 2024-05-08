//
//  CommentData.swift
//  MyMuze
//
//  Created by Pete Potipitak on 5/8/24.
//

import Foundation

struct CommentData: Codable, Identifiable {
    var id = UUID()
    var uid: String
    var username: String
    var date: String
    var comment: String
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["uid"] = uid
        dictionary["username"] = username
        dictionary["date"] = date
        dictionary["comment"] = comment

        return dictionary
    }
}
