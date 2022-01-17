//
//  UserReactionError.swift
//  ITindr
//
//  Created by Эдуард Логинов on 23.11.2021.
//

import Foundation

enum UserReactionError {
    case userReactionFailed
    case userAlreadyReacted
    case unexpected(code: Int?)
}

// MARK: BaseError
extension UserReactionError: BaseError {
    init(code: Int?) {
        self = .unexpected(code: code)
    }
}

// MARK: LocalizedError
extension UserReactionError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userReactionFailed:
            return NSLocalizedString(
                "Не удалось оценить пользователя",
                comment: "Reaction failed")
        case .userAlreadyReacted:
            return NSLocalizedString(
                "Пользователь уже оценен",
                comment: "Resource already exists")
        case .unexpected(_):
            return NSLocalizedString(
                "Что-то пошло не так",
                comment: "Unexpected error")
        }
    }
}
