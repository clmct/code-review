//
//  BaseViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 27.11.2021.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: Properties
    private let baseViewModel: BaseViewModel
    
    // MARK: Init
    init(viewModel: BaseViewModel) {
        baseViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Setup Methods
    func setupBackButton(
        text: String = Strings.back,
        font: UIFont = .mediumLabel,
        color: UIColor = Colors.pink ?? Colors.white) {
        let backButton = UIBarButtonItem()
        backButton.title = text
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        backButton.tintColor = color
        navigationItem.backBarButtonItem = backButton
    }
    
    func setupNavigationBarTitleView(image: UIImage?, titleText: String) {
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.textColor = Colors.pink
        titleLabel.font = .mediumLabelSemibold
        
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel])
        titleStackView.axis = .horizontal
        titleStackView.spacing = 8
        guard let image = image else {
            navigationItem.titleView = titleStackView
            return
        }
        
        let imageView = UIImageView(image: image)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(32)
            make.height.equalTo(imageView.snp.width)
        }
        
        imageView.tintColor = Colors.gray
        imageView.backgroundColor = Colors.lightGray
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        titleStackView.insertArrangedSubview(imageView, at: 0)
        navigationItem.titleView = titleStackView
    }
    
    func bindToViewModel() {
        baseViewModel.didStartRequest = { [weak self] in
            self?.disableUserInteraction()
        }
        
        baseViewModel.didFinishRequest = { [weak self] in
            self?.enableUserInteraction()
        }
        
        baseViewModel.didRecieveError = { [weak self] error in
            self?.showErrorAlert(error)
        }
        
        baseViewModel.didNotAuthorize = { [weak self] networkManager in
            self?.kickUserToWelcomeScreen(networkManager: networkManager)
        }
    }
    
    // MARK: Public Utility Methods
    func enableUserInteraction() {
        view.isUserInteractionEnabled = true
        navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    func disableUserInteraction() {
        view.isUserInteractionEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    
    func kickUserToWelcomeScreen(networkManager: NetworkService?) {
        if let tabBarVC = tabBarController {
            tabBarVC.navigationController?.setViewControllers([WelcomeViewController(networkManager: networkManager)],
                                                              animated: true)
            return
        }
        navigationController?.setViewControllers([WelcomeViewController(networkManager: networkManager)],
                                                 animated: true)
    }
    
    func showErrorAlert(_ error: Error) {
        let alert = AlertFactory.createErrorAlert(message: error.localizedDescription)
        present(alert, animated: true)
        enableUserInteraction()
    }
}
