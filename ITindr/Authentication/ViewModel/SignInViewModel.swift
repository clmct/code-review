//
//  SignInViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 21.11.2021.
//

import Foundation

class SignInViewModel: BaseViewModel {
    
    // MARK: Properties
    let authViewModel = AuthViewModel(header: Strings.authorization, actionText: Strings.signIn)
    
    var didSignIn: ((NetworkService?) -> Void)?
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
    
    func signIn(email: String?, password: String?) {
        if let error = validator.validateEmailAndPassword(email: email, password: password) {
            didRecieveError?(error)
            return
        }
        
        didStartRequest?()
        networkManager.signInRequest(
            email: email ?? "",
            password: password ?? "") { [weak self] in
                self?.setUserProfileInfo()
                self?.didSignIn?(self?.networkManager)
                self?.didFinishRequest?()
            } onFailure: { [weak self] error in
                self?.didRecieveError?(error)
            }
    }
    
    // MARK: Private Methods
    private func setUserProfileInfo() {
        networkManager.requestProfileInfo { user in
            UserDefaults.standard.set(user.userId, forKey: UserDefaultsKeys.userId)
            DatabaseService.shared.updateProfile(with: user)
        } onFailure: { error in
            print(error.localizedDescription)
        } onNotAuthorized: { }
    }
}

// MARK: AuthViewModelDelegate
extension SignInViewModel: AuthViewModelDelegate {
    func action(email: String?, password: String?) {
        signIn(email: email, password: password)
    }
    
    func back() {
        didTapBack?()
    }
}
