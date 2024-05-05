//
//  PictureChanger.swift
//  Used to change profile pictures in Sign in and Edit profiles
//
//  Created by Pete Potipitak on 5/3/24.
//

import SwiftUI
import PhotosUI
import URLImage

struct PictureChanger: View {
    @State private var isShowingPhotoPicker = false
    
    @Binding var selectedImage: UIImage?
    var profilePicURL: String?
    
    init(selectedImage: Binding<UIImage?>, profilePicURL: String?) {
        self._selectedImage = selectedImage
        self.profilePicURL = profilePicURL
    }
    init(selectedImage: Binding<UIImage?>) {
        self._selectedImage = selectedImage
        self.profilePicURL = nil
    }
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .foregroundColor(Color.gray)
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "pencil.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 50))
                            .foregroundColor(Color.myMuzeAccent)
                            .onTapGesture {
                                self.isShowingPhotoPicker.toggle()
                            }
                            .sheet(isPresented: $isShowingPhotoPicker) {
                                PhotoPicker(selectedImage: self.$selectedImage, isShowingPhotoPicker: self.$isShowingPhotoPicker) {
                                    isShowingPhotoPicker = false
                                }
                            }
                            .onChange(of: selectedImage) { image in
                                isShowingPhotoPicker = false
                            }
                    }
            } else if profilePicURL != nil {
                URLImage(URL(string: profilePicURL!)!) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .foregroundColor(Color.gray)
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 50))
                        .foregroundColor(Color.myMuzeAccent)
                        .onTapGesture {
                            self.isShowingPhotoPicker.toggle()
                        }
                        .sheet(isPresented: $isShowingPhotoPicker) {
                            PhotoPicker(selectedImage: self.$selectedImage, isShowingPhotoPicker: self.$isShowingPhotoPicker) {
                                isShowingPhotoPicker = false
                            }
                        }
                        .onChange(of: selectedImage) { image in
                            isShowingPhotoPicker = false
                        }
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .foregroundColor(Color.gray)
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "pencil.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 50))
                            .foregroundColor(Color.myMuzeAccent)
                            .onTapGesture {
                                self.isShowingPhotoPicker.toggle()
                            }
                            .sheet(isPresented: $isShowingPhotoPicker) {
                                PhotoPicker(selectedImage: self.$selectedImage, isShowingPhotoPicker: self.$isShowingPhotoPicker) {
                                    isShowingPhotoPicker = false
                                }
                            }
                            .onChange(of: selectedImage) { image in
                                isShowingPhotoPicker = false
                            }
                    }
            }
        }
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
