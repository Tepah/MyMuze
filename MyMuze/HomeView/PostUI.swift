//
//  PostUI.swift
//  MyMuze
//
//  Created by Diamond Ly on 2/29/24.
//

import SwiftUI

struct PostUI: View {
    var body: some View {
        BackgroundView()
            .overlay(
                VStack {
                    Text("Create a Post")
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                        .padding([.leading, .bottom], 10.0)
                    Divider()
                        .overlay(.white)
                        .frame(height: 2)
                        .background(Color.white)
                    Spacer()
                }
            )
    }
    
    func searchSpotify() {
        let spotifyClient = SpotifyAPIClient()
        spotifyClient.getAccessToken { accessToken in
            if let token = accessToken {
                print("Access Token: \(token)")
                // Use the access token to make further requests to Spotify API
                spotifyClient.searchTracks(query: "Shawn Mendes", accessToken: token) { tracks in
                    if let tracks = tracks {
                        print("Found Tracks: \(tracks)")
                    } else {
                        print("Failed to get tracks")
                    }
                }
            } else {
                print("Failed to get access token")
            }
        }
    }
}

#Preview {
    PostUI()
}
