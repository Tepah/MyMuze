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

func searchUsersWithPrefix(prefix: String, completion: @escaping ([String]) -> Void) {
    let db = Firestore.firestore()
    // Grabs every user that starts with the prefix
    let usersCollection = db.collection("users")
        .whereField("username", isGreaterThanOrEqualTo: prefix)
        .whereField("username", isLessThan: prefix + "\u{f8ff}")
        .getDocuments { (usernameSnapshot, error) in
            if let error = error {
                print("Error searching for users: ", error.localizedDescription)
                completion([])
                return
            }
            
            db.collection("users")
                .whereField("name", isGreaterThanOrEqualTo: prefix)
                .whereField("name", isLessThan: prefix + "\u{f8ff}")
                .getDocuments { (nameSnapshot, error) in
                    if let error = error {
                        print("No user found with that name prefix: ", error.localizedDescription)
                        completion([])
                        return
                    }
                    
                    let usernameResults = usernameSnapshot?.documents.map { $0.documentID } ?? []
                    let nameResults = nameSnapshot?.documents.map { $0.documentID } ?? []
                    let combinedResults = Array(Set(usernameResults + nameResults))
                    
                    completion(combinedResults)
                    
                    print("Retrieved all users with the prefix: \(prefix)")
                    print(completion)
                }
        }
}
