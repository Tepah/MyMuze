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
                    List {
                        ForEach(resultUIDs, id: \.self) { uid in
                            SearchItem(uid: uid)
                                .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                    .onChange(of: searchText) {
                        searchUsersWithPrefix(prefix: $0) { usernames in
                            resultUIDs = usernames
                        }
                    }
            )
    }
}

#Preview {
    ProfileSearchView()
}
