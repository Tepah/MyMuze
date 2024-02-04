//
//  MyMuzeApp.swift
//  MyMuze
//
//  Created by Pete Potipitak on 1/23/24.
//

import SwiftUI

@main
struct MyMuzeApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
                .background(Color(UIColor(red: 0.117, green: 0.117, blue: 0.117, alpha: 1.0)))
        }
    }
}
