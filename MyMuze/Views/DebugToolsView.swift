//
//  DebugToolsView.swift
//  MyMuze
//
//  Created by Pete Potipitak on 4/6/24.
//

import SwiftUI
import PhotosUI
import FirebaseAuth

struct DebugToolsView: View {
    @EnvironmentObject var authManager: AuthManager
    
    @State private var selectedImage: UIImage?
    @State private var isShowingPhotoPicker = false
    @State private var loading = false
    
    var body: some View {
        BackgroundView()
            .overlay(
        VStack {
            // Profile Picture Change
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 230, height: 230)
                    .clipShape(Circle())
                    .foregroundColor(Color.gray)
            } else {
                Text("No image selected")
            }
            
            Button("Change Profile Picture") {
                self.isShowingPhotoPicker.toggle()
            }
            .padding()
            .sheet(isPresented: $isShowingPhotoPicker) {
                PhotoPicker(selectedImage: self.$selectedImage, isShowingPhotoPicker: self.$isShowingPhotoPicker) {
                    isShowingPhotoPicker = false
                }
            }
            .onChange(of: selectedImage) { image in
                isShowingPhotoPicker = false
            }
            
            Button("Save Profile Picture") {
                Task {
                    if let image = selectedImage {
                        let uid = Auth.auth().currentUser?.uid ?? "temp"
                        loading = true
                        let profilePicURL = await uploadImageToStorage(image: image, userID: uid)
                        print(profilePicURL)
                    }
                }
            }
            
            // Sign Out Button
            Button(action: {
                do {
                    // Set isLoggedIn to false
                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
                    UserDefaults.standard.set("", forKey: "uid")
                    authManager.userExists = nil
                    authManager.user = ""
                    try Auth.auth().signOut()
                } catch {
                    print("Error signing out: \(error.localizedDescription)")
                }
            }) {
                Rectangle()
                    .foregroundColor(Color.red)
                    .frame(width: 200, height: 50)
                    .cornerRadius(10)
                    .overlay(
                        Text("Sign Out")
                            .foregroundColor(Color.white)
                            .font(.title)
                    )
            }
//            Text("Notifcations")
//                .foregroundColor(Color.white)
//                .font(.title)
//            HStack {
//                Button(action: {
//                    // Make a follower notification (No actual new follower)
//                    let uid = Auth.auth().currentUser?.uid ?? "temp"
//                    print(uid)
//                    let notification = Notification(type: "follow", timestamp: Date().description, uid: uid, receivingUID: "temp", user: "temp")
//                    
//                    createNotification(notification: notification)
//                }) {
//                    Rectangle()
//                        .foregroundColor(Color.green)
//                        .frame(width: 80, height: 30)
//                        .cornerRadius(10)
//                        .overlay(
//                            Text("follower")
//                                .foregroundColor(Color.white)
//                        )
//                }
//                Button(action: {
//                    // Make a request Notification (New request will allow a fake follower)
//                    let uid = Auth.auth().currentUser?.uid ?? "temp"
//                    print(authManager.user);
//                    let notification = Notification(type: "request", timestamp: Date().description, uid: uid, receivingUID: "temp", user: "user", currentUser: authManager.user)
//                    createNotification(notification: notification)
//                }) {
//                    Rectangle()
//                        .foregroundColor(Color.green)
//                        .frame(width: 80, height: 30)
//                        .cornerRadius(10)
//                        .overlay(
//                            Text("request")
//                                .foregroundColor(Color.white)
//                        )
//                }
//                Button(action: {
//                    // Make a comment Notification (On a fake post)
//                    let uid = Auth.auth().currentUser?.uid ?? "temp"
//                    let notification = Notification(type: "comment", timestamp: Data().description, uid: uid, receivingUID: "temp", message: "This is a message", user: "temp", postID: "fakeID")
//                    
//                    createNotification(notification: notification)
//                }) {
//                    Rectangle()
//                        .foregroundColor(Color.green)
//                        .frame(width: 80, height: 30)
//                        .cornerRadius(10)
//                        .overlay(
//                            Text("comment")
//                                .foregroundColor(Color.white)
//                        )
//                }
//                Button(action: {
//                    // Make a comment Notification (On a fake post)
//                    let uid = Auth.auth().currentUser?.uid ?? "temp"
//                    let notification = Notification(type: "like", timestamp: Data().description, uid: uid, receivingUID: "temp", user: "temp", postID: "fakeID")
//                    
//                    createNotification(notification: notification)
//                }) {
//                    Rectangle()
//                        .foregroundColor(Color.green)
//                        .frame(width: 80, height: 30)
//                        .cornerRadius(10)
//                        .overlay(
//                            Text("like")
//                                .foregroundColor(Color.white)
//                        )
//                }
//            }
        }
        )
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isShowingPhotoPicker: Bool
    var onDismiss: () -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // Update the view controller if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        
        init(parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let itemProvider = results.first?.itemProvider,
               itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.selectedImage = image
                            self.parent.onDismiss() // Dismiss the picker
                        }
                    }
                }
            } else {
                // Dismiss the picker if no image is selected
                self.parent.onDismiss()
            }
        }
    }
}

#Preview {
    DebugToolsView()
}
