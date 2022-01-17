//
//  URL.swift
//  ITindr
//
//  Created by Эдуард Логинов on 24.10.2021.
//

import Foundation

enum urlStrings {
    // MARK: Base
    static let base = "http://193.38.50.175/itindr/api/mobile"
    
    // MARK: Authentication
    static let login = "/v1/auth/login"
    static let register = "/v1/auth/register"
    static let logout = "/v1/auth/logout"
    static let refresh = "/v1/auth/refresh"
    
    // MARK: Profile
    static let profile = "/v1/profile"
    static let avatar = "/v1/profile/avatar"
    
    // MARK: Topic
    static let topic = "/v1/topic"
    
    // MARK: User
    static let user = "/v1/user"
    static let feed = "/v1/user/feed"
    static let like = "/like"
    static let dislike = "/dislike"
    
    // MARK: Chat
    static let chat = "/v1/chat"
    static let message = "/message"
}
