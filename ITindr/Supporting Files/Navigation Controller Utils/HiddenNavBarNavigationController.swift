//
//  HiddenNavBarNavigationController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 24.10.2021.
//

import UIKit

class HiddenNavBarNavigationController: UINavigationController, NavigationControllerProtocol {
    func setupCommonNavigationBarSettings() {
        navigationBar.isHidden = true
    }
}
