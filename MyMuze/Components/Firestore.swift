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
    
    // Retrieves document with matching uid
    let document = try await userRef.getDocument()
    
    // Retrieves user data and casts to userData object
    let profilePic = document.get("profilePicture") as! String
    let username = document.get("username") as! String
    let name = document.get("name") as! String
    let email = document.get("email") as! String
    let privateAcc = document.get("privateAcc") as! Bool
    return UserData(profilePicture: profilePic, username: username, email: email, name: name, userID: uid, phone: "", followers: [], following: [], privateAcc: privateAcc)
}

func searchUsersWithPrefix(prefix: String) async throws -> [String] {
    let db = Firestore.firestore()

    // Perform the first query asynchronously
    let usernameQuerySnapshot = try await db.collection("users")
        .whereField("username", isGreaterThanOrEqualTo: prefix)
        .whereField("username", isLessThan: prefix + "\u{f8ff}")
        .getDocuments()

    // Perform the second query asynchronously
    let nameQuerySnapshot = try await db.collection("users")
        .whereField("name", isGreaterThanOrEqualTo: prefix)
        .whereField("name", isLessThan: prefix + "\u{f8ff}")
        .getDocuments()

    // Extract the document IDs from the query snapshots
    let usernameResults = usernameQuerySnapshot.documents.map { $0.documentID }
    let nameResults = nameQuerySnapshot.documents.map { $0.documentID }

    // Combine and remove duplicates from the results
    let combinedResults = Array(Set(usernameResults + nameResults))

    return combinedResults
}
