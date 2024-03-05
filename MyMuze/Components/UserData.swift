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
    

    func printUserInfo() {
        print("Username: \(username), Email: \(email), Name: \(name), UserID: \(userID), Phone: \(phone), Followers: \(followers), Following: \(following), Private: \(privateAcc)")
    }
}

extension UserData {
    // Convert UserData to dictionary
    func asDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try encoder.encode(self)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
        return dictionary
    }

    // Initialize UserData from Firestore document data
    init?(documentData: [String: Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: documentData, options: [])
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self = try decoder.decode(UserData.self, from: data)
    }
}
