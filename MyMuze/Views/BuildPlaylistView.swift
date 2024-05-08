//
//  BuildPlaylistView.swift
//  MyMuze
//
//  Created by Diamond Ly on 5/6/24.
//

import SwiftUI
import URLImage
import FirebaseAuth

struct BuildPlaylistView: View {
    @State private var searchQuery = ""
    @State private var trackList: [TrackData] = []
    
    @State var playlist: [TrackData]
    let uid: String
    
    init(uid: String, playlist: [TrackData]) {
        self.playlist = playlist
        self.uid = uid
        
    }
    
    var body: some View {
        BackgroundView()
            .overlay(
                VStack {
                    HStack {
                        TextField("Search for a song or artist", text: $searchQuery)
                            .padding(5.0)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: 325, height: 50)
                            .foregroundColor(Color.black)
                            .autocapitalization(.none)
                            .onSubmit {
                                print("Query: \(searchQuery)")
                                searchSpotify(searchInput: searchQuery)
                            }
                        Button (action: {
                            Task {
                                let newTracklist = convertToPlaylistData(playlist: playlist)
                                if await hasPlaylist(uid: uid) {
                                    await updatePlaylist(uid: uid, playlist: newTracklist)
                                } else {
                                    createPlaylist(playlist: PlaylistData(uid: uid, tracks: newTracklist))
                                }
                            }
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .foregroundColor(Color.myMuzeAccent)
                                .frame(width: 30, height: 30)
                                .padding(.horizontal, 5)
                        }
//                        .padding(.horizontal, 5)
                    }
                    List(trackList) { track in PlaylistSelection(track: track, playlist: $playlist)
                            .listRowBackground(Color.clear)
                            .listRowSeparatorTint(.myMuzeWhite)
                    }
                    .padding(.vertical, 10)
                    .listStyle(PlainListStyle())
                }
            )
            .navigationBarTitle("Build a Playlist")
            .navigationBarTitleTextColor(.white)
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
                            var updatedTrack: TrackData = track
                            for p in playlist {
                                if track.spotifyID == p.spotifyID {
                                    updatedTrack.setAdded(value: true)
                                }
                            }
                            trackList.append(updatedTrack)
//                            updatedTrack.printTrackData()
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
    
    func convertToPlaylistData(playlist: [TrackData]) -> [String] {
        var newPlaylist: PlaylistData = PlaylistData(uid: uid, tracks: [])
        for track in playlist {
            newPlaylist.tracks.append(track.spotifyID)
        }
        return newPlaylist.tracks
    }
}

struct PlaylistSelection: View {
    @State var trackInfo: TrackData
    @Binding var tempPlaylist: [TrackData]
    
    init(track: TrackData, playlist: Binding<[TrackData]>) {
        self._tempPlaylist = playlist
        self.trackInfo = track
    }
    
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: 375, height: 75)
            .overlay(
                HStack {
                    if self.trackInfo.cover == "" {
                        Image(systemName: "music.note")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(5)
                            .background(Color.myMuzeBlack)
                    } else {
                        URLImage(URL(string: self.trackInfo.cover)!) { image in
                            image
                                .resizable()
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(5)
                    }
                    VStack(alignment: .leading) {
                        Text(self.trackInfo.name)
                            .foregroundColor(Color.myMuzeAccent)
                            .bold()
                        Text(self.trackInfo.artist)
                            .foregroundColor(Color.myMuzeWhite)
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.horizontal, 5)
                    .offset(y: 20)
                    Spacer()
                    
                    if !self.trackInfo.added {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.horizontal, 10)
                            .foregroundColor(Color.myMuzeAccent)
                            .onTapGesture {
                                if tempPlaylist.count < 10 {
                                    tempPlaylist.append(self.trackInfo)
                                    print("\(trackInfo.name) by \(trackInfo.artist) added to playlist!")
                                    self.trackInfo.added.toggle()
                                } else {
                                    print("Max songs for playlist reached!")
                                }
                            }
                    } else {
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.horizontal, 10)
                            .foregroundColor(Color.myMuzeAccent)
                            .onTapGesture {
                                tempPlaylist.removeAll(where: {$0.name == self.trackInfo.name && $0.artist == self.trackInfo.artist})
                                print("\(trackInfo.name) by \(trackInfo.artist) removed from playlist!")
                                self.trackInfo.added.toggle()
                            }
                    }
                }
            )
    }
}

