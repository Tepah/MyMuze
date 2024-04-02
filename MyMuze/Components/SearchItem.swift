//
//  SearchItem.swift
//  MyMuze
//
//  Created by Pete Potipitak on 3/12/24.
//

import SwiftUI
import URLImage

/// Creates the search item used in ProfileSearchView to display search results
///
/// - Parameters:
///     - uid: The user ID number of the user
/// - Returns: A view that displays the user ID
struct SearchItem: View {
    let uid: String
    
    init(uid: String) {
        self.uid = uid
    }
    
    // Temporary profile info
    private let profileInfo = UserData(profilePicture: "", username: "username", email: "email", name: "name", userID: "userID", phone: "phone", followers: [], following: [], privateAcc: false)
    
    var body: some View {
        NavigationLink(destination: ProfileUI()) {
            HStack {
                if profileInfo.profilePicture == "" {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(10)
                        .background(Color.myMuzeBlack)
                        .clipShape(Circle())
                } else {
                    URLImage(URL(string: profileInfo.profilePicture)!) { image in
                        image
                            .resizable()
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                            .padding(5)
                    }
                }
                VStack(alignment: .leading) {
                    Text("@"+profileInfo.username)
                        .foregroundColor(Color.myMuzeAccent)
                        .bold()
                    Text(profileInfo.name)
                        .foregroundColor(Color.myMuzeWhite)
                        .font(.subheadline)
                    Spacer()
                }
                .padding(.horizontal, 5)
                .offset(y: 20)
                Spacer()
                Button(action: {
                    print("Follow")
                }) {
                    Text("Follow")
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color.myMuzeAccent))
                        .foregroundColor(Color.white)
                }
            }
        }
        
    }
}
