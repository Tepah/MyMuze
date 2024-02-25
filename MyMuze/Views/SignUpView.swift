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
    @State private var phone: String = ""
    @State private var inputError: Bool = false
    
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
                    TextField("Phone Number", text: $phone)
                        .foregroundColor(Color.black)
                        .frame(width: 275)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Rectangle()
                        .foregroundColor(Color.myMuzeAccent)
                        .frame(width:100, height:60)
                        .overlay(
                            Button("Sign up") {
                                inputError = VerifySignUp
                                if !inputError {
                                    // Add user to database
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                            .font(.system(size: 20))
                        )
                    Spacer()
                }
                .alert(isPresented: $inputError) {
                            Alert(
                                title: Text("Invalid Input"),
                                message: Text("Please make sure all fields are filled out correctly."),
                                dismissButton: .default(Text("OK"))
                            )
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
    
    var VerifySignUp: Bool {
        var nameError = false
        var  usernameError = false
        var phoneError = false
        
        nameError = name.isEmpty || name.count < 3
        usernameError = username.isEmpty || username.count < 3
        phoneError = phone.isEmpty || phone.count != 10
        
        return nameError || usernameError || phoneError
    }
}

#Preview {
    SignUpView()
}
