//
//  AuthValidator.swift
//  ITindr
//
//  Created by Эдуард Логинов on 04.12.2021.
//

import Foundation

class AuthValidator {
    func validateSignUpForm(email: String?,
                            password: String?,
                            repeatPassword: String?) -> Error? {
        if let error = validateEmailAndPassword(email: email, password: password) {
            return error
        }
        
        guard password == repeatPassword else {
            return AuthError.signUpNotEqualPasswords
        }
        
        return nil
    }
    
    func validateEmailAndPassword(email: String?, password: String?) -> Error? {
        guard isValidEmail(email ?? "") && isValidPassword(password ?? "") else {
            return AuthError.invalidEmailOrPassword
        }
        return nil
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        return password.trimmingCharacters(in: .whitespacesAndNewlines).count >= 8
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let range = NSRange(location: 0, length: email.count)
        let emailPattern = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let regex = try? NSRegularExpression(pattern: emailPattern)
        
        return regex?.firstMatch(in: email, options: [], range: range) != nil
    }
}
