//
//  AppDelegate.swift
//  MyMuze
//
//  Created by Pete Potipitak on 3/5/24.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        // Get the clientID from FirebaseApp options
        guard let clientID = FirebaseApp.app()?.options.clientID else { return true }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        Auth.auth().addStateDidChangeListener { (auth, user) in
                    if let user = user {
                        // User is signed in
                        print("User is signed in with UID: \(user.uid)")
                    } else {
                        // User is signed out
                        print("User is signed out")
                    }
                }
        return true
    }
    
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
    }
}
