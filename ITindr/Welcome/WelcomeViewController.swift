//
//  WelcomeViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 10.10.2021.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    
    // MARK: Properties
    private let networkManager: NetworkService
    
    private let appLogoImageView = UIImageView(image: UIImage(named: ImageNames.appLogo))
    private let welcomeHeaderLabel = UILabel()
    private let welcomeImageView = UIImageView(image: UIImage(named: ImageNames.welcomePeople))
    private let signUpButton = GradientButton(Strings.signUp)
    private let signInButton = SolidButton(Strings.signIn)
    
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
    
    // MARK: Actions
    @objc private func navigateSignUp() {
        navigationController?.pushViewController(SignUpViewController(networkManager: networkManager), animated: true)
    }
    
    @objc private func navigateSignIn() {
        navigationController?.pushViewController(SignInViewController(networkManager: networkManager), animated: true)
    }
    
    // MARK: Private Setup Methods
    private func setup() {
        setupView()
        setupAppLogoImageView()
        setupWelcomeHeaderLabel()
        setupWelcomeImageView()
        setupSignUpButton()
        setupSignInButton()
    }
    
    private func setupView() {
        view.backgroundColor = Colors.white
        view.addSubview(appLogoImageView)
        view.addSubview(welcomeHeaderLabel)
        view.addSubview(welcomeImageView)
        view.addSubview(signUpButton)
        view.addSubview(signInButton)
    }
    
    private func setupAppLogoImageView() {
        appLogoImageView.contentMode = .scaleAspectFit
        appLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Dimensions.logoTopInset)
            make.bottom.equalTo(welcomeHeaderLabel.snp.top).inset(-Dimensions.smallInset)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(Dimensions.logoWidth)
        }
    }
    
    private func setupWelcomeHeaderLabel() {
        welcomeHeaderLabel.text = Strings.welcomeHeader
        welcomeHeaderLabel.textColor = Colors.pink
        welcomeHeaderLabel.font = .defaultLabelBold
        welcomeHeaderLabel.numberOfLines = 0
        welcomeHeaderLabel.snp.makeConstraints { make in
            make.bottom.equalTo(welcomeImageView.snp.top).inset(-Dimensions.largeInset)
            make.leading.trailing.equalTo(appLogoImageView)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupWelcomeImageView() {
        welcomeImageView.contentMode = .scaleAspectFit
        welcomeImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupSignUpButton() {
        signUpButton.addTarget(self, action: #selector(navigateSignUp), for: .touchUpInside)
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(signInButton.snp.top).inset(-Dimensions.defaultInset)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Dimensions.defaultInset)
            make.height.equalTo(Dimensions.defaultHeight)
        }
    }
    
    private func setupSignInButton() {
        signInButton.addTarget(self, action: #selector(navigateSignIn), for: .touchUpInside)
        signInButton.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Dimensions.defaultInset)
            make.height.equalTo(Dimensions.defaultHeight)
        }
    }
}

// MARK: Dimensions
private extension Dimensions {
    static let logoTopInset: CGFloat = 88
    static let logoWidth: CGFloat = 187
}
