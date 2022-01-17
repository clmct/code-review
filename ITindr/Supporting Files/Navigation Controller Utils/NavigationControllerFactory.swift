//
//  NavigationControllerFactory.swift
//  ITindr
//
//  Created by Эдуард Логинов on 10.10.2021.
//

import UIKit

class NavigationControllerFactory {
    static func createNavigationCotroller(rootViewController: UIViewController) -> UINavigationController {
        let navController = NavigationController(rootViewController: rootViewController)
        navController.setupCommonNavigationBarSettings()
        
        return navController
    }
    
    static func createHiddenNavBarNavigationController(rootViewController: UIViewController) -> UINavigationController {
        let navController = HiddenNavBarNavigationController(rootViewController: rootViewController)
        navController.setupCommonNavigationBarSettings()
        
        return navController
    }
}
