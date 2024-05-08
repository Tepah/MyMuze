//
//  HomeUI.swift
//  MyMuze
//
//  Created by Diamond Ly on 2/13/24.
//

import SwiftUI
import FirebaseAuth
import URLImage

struct HomeUI: View {
    @State private var showCommentsModal: Bool = false
    @State private var loading = true
    @State var notifications = [Notification]()
    @State var postFeed: [PostData] = []
    @State var currentPostData: PostData = PostData(uid: "", username: "", date: "", track: "", artist: "", cover: "", likes: [], comments: [])
    @State var currentDate = Date().formatted(date: .long, time: .omitted)
    
    let uid = Auth.auth().currentUser?.uid ?? "temp"
    
    var body: some View {
        NavigationView {
            BackgroundView()
                .overlay(
                    ZStack {
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
                                List(postFeed) {post in
                                    PostItem(showCommentsModal: $showCommentsModal, currentPostData: $currentPostData, postInfo: post)
                                }
                                .accentColor(Color.myMuzeWhite)
                                .listStyle(PlainListStyle())
                                .refreshable {
                                    loadData()
                                }
                                Spacer()
                            }
                        }
                        
                        if showCommentsModal {
                            CommentView(isPresented: $showCommentsModal, post: currentPostData)
                                .transition(.move(edge: .bottom))
                                .edgesIgnoringSafeArea(.bottom)
                        }
                    }
                )
                .onChange(of: showCommentsModal) { _ in
                    if showCommentsModal == false {
                        loading = true;
                        loadData()
                    }
                }
                .onAppear() {
                    loading = true;
                    loadData();
                }
        }
    }
    func loadData() {
        Task {
            do {
                notifications = try await getNotificationsForUser(uid:uid);
                postFeed = try await collectDailyFeed(date: currentDate)
                loading = false;
            } catch {
                print("Error loading notifications")
            }
        }
    }
}

struct PostItem: View {
    @State private var isLiked = false
    @Binding var showCommentsModal: Bool
    @Binding var currentPostData: PostData
    
    let postInfo: PostData
    
    var body: some View {
        HStack {
            VStack{
                NavigationLink(destination: ExternalProfileView(username: postInfo.username, uid: postInfo.uid)) {
                    Text("@" + postInfo.username)
                        .foregroundColor(Color.myMuzeAccent)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .fontWeight(.bold)
                }
                HStack {
                    URLImage(URL(string: self.postInfo.cover)!) { image in
                        image
                            .resizable()
                    }
                    .frame(width: 40, height: 40, alignment: .leading)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(5)
                    VStack {
                        Text(postInfo.track)
                            .foregroundColor(Color.white)
                            .frame(maxWidth: . infinity, alignment: .topLeading)
                        Text(postInfo.artist)
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .onTapGesture {
                    showCommentsModal = true
                    currentPostData = postInfo
                }
            }
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .resizable()
                .foregroundColor(Color.myMuzeAccent)
                .frame(width: 20, height: 20)
                .padding(.top, 30)
                .onTapGesture {
                    isLiked.toggle()
                    // TODO: Add a function to add likes
                }
        }
        .listRowBackground(Color.clear)
        .listRowSeparatorTint(.myMuzeWhite)
        .padding(.leading, 10.0)
        }
}

#Preview {
    HomeUI()
}
