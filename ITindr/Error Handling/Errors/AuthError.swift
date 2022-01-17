//
//  AuthError.swift
//  ITindr
//
//  Created by Эдуард Логинов on 23.11.2021.
//

import Foundation

enum AuthError {
    case invalidEmailOrPassword
    case signUpNotEqualPasswords
    case signUpUserExists
    case signInUserNotFound
    case unexpected(_ code: Int?)
}

// MARK: BaseError
extension AuthError: BaseError {
    init(code: Int?) {
        switch code {
        case 1003:
            self = .invalidEmailOrPassword
        case 1004:
            self = .signUpNotEqualPasswords
        case 409:
            self = .signUpUserExists
        case 404:
            self = .signInUserNotFound
        default:
            self = .unexpected(code)
        }
    }
}

// MARK: LocalizedError
extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidEmailOrPassword:
            return NSLocalizedString(
                "Неверный email или пароль",
                comment: "Invalid email")
        case .signUpNotEqualPasswords:
            return NSLocalizedString(
                "Пароли не совпадают",
                comment: "Passwords are not equal")
        case .signUpUserExists:
            return NSLocalizedString(
                "Пользователь с таким email уже существует",
                comment: "Resource already exists")
        case .signInUserNotFound:
            return NSLocalizedString(
                "Пользователя с таким email и паролем не существует",
                comment: "Resource not found")
        case .unexpected(_):
            return NSLocalizedString(
                "Что-то пошло не так",
                comment: "Unexpected error")
        }
    }
}
