//
//  PostUI.swift
//  MyMuze
//
//  Created by Diamond Ly on 2/29/24.
//

import SwiftUI

struct PostUI: View {
    @State private var searchQuery = ""
    @State private var trackList: [TrackData] = []
   
    var body: some View {
        BackgroundView()
            .overlay(
                VStack (spacing: 20){
                    Text("Create a Post")
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                        .padding([.leading], 10.0)
                    Divider()
                        .overlay(.white)
                        .frame(height: 2)
                        .background(Color.white)
                    Text("Time to share your song of the day!")
                        .font(.title3)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                        .bold()
                    TextField("Search for a song or artist", text: $searchQuery)
                        .padding(7.0)
                        .background(Color.white)
                        .cornerRadius(10)
                        .frame(height: 20)
                        .foregroundColor(Color.black)
                        .autocapitalization(.none)
                        .onSubmit {
                            print("Query: \(searchQuery)")
                            searchSpotify(searchInput: searchQuery)
                        }
                    List(trackList) { track in SpotifyTrackItem(trackInfo: track)
                            .listRowBackground(Color.clear)
                            .listRowSeparatorTint(.myMuzeWhite)
                    }
                    .padding(.vertical, 10)
                    .listStyle(PlainListStyle())
                }
            )
    }
    
    func searchSpotify(searchInput: String) {
        let spotifyClient = SpotifyAPIClient()
        spotifyClient.getAccessToken { accessToken in
            if let token = accessToken {
                print("Access Token: \(token)")
                // Use the access token to make further requests to Spotify API
                spotifyClient.searchTracks(query: searchInput, accessToken: token) { trackInfo in
                    if let trackInfo = trackInfo {
                        print("Found \(trackInfo.count) Tracks: ")
                        if !trackList.isEmpty {
                            trackList = []
                        }
                        for track in trackInfo {
                            trackList.append(track)
                            track.printTrackData()
                        }
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
