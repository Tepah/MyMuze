//
//  ProfileSearchView.swift
//  MyMuze
//
//  Created by Pete Potipitak on 3/9/24.
//

import SwiftUI

struct ProfileSearchView: View {
    @State private var searchText = ""
    @State private var resultUIDs: [String] = []
    @State private var users: [UserData] = []
    
    var body: some View {
        BackgroundView()
            .overlay(
                VStack {
                    Text("Search")
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                        .padding(.leading, 10.0)
                    HStack {
                        TextField("Search", text: $searchText)
                            .onChange(of: searchText) { newSearchText in
                                Task {
                                    do {
                                        if newSearchText == "" {
                                            resultUIDs = []
                                            users = []
                                            return
                                        }
                                        else {
                                            let usernames = try await searchUsersWithPrefix(prefix: newSearchText)
                                            resultUIDs = usernames
                                            users = []
                                        }
                                    } catch {
                                        print("Error searching for users: \(error)")
                                    }
                                }
                                print("Search Text: \(searchText)")
                                print(resultUIDs)
                            }
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                            .frame(height: 20)
                            .foregroundColor(Color.black)
                            .autocapitalization(.none)
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.white)
                                .padding(.horizontal, 10)
                        }
                    }
                    .padding(.horizontal, 10)
                    if !resultUIDs.isEmpty {
                        if users.isEmpty {
                            ForEach(resultUIDs.indices, id: \.self) { _ in
                                Rectangle()
                                    .fill(Color.myMuzeBlack)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 10)
                                    .frame(height: 60)
                            }
                            .padding(.vertical, 10)
                            .onAppear {
                                loadUsers()
                            }
                            Spacer()
                        } else {
                            List(users, id: \.self.userID) { user in
                                SearchItem(profileInfo: user)
                                    .listRowBackground(Color.clear)
                            }
                            .padding(.vertical, 10)
                            .listStyle(PlainListStyle())
                        }
                    } else {
                        Spacer()
                    }
                    
                }
                    
            )
    }
    
    func loadUsers() {
        Task {
            for uid in resultUIDs {
                do {
                    let user = try await getUser(uid: uid)
                    users.append(user)
                } catch {
                    print("Error loading user with UID: \(uid)")
                }
            }
        }
    }
}

#Preview {
    ProfileSearchView()
}
