//
//  SignUpViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 21.11.2021.
//

import Foundation

class SignUpViewModel: BaseViewModel {
    
    // MARK: Properties
    let authViewModel = AuthViewModel(header: Strings.register, actionText: Strings.signUp)
    
    var didSignUp: ((NetworkService?) -> Void)?
    var didTapSignUp: ((String?, String?) -> Void)?
    var didTapBack: (() -> Void)?
    
    private let validator = AuthValidator()
    private let networkManager: NetworkService
    
    // MARK: Init
    init(networkManager: NetworkService) {
        self.networkManager = networkManager
    }
    
    // MARK: Public Methods
    func start() {
        authViewModel.delegate = self
        authViewModel.start()
    }
    
    func signUp(email: String?, password: String?, repeatPassword: String?) {
        if let error = validator.validateSignUpForm(
            email: email,
            password: password,
            repeatPassword: repeatPassword) {
            didRecieveError?(error)
            return
        }
        
        didStartRequest?()
        networkManager.signUpRequest(
            email: email ?? "",
            password: password ?? "") { [weak self] in
                self?.didSignUp?(self?.networkManager)
                self?.didFinishRequest?()
            }
            onFailure: { [weak self] error in
                self?.didRecieveError?(error)
            }
    }
}

// MARK: AuthViewModelDelegate
extension SignUpViewModel: AuthViewModelDelegate {
    func action(email: String?, password: String?) {
        didTapSignUp?(email, password)
    }
    
    func back() {
        didTapBack?()
    }
}
