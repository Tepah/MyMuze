//
//  Firestore.swift
//  MyMuze
//
//  Created by Pete Potipitak on 3/4/24.
//

import Foundation

import FirebaseFirestore

// Firestore User Collection Functions
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

func updateProfilePictureUrl(uid: String, profilePicURL: String) async {
    let db = Firestore.firestore()
    let userRef = db.collection("users").document(uid)

    // Update the profile picture URL in the user document
    userRef.updateData(["profilePicture": profilePicURL]) { error in
        if let error = error {
            print("Error updating document: \(error.localizedDescription)")
        } else {
            print("Document updated successfully!")
        }
    }
}

func addFollowerToUserData(uid: String, followerUID: String) async {
    var db = Firestore.firestore()
    var userRef = db.collection("users").document(uid)

    // Add the follower UID to the 'followers' array
    userRef.updateData(["followers": FieldValue.arrayUnion([followerUID])]) { error in
        if let error = error {
            print("Error updating document: \(error.localizedDescription)")
        } else {
            print("Document updated successfully!")
        }
    }
    
    db = Firestore.firestore()
    userRef = db.collection("users").document(followerUID)
    
    userRef.updateData(["following": FieldValue.arrayUnion([uid])]) { error in
        if let error = error {
            print("Error updating document: \(error.localizedDescription)")
        } else {
            print("Document updated successfully!")
        }
    }
}

func removeFollowerFromUserData(uid: String, followerUID: String) async {
    var db = Firestore.firestore()
    var userRef = db.collection("users").document(uid)

    // Remove the follower UID from the 'followers' array
    userRef.updateData(["followers": FieldValue.arrayRemove([followerUID])]) { error in
        if let error = error {
            print("Error updating document: \(error.localizedDescription)")
        } else {
            print("Document updated successfully!")
        }
    }
    
    db = Firestore.firestore()
    userRef = db.collection("users").document(followerUID)
    
    userRef.updateData(["following": FieldValue.arrayRemove([uid])]) { error in
        if let error = error {
            print("Error updating document: \(error.localizedDescription)")
        } else {
            print("Document updated successfully!")
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
    let followers = document.get("followers") as! [String]
    let following = document.get("following") as! [String]
    return UserData(profilePicture: profilePic, username: username, email: email, name: name, userID: uid, phone: "", followers: followers, following: following, privateAcc: privateAcc)
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

// Firestore Post Collection Function(s)
func createPost(post: PostData) {
    let db = Firestore.firestore()
    let postRef = db.collection("posts").document()
    
    let postDict = post.toDictionary()
    
    postRef.setData(postDict) { error in
        if let error = error {
            print("Error adding post: \(error.localizedDescription)")
        } else {
            print("Post created successfully!")
        }
    }
}

func collectDailyFeed(date: String) async throws -> [PostData] {
    let db = Firestore.firestore()
    let postCollection = db.collection("posts")

    // Perform a query to find all posts for the specified date
    let query = postCollection.whereField("date", isEqualTo: date)

    // Get the documents matching the query
    let querySnapshot = try await query.getDocuments()

    // Map the documents to PostData objects
    let posts = querySnapshot.documents.compactMap { document in
        let username = document.get("username") as! String
        let date = document.get("date") as! String
        let uid = document.get("uid") as! String
        let track = document.get("track") as! String
        let artist = document.get("artist") as! String
        let cover = document.get("cover") as! String
//        let likes = document.get("likes") as? Int
//        let comments = document.get("comments") as? [String]
        return PostData(uid: uid, username: username, date: date, track: track, artist: artist, cover: cover)
    }

    return posts
}

func didUserPost(uid: String) async -> Bool {
    let db = Firestore.firestore()
    let postCollection = db.collection("posts")
    let today = Date().formatted(date: .long, time: .omitted)

    // Perform a query to find the document with the specified UID
    let userQuery = postCollection.whereField("uid", isEqualTo: uid)
    let dateQuery = userQuery.whereField("date", isEqualTo: today)

    do {
        let snapshot = try await dateQuery.getDocuments()

        // Check if there is a post by the UID
        return !snapshot.documents.isEmpty
    } catch {
        // Handle the error if needed
        print("Error searching for post by user:", error.localizedDescription)
        return false
    }
}

// Firestore Notification Collection Functions
func createNotification(notification: Notification) {
    let db = Firestore.firestore()
    let notificationRef = db.collection("notifications").document()
    
    let notificationDict = notification.toDictionary()
    
    notificationRef.setData(notificationDict) { error in
        if let error = error {
            print("Error adding notification: \(error.localizedDescription)")
        } else {
            print("Notification added successfully!")
        }
    }
}

func checkNotificationExists(toUser: String, fromUser: String, type: String) async throws -> Bool {
    let db = Firestore.firestore()
    let notificationsCollection = db.collection("notifications")

    // Perform a query to find the document with the specified username and type
    let query = notificationsCollection.whereField("uid", isEqualTo: toUser).whereField("type", isEqualTo: type).whereField("receivingUID", isEqualTo: fromUser)

    // Get the documents matching the query
    let querySnapshot = try await query.getDocuments()

    // Check if there is at least one document matching the username and type
    return !querySnapshot.documents.isEmpty
}

func getNotificationsForUser(uid: String) async throws -> [Notification] {
    let db = Firestore.firestore()
    let notificationsCollection = db.collection("notifications")

    // Perform a query to find all notifications for the specified user
    let query = notificationsCollection.whereField("uid", isEqualTo: uid)

    // Get the documents matching the query
    let querySnapshot = try await query.getDocuments()

    // Map the documents to Notification objects
    let notifications = querySnapshot.documents.compactMap { document in
        let type = document.get("type") as! String
        let timestamp = document.get("timestamp") as! String
        let uid = document.get("uid") as! String
        let receivingUID = document.get("receivingUID") as! String
        let message = document.get("message") as? String
        let user = document.get("user") as? String
        let postID = document.get("postID") as? String
        let currentUser = document.get("currentUser") as? String
        return Notification(notificationID: document.documentID,type: type, timestamp: timestamp, uid: uid, receivingUID: receivingUID, message: message, user: user, currentUser: currentUser, postID: postID)
    }

    return notifications
}

func deleteNotification(notification: String) {
    let db = Firestore.firestore()
    let notificationRef = db.collection("notifications").document(notification)
    
    notificationRef.delete { error in
        if let error = error {
            print("Error deleting notification: \(error.localizedDescription)")
        } else {
            print("Notification deleted successfully!")
        }
    }
}
