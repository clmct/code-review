//
//  ProfileError.swift
//  ITindr
//
//  Created by Эдуард Логинов on 23.11.2021.
//

import Foundation

enum ProfileError {
    case retrievingProfileFailed
    case updatingProfileFailed
    case uploadingAvatarFailed
    case deletingAvatarFailed
    case unexpected(code: Int?)
}

// MARK: BaseError
extension ProfileError: BaseError {
    init(code: Int?) {
        self = .unexpected(code: code)
    }
}

// MARK: LocalizedError
extension ProfileError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .retrievingProfileFailed:
            return NSLocalizedString(
                "Не удалось загрузить профиль",
                comment: "Failed to retrieve profile info")
        case .updatingProfileFailed:
            return NSLocalizedString(
                "Не удалось обновить профиль",
                comment: "Failed to update profile info")
        case .uploadingAvatarFailed:
            return NSLocalizedString(
                "Не удалось загрузить фото",
                comment: "Failed to upload avatar")
        case .deletingAvatarFailed:
            return NSLocalizedString(
                "Не удалось удалить фото",
                comment: "Avatar not found")
        case .unexpected(_):
            return NSLocalizedString(
                "Что-то пошло не так",
                comment: "Unexpected error")
        }
    }
}
