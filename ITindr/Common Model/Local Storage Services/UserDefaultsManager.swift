//
//  UserDefaultsUtils.swift
//  ITindr
//
//  Created by Эдуард Логинов on 24.10.2021.
//

import Foundation

enum UserDefaultsKeys {
    static let accessTokenKey = "accessToken"
    static let refreshTokenKey = "refreshToken"
    static let userId = "userId"
}

class UserDefaultsManager {
    
    // MARK: Tokens
    func readTokens() -> (accessToken: String?, refreshToken: String?) {
        return (readAccessToken(), readRefreshToken())
    }
    
    func readAccessToken() -> String? {
        return read(forKey: UserDefaultsKeys.accessTokenKey)
    }
    
    func readRefreshToken() -> String? {
        return read(forKey: UserDefaultsKeys.refreshTokenKey)
    }
    
    func writeTokens(accessToken: String, refreshToken: String) {
        write(accessToken, forKey: UserDefaultsKeys.accessTokenKey)
        write(refreshToken, forKey: UserDefaultsKeys.refreshTokenKey)
    }
    
    func tokensExists() -> Bool {
        let tokens = readTokens()
        return tokens.accessToken != nil
            && tokens.refreshToken != nil
    }
    
    // MARK: User Id
    func readUserId() -> String? {
        return read(forKey: UserDefaultsKeys.userId)
    }
    
    // MARK: Common Methods
    func read(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    func write(_ value: String, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func checkValue(forKey key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
