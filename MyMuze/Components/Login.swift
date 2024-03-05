//
//  Login.swift
//  MyMuze
//
//  Created by Pete Potipitak on 3/3/24.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import UIKit
import FirebaseCore

func verifyPhoneSignIn(_ phoneNumber: String) {
    PhoneAuthProvider.provider()
        .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            print("Verification code sent to \(phoneNumber)")
        }
}

func verifyCode(_ code: String) -> Bool {
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    let credential = PhoneAuthProvider.provider().credential(
        withVerificationID: verificationID!,
        verificationCode: code)
    Auth.auth().signIn(with: credential) { authResult, error in
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print("User is signed in with UID: \(authResult!.user.uid)")
    }
    return Auth.auth().currentUser != nil
}

