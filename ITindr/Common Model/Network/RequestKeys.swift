//
//  RequestKeys.swift
//  ITindr
//
//  Created by Эдуард Логинов on 23.11.2021.
//

import Foundation

enum RequestKeys {
    // MARK: Auth/Tokens
    static let authorization = "Authorization"
    static let accessToken = "accessToken"
    static let refreshToken = "refreshToken"
    
    // MARK: Email/Password
    static let email = "email"
    static let password = "password"
    
    // MARK: User
    static let userId = "userId"
    static let avatar = "avatar"
    static let name = "name"
    static let about = "aboutMyself"
    static let topics = "topics"
    
    // MARK: Chat
    static let chatId = "chatId"
    static let attachment = "attachment"
    static let messageText = "messageText"
}
