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
    @AppStorage("phoneNumber") private var phoneNumber: String?
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authManager = AuthManager()
    @State private var userExists: Bool?
    @State private var userData: UserData?
    
    
    var body: some Scene {
        WindowGroup {
            if authManager.isUserAuthenticated {
                if let userExists = authManager.userExists {
                    if userExists {
                        ContentView()
                            .environmentObject(authManager)
                            .onChange(of: authManager.userExists) { _ in
                                if authManager.phoneNumber != "" {
                                    authManager.phoneNumber = ""
                                }
                                loadData()
                            }
                    } else {
                        SignUpView()
                            .environmentObject(authManager)
                            .onChange(of: authManager.userExists) { _ in
                                if authManager.phoneNumber != "" {
                                    authManager.phoneNumber = ""
                                }
                                loadData()
                            }
                            .onChange(of: authManager.phoneNumber) { newPhoneNumber in
                                // Update the persisted phone number whenever it changes
                                authManager.persistedPhoneNumber = newPhoneNumber
                            }
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
                    .onAppear {
                        // Retrieve the persisted phone number, if any
                        authManager.phoneNumber = authManager.persistedPhoneNumber ?? ""
                    }
                    .onChange(of: authManager.phoneNumber) { newPhoneNumber in
                        // Update the persisted phone number whenever it changes
                        authManager.persistedPhoneNumber = newPhoneNumber
                    }
            }
        }
    }
    
    func loadData() {
        Task {
            do {
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    userExists = await doesUserExistWithUID(uid: uid)
                    authManager.userExists = userExists
                    if authManager.userExists == true {
                        userData = try await getUser(uid: uid)
                        authManager.user = userData!.username
                    }
                }
            } catch {
                print("Error loading data:", error.localizedDescription)
            }
        }
    }
}


class AuthManager: ObservableObject {
    // Published property to trigger UI updates
    @Published var isUserAuthenticated = false
    @Published var phoneNumber: String = ""
    @Published var userExists: Bool?
    @Published var user: String = ""

    init() {
        // Add authentication state change observer
        Auth.auth().addStateDidChangeListener { (_, user) in
            self.isUserAuthenticated = (user != nil)
        }
    }
    
    func signUp() {
        userExists = nil
    }
}

extension AuthManager {
    // Extension to handle persistently storing and retrieving the phone number
    var persistedPhoneNumber: String {
        get {
            UserDefaults.standard.string(forKey: "persistedPhoneNumber") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "persistedPhoneNumber")
        }
    }
    
    var checkExistence: Bool {
        get {
            UserDefaults.standard.bool(forKey: "userExists")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userExists")
        }
    }
    
    var persistedUser: String {
        get {
            UserDefaults.standard.string(forKey: "persistedUser") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "persistedUser")
        }
    }
}
