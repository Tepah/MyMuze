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
    let query = usersCollection.whereField("uid", isEqualTo: uid)

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
