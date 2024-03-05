//
//  SignUpView.swift
//  MyMuze
//
//  Created by Pete Potipitak on 2/19/24.
//

import SwiftUI
import PhotosUI
import Combine
import FirebaseAuth

struct SignUpView: View {
    // Sign Up View used for users to sign up for new accounts
    @EnvironmentObject var authManager: AuthManager
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var inputError: Bool = false
    @State private var phone1: String = ""
    @State private var phone2: String = ""
    @State private var phone3: String = ""
    
    private var phoneLimit3 = 4
    
    @FocusState private var focusedField: Field?
    enum Field: Int, Hashable {
       case phone1
       case phone2
       case phone3
    }
    
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
                    TextField("Email", text: $email)
                        .foregroundColor(Color.black)
                        .frame(width: 275)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if (authManager.phoneNumber == nil) {
                        HStack {
                            TextField("(XXX)", text: $phone1)
                                .focused($focusedField, equals: .phone1)
                                .foregroundColor(Color.black)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .onChange(of: phone1) { _ in
                                    if phone1.count == 3 {
                                        self.focusNextField($focusedField)
                                    }
                                }
                            Text("-")
                                .foregroundColor(.white)
                            TextField("XXX", text: $phone2)
                                .focused($focusedField, equals: .phone2)
                                .foregroundColor(Color.black)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .onChange(of: phone2) { _ in
                                    if phone2.count == 3 {
                                        self.focusNextField($focusedField)
                                    }
                                }
                            Text("-")
                                .foregroundColor(.white)
                            TextField("XXXX", text: $phone3)
                                .focused($focusedField, equals: .phone3)
                                .foregroundColor(Color.black)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .onReceive(Just(phone3)) { _ in limitText(phoneLimit3) }
                        }
                        .frame(width: 275)
                    }
                    Rectangle()
                        .foregroundColor(Color.myMuzeAccent)
                        .frame(width:100, height:60)
                        .overlay(
                            Button("Sign up") {
                                handleSignUp()
                            }
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                            .font(.system(size: 20))
                        )
                    Button("Logout") {
                        do {
                            try Auth.auth().signOut()
                            // Set isLoggedIn to false
                            UserDefaults.standard.set(false, forKey: "isLoggedIn")
                        } catch {
                            print("Error signing out: \(error.localizedDescription)")
                        }
                    }
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
    }
    
    func handleSignUp() {
        var phone: String
        if (authManager.phoneNumber == nil) {
            phone = "+1"+phone1+phone2+phone3
        } else {
            phone = authManager.phoneNumber!
        }
        let user = Auth.auth().currentUser
        let userData = UserData(profilePicture: "", username: username, email: email, name: name, userID: user!.uid, phone: phone, followers: [], following: [], privateAcc: false)
        addUserDataToFirestore(userData: userData)
        authManager.signUp()
    }
    
    func limitText(_ upper: Int) {
        if phone3.count > upper {
            phone3 = String(phone3.prefix(upper))
        }
    }
    
    var VerifySignUp: Bool {
        var nameError = false
        var  usernameError = false
        
        nameError = name.isEmpty || name.count < 3
        usernameError = username.isEmpty || username.count < 3
        
        return nameError || usernameError
    }
    
}

extension View {
    /// Creates an easy way to focus the next TextField when the numbers are too large
    
    func focusNextField<F: RawRepresentable>(_ field: FocusState<F?>.Binding) where F.RawValue == Int {
        guard let currentValue = field.wrappedValue else { return }
        let nextValue = currentValue.rawValue + 1
        if let newValue = F.init(rawValue: nextValue) {
            field.wrappedValue = newValue
        }
    }
    func focusPreviousField<F: RawRepresentable>(_ field: FocusState<F?>.Binding) where F.RawValue == Int {
        guard let currentValue = field.wrappedValue else { return }
        let nextValue = currentValue.rawValue - 1
        if let newValue = F.init(rawValue: nextValue) {
            field.wrappedValue = newValue
        }
    }
}

#Preview {
    SignUpView()
}
