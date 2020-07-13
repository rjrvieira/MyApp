//
//  ImagePicker.swift
//  MyApp
//
//  Created by Ricardo Vieira on 02/07/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

//import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode)
    var presentationMode

    @Binding var image: Image?
    @Binding var profilePhoto: UIImage?
    @Binding var imageExtension: String?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var presentationMode: PresentationMode
        @Binding var image: Image?
        @Binding var profilePhoto: UIImage?
        @Binding var imageExtension: String?

        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>, profilePhoto: Binding<UIImage?>, imageExtension: Binding<String?>) {
            _presentationMode = presentationMode
            _image = image
            _profilePhoto = profilePhoto
            _imageExtension = imageExtension
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            profilePhoto = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
            image = Image(uiImage: profilePhoto!)
            
            let assetPath = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
            if (assetPath.absoluteString?.hasSuffix("jpg"))! || (assetPath.absoluteString?.hasSuffix("JPG"))! {
                imageExtension = "jpg"
            }
            else if (assetPath.absoluteString?.hasSuffix("jpeg"))! || (assetPath.absoluteString?.hasSuffix("JPEG"))! {
                imageExtension = "jpeg"
            }
            else if (assetPath.absoluteString?.hasSuffix("png"))! || (assetPath.absoluteString?.hasSuffix("PNG"))! {
                imageExtension = "png"
            }
            
            presentationMode.dismiss()

        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image, profilePhoto: $profilePhoto, imageExtension: $imageExtension)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

}
