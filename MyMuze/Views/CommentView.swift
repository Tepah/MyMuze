//
//  CommentView.swift
//  MyMuze
//
//  Created by Pete Potipitak on 5/6/24.
//

import SwiftUI
import URLImage
import FirebaseAuth

struct CommentView: View {
    @State private var isLiked: Bool = false
    @State private var loading = false
    @Binding var isPresented: Bool
    @State var post: PostData
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                VStack {
                    HStack {
                        Button(action: {
                            isPresented = false
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.myMuzeAccent)
                        }
                        .padding(20)
                        Spacer()
                    }
                    ScrollView {
                        if loading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.myMuzeAccent))
                                .scaleEffect(1.5)
                        } else {
                            VStack {
                                Text("@" + self.post.username)
                                    .frame(maxWidth: 100, alignment: .topLeading)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.myMuzeAccent)
                                    .padding(10)
                                URLImage(URL(string: self.post.cover)!) { image in
                                    image
                                        .resizable()
                                }
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .cornerRadius(15)
                                .padding(25)
                                Text(self.post.track)
                                    .multilineTextAlignment(.center)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .padding(.bottom, 5)
                                Text(self.post.artist)
                                    .multilineTextAlignment(.center)
                                    .font(.title2)
                                    .foregroundColor(Color.gray)
                                    .padding(.bottom, 20)
                                RoundedRectangle(cornerRadius: 1)
                                    .fill(Color.gray)
                                    .frame(height: 1)
                                    .padding(.horizontal, 20)
                                HStack {
                                    Spacer()
                                    if self.post.songURL != nil {
                                        Image("SpotifyIcon")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .onTapGesture {
                                                print("Redirected to Spotify URL: \(self.post.songURL)")
                                                let spotifyLink = URL(string: self.post.songURL!)
                                                UIApplication.shared.open(spotifyLink!, options: [:], completionHandler: nil)
                                            }
                                        Spacer()
                                    }
                                    Image(systemName: isLiked ? "heart.fill" : "heart")
                                        .resizable()
                                        .foregroundColor(Color.myMuzeAccent)
                                        .frame(width: 40, height: 40)
                                    Spacer()
                                }
                                .padding(.vertical, 20)
                                ForEach(self.post.comments, id: \.self) { comment in
                                    CommentItem(commentID: comment)
                                }
                                Spacer()
                                CommentTextBox(loading: $loading, post: $post)
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width, height: 7 * geometry.size.height / 8)
                .background(Color.myMuzeBlack)
                .cornerRadius(30)
                .offset(y: self.isPresented ? 0 : geometry.size.height)
                .animation(.easeInOut)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color.myMuzeBlack.opacity(0.3))
    }
}

struct CommentItem: View {
    @State private var comment: CommentData?
    @State private var isLoading: Bool = true
    let commentID: String
    
    var body: some View {
        HStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.myMuzeAccent))
                    .scaleEffect(1.5)
                    .onAppear() {
                        Task {
                            do {
                                comment = try await getCommentByID(commentID: commentID)
                                isLoading = false
                            } catch {
                                print("Error loading comment")
                            }
                        }
                    }
            } else {
                VStack {
                    Text("@" + comment!.username)
                        .foregroundColor(Color.myMuzeAccent)
                        .fontWeight(.bold)
                    Text(comment!.comment)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.leading, 20)
            }
        }
        .listRowBackground(Color.clear)
        .listRowSeparatorTint(.myMuzeWhite)
        .padding(10.0)
    }
}

struct CommentTextBox: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var commentText:String = ""
    @Binding var loading: Bool
    @Binding var post: PostData
    
    var body: some View {
        TextField("Add a comment", text: $commentText)
            .padding(7.0)
            .background(Color.white)
            .cornerRadius(5)
            .frame(width: 365, height: 50)
            .foregroundColor(Color.black)
            .autocapitalization(.none)
            .onSubmit {
                Task {
                    do {
                        loading = true
                        let comment = CommentData(uid: Auth.auth().currentUser!.uid, username: authManager.user, date: Date().formatted(date: .long, time: .omitted), comment: commentText)
                        let commentID = await createComment(comment: comment)
                        try await addCommentToPost(postID: self.post.postID!, comment: commentID)
                        post = try await getPost(postID: post.postID!)
                        createNotification(notification: Notification(type: "comment", timestamp: Date().description, uid: post.uid, receivingUID: Auth.auth().currentUser!.uid, user: authManager.user, postID: post.postID))
                        loading = false
                        commentText = ""
                    } catch {
                        print("Error creating comment")
                    }
                }
            }
    }
}

#Preview {
    HomeUI()
}
