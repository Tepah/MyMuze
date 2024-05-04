//
//  FirebaseStorage.swift
//  MyMuze
//
//  Created by Pete Potipitak on 5/1/24.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseStorage

func uploadImageToStorage(image: UIImage, userID: String) async -> String {
    let storage = Storage.storage()
    let storageRef = storage.reference()
    let imageRef = storageRef.child("Profile_pics/\(userID).jpg")
    
        
        // Convert Image to UIImage
    let uiImage = image
        
    // Convert UIImage to Data
    guard let imageData = uiImage.jpegData(compressionQuality: 0.7) else {
        print("Failed to convert UIImage to Data")
        return ""
    }
    
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"
    
    // Upload image data to Firebase Storage
    imageRef.putData(imageData, metadata: metadata)
    print("Upload success")
    
    do {
        let downloadURL = try await imageRef.downloadURL().absoluteString
        return downloadURL
    } catch {
        print("Error getting download URL: \(error.localizedDescription)")
        return ""
    }
}
