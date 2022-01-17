//
//  AuthView.swift
//  ITindr
//
//  Created by Эдуард Логинов on 18.11.2021.
//

import UIKit
import SnapKit
import TPKeyboardAvoiding

class AuthView: TPKeyboardAvoidingScrollView {
    
    // MARK: Properties
    private let appLogoImageView = UIImageView(image: UIImage(named: ImageNames.appLogo))
    private let userFormStack = UIStackView()
    private let formHeaderLabel = UILabel()
    private let emailTextField = CommonTextField()
    private let passwordTextField = CommonTextField()
    private let actionButton = GradientButton(Strings.signIn)
    private let backButton = SolidButton(Strings.back)
    
    private var viewModel: AuthViewModel?
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func addTextField(_ textField: UITextField) {
        userFormStack.addArrangedSubview(textField)
    }
    
    func configure(with viewModel: AuthViewModel) {
        self.viewModel = viewModel
        
        viewModel.didUpdateLabels = { [weak self] in
            self?.updateLabels()
        }
    }
    
    // MARK: Actions
    @objc private func actionTapped() {
        viewModel?.actionTapped(email: emailTextField.text, password: passwordTextField.text)
    }
    
    @objc private func backTapped() {
        viewModel?.backTapped()
    }
    
    // MARK: Private Setup Methods
    private func updateLabels() {
        formHeaderLabel.text = viewModel?.headerText
        actionButton.setTitle(viewModel?.actionButtonText, for: .normal)
        backButton.setTitle(viewModel?.backButtonText, for: .normal)
    }
    
    private func setup() {
        setupView()
        setupAppLogoImageView()
        setupUserFormStack()
        setupFormHeaderLabel()
        setupEmailTextField()
        setupPasswordTextField()
        setupActionButton()
        setupBackButton()
    }
    
    private func setupView() {
        backgroundColor = Colors.white
        addSubview(appLogoImageView)
        addSubview(userFormStack)
        addSubview(actionButton)
        addSubview(backButton)
        userFormStack.addArrangedSubview(formHeaderLabel)
        userFormStack.addArrangedSubview(emailTextField)
        userFormStack.addArrangedSubview(passwordTextField)
    }
    
    private func setupAppLogoImageView() {
        appLogoImageView.contentMode = .scaleAspectFit
        appLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(Dimensions.defaultInset)
            make.bottom.equalTo(userFormStack.snp.top).inset(-Dimensions.mediumPlusInset)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func setupUserFormStack() {
        userFormStack.axis = .vertical
        userFormStack.spacing = Dimensions.defaultInset
        userFormStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(Dimensions.defaultInset)
        }
    }
    
    private func setupFormHeaderLabel() {
        formHeaderLabel.textAlignment = .natural
        formHeaderLabel.textColor = Colors.pink
        formHeaderLabel.font = .largeLabelBold
    }
    
    private func setupEmailTextField() {
        emailTextField.placeholder = Strings.emailPlaceholder
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(Dimensions.defaultHeight)
        }
    }
    
    private func setupPasswordTextField() {
        passwordTextField.placeholder = Strings.passwordPlaceholder
        passwordTextField.isSecureTextEntry = true
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(Dimensions.defaultHeight)
        }
    }
    
    private func setupActionButton() {
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        actionButton.snp.makeConstraints { make in
            make.bottom.equalTo(backButton.snp.top).inset(-Dimensions.defaultInset)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(Dimensions.defaultInset)
            make.height.equalTo(Dimensions.defaultHeight)
        }
    }
    
    private func setupBackButton() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(safeAreaLayoutGuide).inset(Dimensions.defaultInset)
            make.height.equalTo(Dimensions.defaultHeight)
        }
    }
}
