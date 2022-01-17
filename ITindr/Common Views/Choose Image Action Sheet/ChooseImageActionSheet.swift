//
//  ChooseImageActionSheet.swift
//  ITindr
//
//  Created by Эдуард Логинов on 17.10.2021.
//

import UIKit
import PhotosUI

protocol ChooseImageActionSheetDelegate {
    @available(iOS 14, *)
    func PHPickerDelegate() -> PHPickerViewControllerDelegate
    func imagePickerDelegate() -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    func presentAction(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

class ChooseImageActionSheet: UIAlertController {
    
    // MARK: Properties
    var delegate: ChooseImageActionSheetDelegate?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    // MARK: Private Setup Methods
    private func setupActions() {
        let actions = [createCameraAction(), createLibraryAction(), createCancelAction()]
        actions.forEach { addAction($0) }
    }
    
    private func createCameraAction() -> UIAlertAction {
        let cameraAction = UIAlertAction(title: Strings.cameraActionTitle,
                                         style: .default,
                                         handler: { [weak self] action in
            self?.takePhotoFromCamera()
        })
        cameraAction.setValue(Colors.black, forKey: "titleTextColor")
        
        return cameraAction
    }
    
    private func createLibraryAction() -> UIAlertAction {
        let libraryAction = UIAlertAction(title: Strings.libraryActionTitle,
                                          style: .default,
                                          handler: { [weak self] action in
            self?.chooseFromLibrary()
        })
        libraryAction.setValue(Colors.black, forKey: "titleTextColor")
        
        return libraryAction
    }
    
    private func createCancelAction() -> UIAlertAction {
        let cancelAction = UIAlertAction(title: Strings.cancel, style: .cancel)
        cancelAction.setValue(Colors.pink, forKey: "titleTextColor")
        
        return cancelAction
    }
    
    // MARK: Private Utility Methods
    private func takePhotoFromCamera() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .notDetermined: presentCamera()
        case .authorized: presentCamera()
        case .restricted, .denied: alertCameraAccessNeeded()
        default: alertCameraAccessNeeded()
        }
    }
    
    private func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = delegate?.imagePickerDelegate()
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = .camera
            delegate?.presentAction(imagePickerController, animated: true, completion: nil)
        }
    }
    
    private func alertCameraAccessNeeded() {
        let cameraAccessAlert = AlertFactory.createCameraAccessAlert()
        delegate?.presentAction(cameraAccessAlert, animated: true, completion: nil)
    }
    
    private func chooseFromLibrary() {
        if #available(iOS 14, *) {
            var pickerConfiguration = PHPickerConfiguration()
            pickerConfiguration.filter = .images
            pickerConfiguration.selectionLimit = 1
            
            let pickerViewController = PHPickerViewController(configuration: pickerConfiguration)
            pickerViewController.delegate = delegate?.PHPickerDelegate()
            
            delegate?.presentAction(pickerViewController, animated: true, completion: nil)
        } else {
            chooseFromLibraryOld()
        }
    }
    
    private func chooseFromLibraryOld() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            delegate?.presentAction(imagePickerController, animated: true, completion: nil)
        }
    }
}
