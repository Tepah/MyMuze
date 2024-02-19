//
//  SignUpView.swift
//  MyMuze
//
//  Created by Pete Potipitak on 2/19/24.
//

import SwiftUI
import PhotosUI

struct SignUpView: View {
    // Sign Up View used for users to sign up for new accounts
    @Environment(\.presentationMode) var presentationMode
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        BackgroundView()
            .overlay(
                VStack(spacing: 40) {
                    Spacer()
                    PhotosPicker(selection: $avatarItem, matching: .images) {
                        (avatarImage ?? Image(systemName: "person.circle.fill"))
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 230, height: 230)
                            .clipShape(Circle())
                            .foregroundColor(Color.gray)
                            .overlay(alignment: .bottomTrailing) {
                                Image(systemName: "pencil.circle.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.system(size: 50))
                                    .foregroundColor(Color.myMuzeAccent)
                            }
                    }
                    TextField("Name", text: $name)
                        .foregroundColor(Color.black)
                        .frame(width: 275)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .shadow(radius: 5)
                    TextField("Username", text: $username)
                        .foregroundColor(Color.black)
                        .frame(width: 275)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Password", text: $password)
                        .foregroundColor(Color.black)
                        .frame(width: 275)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Rectangle()
                        .foregroundColor(Color.myMuzeAccent)
                        .frame(width:100, height:60)
                        .overlay(
                            Button("Sign up") {
                                
                            }
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                            .font(.system(size: 20))
                        )
                    Spacer()
                }
                .onChange(of: avatarItem) {
                    Task {
                        if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                            avatarImage = loaded
                        } else {
                            print("Failed")
                        }
                    }
                }
            )
            .navigationBarTitle("Sign Up", displayMode: .inline)
            .navigationBarTitleFont(size: 20)
            .navigationBarTitleTextColor(.white)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "backward.end.fill")
                            .foregroundColor(.white)
                    }
                }
            )
    }
}

#Preview {
    SignUpView()
}
