//
//  MessageModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 29.10.2021.
//

import Foundation


struct Message: Codable {
    let id: String
    let text: String?
    let createdAt: String
    let attachments: [String]?
    let user: User
}
