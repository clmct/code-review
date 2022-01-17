//
//  TopicsError.swift
//  ITindr
//
//  Created by Эдуард Логинов on 23.11.2021.
//

import Foundation

enum TopicsError {
    case gettingTopicsFailed
    case unexpected(code: Int?)
}

// MARK: BaseError
extension TopicsError: BaseError {
    init(code: Int?) {
        self = .unexpected(code: code)
    }
}

// MARK: LocalizedError
extension TopicsError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .gettingTopicsFailed:
            return NSLocalizedString(
                "Не удалось получить список интересов",
                comment: "Failed to get topics list")
        case .unexpected(_):
            return NSLocalizedString(
                "Что-то пошло не так",
                comment: "Unexpected error")
        }
    }
}
