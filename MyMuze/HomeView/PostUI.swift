//
//  PostUI.swift
//  MyMuze
//
//  Created by Diamond Ly on 2/29/24.
//

import SwiftUI
import URLImage
import FirebaseAuth

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
                    NavigationView {
                        ZStack{
                            BackgroundView()
                            VStack {
                                Text("Time to share your song of the day!")
                                    .font(.title3)
                                    .foregroundColor(Color.gray)
                                    .multilineTextAlignment(.center)
                                    .bold()
                                TextField("Search for a song or artist", text: $searchQuery)
                                    .padding(7.0)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .frame(height: 50)
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
                        }
                    }
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

struct PublishView: View {
    @State private var currentUser: UserData? = nil
    @State private var postString: String = "Post"
    
    let selectedTrack: TrackData
    
    init(selectedTrack: TrackData) {
        self.selectedTrack = selectedTrack
    }
    
    var body: some View {
        BackgroundView()
        VStack {
            Rectangle()
                .fill(Color.clear)
//                .border(Color.myMuzeWhite, width: 1)
                .frame(width: 375, height: 450)
                .overlay(
                    VStack {
                        URLImage(URL(string: self.selectedTrack.cover)!) { image in
                            image
                                .resizable()
                                .frame(width: 300, height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.horizontal, 10)
                        }
                        VStack{
                            Text("\(selectedTrack.name)")
                                .bold()
                                .foregroundColor(Color.white)
                                .frame(maxWidth: . infinity, alignment: .center)
                            Text("\(selectedTrack.artist)")
                                .foregroundColor(Color.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(.top, 25.0)
//                        Spacer()
                    }
                )
                .onAppear{
                    loadUser()
                }
            
            Button(action: {
                let now = Date()
                let dtFormatter = DateFormatter()
                dtFormatter.dateStyle = .long
                dtFormatter.timeStyle = .long
                let formattedTimestamp = dtFormatter.string(from: now)
                
                let newPost = PostData(uid: currentUser?.userID ?? "uid", username: currentUser?.username ?? "username", timestamp: formattedTimestamp, track: "\(selectedTrack.name) - \(selectedTrack.artist)")
                postString = "Posted!"
                createPost(post: newPost)
            }, label: {
                Rectangle()
                    .foregroundColor(Color.myMuzeAccent)
                    .frame(width: 80, height: 30)
                    .cornerRadius(10)
                    .overlay(
                        Text("\(postString)")
                            .foregroundColor(Color.myMuzeWhite)
                            .bold()
                    )
            })
            
        }
    }
    
    func loadUser() {
        Task {
            do {
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    currentUser = try await getUser(uid: uid)
                }
            } catch {
                    print("Error loading data:", error.localizedDescription)
            }
            
        }
    }
}

#Preview {
    PostUI()
}
