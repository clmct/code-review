//
//  UserError.swift
//  ITindr
//
//  Created by Эдуард Логинов on 23.11.2021.
//

import Foundation

enum UserError {
    case gettingUsersFailed
    case gettingUserFeedFailed
    case unexpected(code: Int?)
}

// MARK: BaseError
extension UserError: BaseError {
    init(code: Int?) {
        self = .unexpected(code: code)
    }
}

// MARK: LocalizedError
extension UserError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .gettingUsersFailed:
            return NSLocalizedString(
                "Не удалось получить список пользователей",
                comment: "Failed to get users list")
        case .gettingUserFeedFailed:
            return NSLocalizedString(
                "Не удалось загрузить ленту",
                comment: "Failed to get user feed")
        case .unexpected(_):
            return NSLocalizedString(
                "Что-то пошло не так",
                comment: "Unexpected error")
        }
    }
}
