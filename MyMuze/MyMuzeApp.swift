//
//  MyMuzeApp.swift
//  MyMuze
//
//  Created by Pete Potipitak on 1/23/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct MyMuzeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authManager = AuthManager()
    @State private var userExists: Bool?
    
    var body: some Scene {
        WindowGroup {
            if authManager.isUserAuthenticated {
                if let userExists = userExists {
                    if userExists {
                        ContentView()
                            .environmentObject(authManager)
                    } else {
                        SignUpView()
                            .environmentObject(authManager)
                    }
                } else {
                    Text("Loading...")
                        .onAppear {
                            loadData()
                        }
                }
            } else {
                LoginView()
                    .environmentObject(authManager)
            }
        }
    }
    
    func loadData() {
        Task {
            do {
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    let userExists = await doesUserExistWithUID(uid: uid)
                    self.userExists = userExists
                }
            } catch {
                print("Error loading data:", error.localizedDescription)
            }
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
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
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
    }
}

class AuthManager: ObservableObject {
    // Published property to trigger UI updates
    @Published var isUserAuthenticated = false

    init() {
        // Add authentication state change observer
        Auth.auth().addStateDidChangeListener { (_, user) in
            self.isUserAuthenticated = (user != nil)
        }
    }
}
