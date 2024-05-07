//
//  ProfileUI.swift
//  MyMuze
//
//  Created by Diamond Ly on 2/22/24.
//

import SwiftUI
import FirebaseAuth
import URLImage


struct ProfileUI: View {
    @State private var uid: String = ""
    @State private var currentUser: UserData? = nil
    @State var loading = true
    @State var playlist: [TrackData] = []
//    @State private var tempPlaylist: PlaylistData
    
    var body: some View {
        NavigationView {
            BackgroundView()
                .overlay(
                    VStack (spacing: 15) {
                        if loading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(2)
                        } else {
                            HStack {
                                Text("Profile")
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .bold()
                                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                                    .padding(.leading, 10.0)
                                Spacer()
                                NavigationLink(destination: DebugToolsView(profilePicURL: currentUser!.profilePicture)) {
                                    Image(systemName: "gearshape.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(Color.white)
                                        .padding(10)
                                }
                            }
                            Divider()
                                .overlay(.white)
                                .frame(height: 2)
                                .background(Color.white)
                            if self.currentUser!.profilePicture == "" {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .background(Color.gray)
                                    .clipShape(Circle())
                            } else {
                                URLImage(URL(string: self.currentUser!.profilePicture)!) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                            }
                            Text(currentUser?.name ?? "DisplayName")
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .bold()
                                .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                            Text("@" + (currentUser?.username ?? "username"))
                                .foregroundColor(Color.gray)
                                .padding(.top, -10.0)
                                .frame(maxWidth: .infinity)
                            //                        .bold()
                                .font(.title3)
                            Divider()
                                .overlay(.gray)
                                .frame(height: 0.5)
                                .background(Color.white)
                            HStack {
                                Text("Following: " + String(currentUser?.following.count ?? -1))
                                    .foregroundColor(Color.myMuzeAccent)
                                    .frame(maxWidth: .infinity)
                                    .bold()
                                    .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
                                Text("Followers: " + String(currentUser?.followers.count ?? -1))
                                    .foregroundColor(Color.myMuzeAccent)
                                    .frame(maxWidth: .infinity)
                                    .bold()
                                    .font(.title3)
                            }
                            Divider()
                                .overlay(.gray)
                                .frame(height: 0.5)
                                .background(Color.white)
                            HStack {
                                Text("Profile Playlist:")
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 10.0)
                                    .bold()
                                    .underline()
                                    .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                                Spacer()
                                if !playlist.isEmpty {
                                    NavigationLink(destination: BuildPlaylistView(uid: uid, playlist: playlist)) {
                                        Image(systemName: "list.triangle")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(Color.white)
                                            .padding(10)
                                    }
                                }
                            }
                            // Playlist will show here
                            if playlist.isEmpty {
                                NavigationLink(destination: BuildPlaylistView(uid: uid, playlist: playlist)) {
                                    Rectangle()
                                        .frame(width: 200, height: 50)
                                        .foregroundColor(Color.myMuzeAccent)
                                        .cornerRadius(10)
                                        .padding(10)
                                        .overlay(Text("Create a playlist")
                                            .bold()
                                            .foregroundColor(Color.myMuzeWhite)
                                        )
                                }
                            }
                            else {
                                List(playlist) {
                                    track in SpotifyTrackItem(trackInfo: track)
                                        .listRowBackground(Color.clear)
                                        .listRowSeparatorTint(.myMuzeWhite)
                                }
                                .padding(.vertical, 10)
                                .listStyle(PlainListStyle())
                                .refreshable {
                                    loading = true
                                    loadProfileData()
                                }
                            }
                            Spacer()
                        }
                    }
                )
                .onAppear() {
                    loading = true;
                    loadProfileData();
                }
        }
        }
    
    func loadProfileData() {
        Task {
            do {
                let user = Auth.auth().currentUser
                if let user = user {
                    uid = user.uid
                    currentUser = try await getUser(uid: uid)
                    if await hasPlaylist(uid: uid) {
                        let tempPlaylist = try await getPlaylist(uid: uid)
                        getSpotifyTracks(tempPlaylist: tempPlaylist)
                    } 
                }
                loading = false;
            } catch {
                    print("Error loading data:", error.localizedDescription)
            }
            
        }
    }
    
    func getSpotifyTracks(tempPlaylist: PlaylistData) {
        if !playlist.isEmpty {
            playlist = []
        }
        let spotifyClient = SpotifyAPIClient()
        spotifyClient.getAccessToken { accessToken in
            if let token = accessToken {
//                print("Access Token: \(token)")
                for track in tempPlaylist.tracks {
                    spotifyClient.getTrack(trackID: track, accessToken: token) { trackInfo in
                        if let trackInfo = trackInfo {
                            playlist.append(trackInfo)
                        } else {
                            print("Failed to fetch track info for track \(track)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileUI()
}
