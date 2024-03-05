//
//  UserData.swift
//  MyMuze
//
//  Created by Pete Potipitak on 3/4/24.
//

import Foundation

struct UserData: Codable {
    // User data
    var profilePicture: String
    var username: String
    var email: String
    var name: String
    var userID: String
    var phone: String
    var followers: [String]
    var following: [String]
    var privateAcc: Bool
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "profilePicture": profilePicture,
            "username": username,
            "email": email,
            "name": name,
            "userId": userID,
            "followers": followers,
            "following": following,
            "privateAcc": privateAcc
        ]

        return dictionary
    }

    func printUserInfo() {
        print("Username: \(username), Email: \(email), Name: \(name), UserID: \(userID), Phone: \(phone), Followers: \(followers), Following: \(following), Private: \(privateAcc)")
    }
}
