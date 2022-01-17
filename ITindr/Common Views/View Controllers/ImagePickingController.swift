//
//  ChooseImageService.swift
//  ITindr
//
//  Created by Эдуард Логинов on 27.11.2021.
//

import UIKit
import PhotosUI

class ImagePickingController: BaseViewController {
    
    // MARK: Public Methods
    func chooseImage() {
        let chooseActionSheet = ChooseImageActionSheet(title: nil, message: nil, preferredStyle: .actionSheet)
        chooseActionSheet.delegate = self
        present(chooseActionSheet, animated: true, completion: nil)
    }
    
    func imageSelected(_ image: UIImage) { }
}

// MARK: ChooseImageActionSheetDelegate
extension ImagePickingController: ChooseImageActionSheetDelegate {
    @available(iOS 14, *)
    func PHPickerDelegate() -> PHPickerViewControllerDelegate {
        return self
    }
    
    func imagePickerDelegate() -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        return self
    }
    
    func presentAction(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

// MARK: PHPickerViewControllerDelegate
extension ImagePickingController: PHPickerViewControllerDelegate {
    @available(iOS 14.0, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        results.forEach { $0.itemProvider.loadObject(
            ofClass: UIImage.self,
            completionHandler: { (object, error) in
              if let image = object as? UIImage {
                 DispatchQueue.main.async { [weak self] in
                     self?.imageSelected(image)
                 }
              }
           })
        }
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ImagePickingController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            
            if let image = info[.originalImage] as? UIImage {
                imageSelected(image)
            }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

