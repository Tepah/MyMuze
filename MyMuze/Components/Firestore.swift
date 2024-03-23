//
//  Firestore.swift
//  MyMuze
//
//  Created by Pete Potipitak on 3/4/24.
//

import Foundation

import FirebaseFirestore

func doesUserExistWithUID(uid: String) async -> Bool {
    let db = Firestore.firestore()
    let usersCollection = db.collection("users")

    // Perform a query to find the document with the specified UID
    let query = usersCollection.whereField("userId", isEqualTo: uid)

    do {
        let snapshot = try await query.getDocuments()

        // Check if there is at least one document matching the UID
        return !snapshot.documents.isEmpty
    } catch {
        // Handle the error if needed
        print("Error searching for user:", error.localizedDescription)
        return false
    }
}

func addUserDataToFirestore(userData: UserData) {
    let db = Firestore.firestore()
    let usersCollection = db.collection("users")

    // Convert UserData to dictionary
    let userDataDictionary = userData.toDictionary()

    // Add data to Firestore
    usersCollection.document(userData.userID).setData(userDataDictionary) { error in
        if let error = error {
            print("Error adding document: \(error.localizedDescription)")
        } else {
            print("Document added successfully!")
        }
    }
}

func getUser(uid: String) async throws -> UserData {
    let db = Firestore.firestore()
    let userRef = db.collection("users").document(uid)

    let document = try await userRef.getDocument()
    let profilePic = document.get("profilePicture") as! String
    let username = document.get("username") as! String
    let name = document.get("name") as! String
    let email = document.get("email") as! String
    let privateAcc = document.get("privateAcc") as! Bool
    return UserData(profilePicture: profilePic, username: username, email: email, name: name, userID: uid, phone: "", followers: [], following: [], privateAcc: privateAcc)
}


