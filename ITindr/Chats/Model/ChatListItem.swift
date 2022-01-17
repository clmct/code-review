//
//  ChatListResponse.swift
//  ITindr
//
//  Created by Эдуард Логинов on 29.10.2021.
//

import Foundation


struct ChatListItem: Codable {
    let chat: Chat
    let lastMessage: Message?
}
