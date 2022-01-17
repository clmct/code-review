//
//  AlertFactory.swift
//  ITindr
//
//  Created by Эдуард Логинов on 25.10.2021.
//

import UIKit

class AlertFactory {
    static func createAlert(title: String, message: String, cancelActionTitle: String? = nil) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        let alertAction = UIAlertAction(
            title: cancelActionTitle ?? Strings.ok,
            style: .cancel,
            handler: nil)
        alertAction.setValue(Colors.pink, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        
        return alert
    }
    
    static func createErrorAlert(
        title: String = Strings.errorAlertTitle,
        message: String,
        cancelActionTitle: String? = nil) -> UIAlertController {
        return createAlert(title: title, message: message, cancelActionTitle: cancelActionTitle)
    }
    
    static func createCameraAccessAlert() -> UIAlertController {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString) ?? URL(fileURLWithPath: "")
        
        let cameraAccessAlert = createAlert(
            title: Strings.cameraAccessAlertTitle,
            message: Strings.cameraAccessAlertMessage,
            cancelActionTitle: Strings.notNow
        )
    
        let settingsAction = UIAlertAction(
            title: Strings.settingsActionTitle,
            style: .default,
            handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        })
        settingsAction.setValue(Colors.pink, forKey: "titleTextColor")
        cameraAccessAlert.addAction(settingsAction)
        
        return cameraAccessAlert
    }
}
