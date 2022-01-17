//
//  NavigationController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 10.10.2021.
//

import UIKit

protocol NavigationControllerProtocol: UINavigationController {
    func setupCommonNavigationBarSettings()
}

class NavigationController: UINavigationController, NavigationControllerProtocol {
    func setupCommonNavigationBarSettings() {
        navigationBar.backgroundColor = Colors.transparent
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = Colors.pink
        navigationBar.barTintColor = Colors.white
        
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.mediumLabelSemibold,
            NSAttributedString.Key.foregroundColor: Colors.pink ?? UIColor.systemGray
        ]
    }
}
