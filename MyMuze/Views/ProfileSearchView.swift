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
                    HStack {
                        Text("Search")
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                            .padding([.leading, .bottom], 10.0)
                        TextField("Search", text: $searchText)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: 200, height: 20)
                            .foregroundColor(Color.black)
                            .padding(10)
                            .autocapitalization(.none)
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.white)
                                .padding(10)
                        }
                    }
                        Divider()
                            .overlay(.white)
                            .frame(height: 2)
                            .background(Color.white)
                    List {
                        ForEach(resultUIDs, id: \.self) { uid in
                            NavigationLink(destination: ProfileUI()) {
                                Text(uid)
                                    .foregroundColor(Color("Accent Color"))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .fontWeight(.bold)
                            }
                        }
                    }
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
