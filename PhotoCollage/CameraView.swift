//
//  ImagePicker.swift
//  PhotoCollage
//
//  Created by cmStudent on 2024/07/04.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    @Binding var isShowingCameraView: Bool
    @Binding var captureImage: UIImage?
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        init(_ parent: CameraView) {
            self.parent = parent
        }
        internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.captureImage = originalImage
            }
            parent.isShowingCameraView.toggle()
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShowingCameraView.toggle()
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = context.coordinator
        return imagePickerController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
