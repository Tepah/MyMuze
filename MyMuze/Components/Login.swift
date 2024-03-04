//
//  Login.swift
//  MyMuze
//
//  Created by Pete Potipitak on 3/3/24.
//

import Foundation
import FirebaseAuth
import UIKit

func verifyPhoneSignIn(_ phoneNumber: String) {
    PhoneAuthProvider.provider()
        .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
        }
}

