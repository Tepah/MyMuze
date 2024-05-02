//
//  SpotifyTrackItem.swift
//  MyMuze
//
//  Created by Diamond Ly on 4/17/24.
//

import SwiftUI
import URLImage

struct SpotifyTrackItem: View {
    let trackInfo: TrackData
    
    init(trackInfo: TrackData) {
        self.trackInfo = trackInfo
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
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(5)
                        }
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
                    Image("SpotifyIcon")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            print("Redirected to Spotify URL: \(self.trackInfo.url)")
                            let spotifyLink = URL(string: self.trackInfo.url)
                            UIApplication.shared.open(spotifyLink!, options: [:], completionHandler: nil)
                        }
                }
            )
            .background(NavigationLink(destination: PublishView(selectedTrack: trackInfo)) {
                EmptyView()
            })
        
    }
}
