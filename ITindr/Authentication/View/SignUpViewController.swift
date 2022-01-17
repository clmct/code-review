//
//  SignUpViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 11.10.2021.
//

import UIKit
import SnapKit

class SignUpViewController: BaseViewController {
    
    // MARK: Properties
    private let viewModel: SignUpViewModel
    
    private let authView = AuthView()
    private let repeatPasswordTextField = CommonTextField()
    
    // MARK: Init
    init(networkManager: NetworkService) {
        viewModel = SignUpViewModel(networkManager: networkManager)
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        authView.configure(with: viewModel.authViewModel)
        viewModel.start()
        setup()
    }
    
    // MARK: Public Methods
    override func bindToViewModel() {
        super.bindToViewModel()
        
        viewModel.didSignUp = { [weak self] networkManager in
            self?.navigationController?.pushViewController(
                AboutYourselfViewController(networkManager: networkManager),
                animated: true)
        }
        
        viewModel.didTapSignUp = { [weak self] email, password in
            self?.viewModel.signUp(email: email,
                                   password: password,
                                   repeatPassword: self?.repeatPasswordTextField.text)
        }
        
        viewModel.didTapBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: Private Setup Methods
    private func setup() {
        setupView()
        setupAuthView()
        setupRepeatPasswordTextField()
    }
    
    private func setupView() {
        view.backgroundColor = Colors.white
        view.addSubview(authView)
    }
    
    private func setupAuthView() {
        authView.addTextField(repeatPasswordTextField)
        authView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupRepeatPasswordTextField() {
        repeatPasswordTextField.placeholder = Strings.repeatPasswordPlaceholder
        repeatPasswordTextField.isSecureTextEntry = true
        repeatPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(Dimensions.defaultHeight)
        }
    }
}
