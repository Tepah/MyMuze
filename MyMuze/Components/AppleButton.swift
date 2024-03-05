//
//  AppleButton.swift
//  MyMuze
//
//  Created by Pete Potipitak on 2/2/24.
//

import Foundation
import AuthenticationServices
import SwiftUI
import UIKit

struct AppleButtonView: UIViewRepresentable {
    typealias UIViewType = ASAuthorizationAppleIDButton
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let authorization = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        return authorization
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}
