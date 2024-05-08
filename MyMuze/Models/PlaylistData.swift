//
//  PlaylistData.swift
//  MyMuze
//
//  Created by Diamond Ly on 5/6/24.
//

import Foundation

struct PlaylistData: Codable {
    var id = UUID()
    var uid: String
    var tracks: [String]
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "uid": uid,
            "tracks": tracks,
        ]

        return dictionary
    }
}
