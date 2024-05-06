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
    let profileInfo: UserData
    
    init(profileInfo: UserData) {
        self.profileInfo = profileInfo
    }
    
    // Temporary profile info
    
    var body: some View {
        NavigationLink(destination: ExternalProfileView(username: profileInfo.username, uid: profileInfo.userID)) {
            HStack {
                if self.profileInfo.profilePicture == "" {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(10)
                        .background(Color.myMuzeBlack)
                        .clipShape(Circle())
                } else {
                    URLImage(URL(string: self.profileInfo.profilePicture)!) { image in
                        image
                            .resizable()
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                            .padding(5)
                    }
                }
                VStack(alignment: .leading) {
                    Text("@"+self.profileInfo.username)
                        .foregroundColor(Color.myMuzeAccent)
                        .bold()
                    Text(self.profileInfo.name)
                        .foregroundColor(Color.myMuzeWhite)
                        .font(.subheadline)
                    Spacer()
                }
                .padding(.horizontal, 5)
                .offset(y: 20)
                Spacer()
            }
        }
    }
}
