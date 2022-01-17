//
//  ChatError.swift
//  ITindr
//
//  Created by Эдуард Логинов on 23.11.2021.
//

import Foundation

enum ChatError {
    case gettingChatsFailed
    case creatingChatFailed
    case gettingMessagesFailed
    case sendingMessageFailed
    case unexpected(code: Int?)
}

// MARK: BaseError
extension ChatError: BaseError {
    init(code: Int?) {
        self = .unexpected(code: code)
    }
}

// MARK: LocalizedError
extension ChatError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .gettingChatsFailed:
            return NSLocalizedString(
                "Не удалось загрузить список чатов",
                comment: "Failed to get chats list")
        case .creatingChatFailed:
            return NSLocalizedString(
                "Не удалось создать чат",
                comment: "Failed to create chat")
        case .gettingMessagesFailed:
            return NSLocalizedString(
                "Не удалось загрузить сообщения",
                comment: "Failed to get messages")
        case .sendingMessageFailed:
            return NSLocalizedString(
                "Не удалось отправить сообщение",
                comment: "Failed to send message")
        case .unexpected(_):
            return NSLocalizedString(
                "Что-то пошло не так",
                comment: "Unexpected error")
        }
    }
}
