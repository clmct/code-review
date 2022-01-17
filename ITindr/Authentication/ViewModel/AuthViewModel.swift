//
//  AuthViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 21.11.2021.
//

import Foundation

protocol AuthViewModelDelegate {
    func action(email: String?, password: String?)
    func back()
}

class AuthViewModel {
    
    // MARK: Properties
    var delegate: AuthViewModelDelegate?
    
    var headerText: String?
    var actionButtonText: String?
    var backButtonText: String?
    
    var didUpdateLabels: (() -> Void)?
    
    // MARK: Init
    init(header: String?, actionText: String?, backText: String? = Strings.back) {
        headerText = header
        actionButtonText = actionText
        backButtonText = backText
    }
    
    // MARK: Public Methods
    func start() {
        didUpdateLabels?()
    }
    
    func actionTapped(email: String?, password: String?) {
        delegate?.action(email: email, password: password)
    }
    
    func backTapped() {
        delegate?.back()
    }
}

extension AuthViewModel {
    func validateEmailAndPassword(email: String?, password: String?) -> Bool {
        return validateEmail(email ?? "") &&
               validatePassword(password ?? "")
    }
    
    private func validatePassword(_ password: String) -> Bool {
        return password.trimmingCharacters(in: .whitespacesAndNewlines).count >= 8
    }
    
    private func validateEmail(_ email: String) -> Bool {
        let range = NSRange(location: 0, length: email.count)
        let emailPattern = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let regex = try? NSRegularExpression(pattern: emailPattern)
        
        return regex?.firstMatch(in: email, options: [], range: range) != nil
    }
}
