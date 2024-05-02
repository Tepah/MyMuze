//
//  LoginView.swift
//  MyMuze
//
//  Created by Pete Potipitak on 1/30/24.
//

import SwiftUI
import GoogleSignInSwift
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

struct LoginView: View {
    // Login Page View
    var body: some View {
        NavigationView {
            LoginBackgroundView()
                .overlay (
                    VStack {
                        Spacer()
                        Text("MyMuze")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(100)
                        Spacer()
                        Button (action: {
                            
                        }) {
                            Image("AppleButton")
                                .aspectRatio(contentMode: .fit)
                        }
                        .padding(5)
                        Button (action: {
                            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                                // Start the sign in flow for google
                                GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
                                    guard error == nil else {
                                        print("Error with Google Sign in: \(error?.localizedDescription ?? "Unknown error")")
                                        return
                                    }

                                    guard let user = result?.user,
                                        let idToken = user.idToken?.tokenString
                                    else {
                                        print("Error with Google Sign in: User or ID Token is nil")
                                        return
                                    }

                                    let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                                   accessToken: user.accessToken.tokenString)

                                    Auth.auth().signIn(with: credential) { authResult, error in
                                        if let error = error {
                                            // Handle Firebase authentication error
                                            print("Firebase google authentication error: \(error.localizedDescription)")
                                            return
                                        }
                                        // User successfully authenticated with Firebase
                                        print("User authenticated with Firebase using Google")
                                    }
                                }
                            }
                        }) {
                            Image("GoogleButton")
                                .aspectRatio(contentMode: .fit)
                        }
                        .padding(5)
                        Text("or")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                        Button (action: {
                            
                        }) {
                            Rectangle()
                                .foregroundColor(Color.myMuzeAccent)
                                .frame(width:200, height:60)
                                .overlay(
                                    NavigationLink(destination: PhoneSignInView(), label: {
                                        Text("Sign in with Phone")
                                            .foregroundColor(.black)
                                            .fontWeight(.medium)
                                            .font(.system(size:20))
                                    })
                                )
                        }
                        HStack {
                            Text("No account?")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                            NavigationLink(destination: PhoneSignInView(), label: {
                                Text("Sign Up")
                                .foregroundColor(Color.myMuzeAccent)
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                            })
                        }
                        .padding(30)
                        Spacer()
                    }
                )
        }
    }
}

#Preview {
    LoginView()
}
