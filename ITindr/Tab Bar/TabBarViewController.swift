//
//  TabBarViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 18.10.2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: Properties
    private let networkManager: NetworkService
    
    // MARK: Init
    init(networkManager: NetworkService?) {
        self.networkManager = networkManager ?? NetworkService(defaultsManager: UserDefaultsManager())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Private Setup Methods
    private func setup() {
        setupTabBar()
        setupViewControllers()
        setupItems()
        selectedIndex = 0
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = Colors.white
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        tabBar.layer.shadowColor = Colors.black.cgColor
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowRadius = 24
        tabBar.layer.shadowPath = UIBezierPath(rect: tabBar.bounds).cgPath
        tabBar.clipsToBounds = false
        
        tabBar.tintColor = Colors.pink
        tabBar.unselectedItemTintColor = Colors.gray
    }
    
    private func setupViewControllers() {
        let viewControllers = [
            NavigationControllerFactory.createHiddenNavBarNavigationController(
                rootViewController: PeopleFlowViewController(
                    networkManager: networkManager)),
            NavigationControllerFactory.createNavigationCotroller(
                rootViewController: PeopleViewController(
                    networkManager: networkManager)),
            NavigationControllerFactory.createNavigationCotroller(
                rootViewController: ChatsListViewController(
                    networkManager: networkManager)),
            NavigationControllerFactory.createNavigationCotroller(
                rootViewController: ProfileViewController(
                    networkManager: networkManager))
        ]
        
        setViewControllers(viewControllers, animated: true)
    }
    
    private func setupItems() {
        let items = [
            UITabBarItem(title: Strings.stream, image: UIImage(named: ImageNames.streamIcon), tag: 0),
            UITabBarItem(title: Strings.people, image: UIImage(named: ImageNames.peopleIcon), tag: 1),
            UITabBarItem(title: Strings.chats, image: UIImage(named: ImageNames.chatsIcon), tag: 2),
            UITabBarItem(title: Strings.profile, image: UIImage(named: ImageNames.personIcon), tag: 3)
        ]
        
        for itemIndex in 0..<(tabBar.items?.count ?? 0) {
            tabBar.items?[itemIndex].setTitleTextAttributes(
                [NSAttributedString.Key.font: UIFont.smallerLabelMedium],
                for: .normal)
            tabBar.items?[itemIndex].title = items[itemIndex].title
            tabBar.items?[itemIndex].image = items[itemIndex].image
        }
    }
}
