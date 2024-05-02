//
//  HomeUI.swift
//  MyMuze
//
//  Created by Diamond Ly on 2/13/24.
//

import SwiftUI
import FirebaseAuth

struct HomeUI: View {
    @State var loading = true
    @State var notifications = [Notification]()
    
    let uid = Auth.auth().currentUser?.uid ?? "temp"
    
    var body: some View {
        NavigationView {
            BackgroundView()
                .overlay(
                    VStack {
                        if loading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(2)
                        } else {
                            HStack {
                                Text("Home")
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .bold()
                                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                                    .padding([.leading, .bottom], 10.0)
                                Spacer()
                                NavigationLink(destination: ProfileSearchView()) {
                                    Image(systemName: "magnifyingglass")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color.white)
                                        .padding(10)
                                }
                                if notifications.count > 0 {
                                    NavigationLink(destination: NotificationsView(notifications: notifications)) {
                                        Image(systemName: "bell.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(Color.white)
                                            .padding(10)
                                            .overlay(
                                                Circle()
                                                    .foregroundColor(.red)
                                                    .frame(width: 10, height: 10)
                                                    .offset(x: 10, y: -10)
                                            )
                                    }
                                } else {
                                    NavigationLink(destination: NotificationsView(notifications: notifications)) {
                                        Image(systemName: "bell")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(Color.white)
                                            .padding(10)
                                    }
                                }
                            }
                            Divider()
                                .overlay(.white)
                                .frame(height: 2)
                                .background(Color.white)
                            List {
                                Post(username: "diamondly", song: "THE END", artist: "Alesso, Charlotte Lawrence")
                                Post(username: "potipitak", song: "golden hour - Fujii Kaze Remix", artist: "JVKE, Fujii Kaze")
                                Post(username: "dave123", song: "Use Somebody", artist: "Kings of Leon")
                            }
                            .accentColor(Color.myMuzeWhite)
                            .listStyle(PlainListStyle())
                            Spacer()
                        }
                    }
                )
                .onAppear() {
                    loading = true;
                    loadData();
                }
        }
    }
    
    struct Post: View {
        let username: String
        let song: String
        let artist: String
        
        var body: some View {
            VStack{
                // TODO: Change with actual UID later
                NavigationLink(destination: ExternalProfileView(username: username, uid: "SWvqeB1XP7cYUpxnULF10Nkzi7r1")) {
                    Text("@" + username)
                        .foregroundColor(Color("Accent Color"))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .fontWeight(.bold)
                }
                Text(song)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: . infinity, alignment: .topLeading)
                Text(artist)
                    .foregroundColor(Color.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .listRowBackground(Color.clear)
            .padding(.leading, 10.0)
        }
    }
    
    func loadData() {
        Task {
            do {
                notifications = try await getNotificationsForUser(uid:uid);
                loading = false;
            } catch {
                print("Error loading notifications")
            }
        }
    }
}

#Preview {
    HomeUI()
}
