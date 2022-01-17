//
//  TokenResponse.swift
//  ITindr
//
//  Created by Эдуард Логинов on 24.10.2021.
//

import Foundation

struct TokenResponse: Codable {
    let accessToken: String
    let accessTokenExpiredAt: String
    let refreshToken: String
    let refreshTokenExpiredAt: String
}
