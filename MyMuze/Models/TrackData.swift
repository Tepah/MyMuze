//
//  TrackData.swift
//  MyMuze
//
//  Created by Diamond Ly on 4/17/24.
//

import Foundation

struct TrackData: Codable, Identifiable {
    var id = UUID()
    var spotifyID: String
    var name: String
    var artist: String
    var cover: String
    var url: String
    
    func printTrackData() {
        print("Spotify ID: \(spotifyID), Name: \(name), Artist: \(artist), ImageURL: \(cover)")
    }
}