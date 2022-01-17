//
//  ChatsListCellViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 28.11.2021.
//

import Foundation

class ChatsListCellViewModel {
    
    // MARK: Properties
    let avatarViewModel = AvatarImageViewModel()
    let chatInfo: Chat
    
    var title: String?
    var lastMessageText: String?
    
    var didUpdateChatInfo: (() -> Void)?
    var didUpdateAvatar: (() -> Void)?
    
    private let chat: ChatListItem
    
    // MARK: Init
    init(chat: ChatListItem) {
        self.chat = chat
        chatInfo = chat.chat
    }
    
    // MARK: Public Methods
    func start() {
        avatarViewModel.updateAvatar(withUrl: chat.chat.avatar)
        title = chat.chat.title
        setLastMessageText(lastMessage: chat.lastMessage)
        didUpdateChatInfo?()
    }
    
    // MARK: Private Helper Methods
    private func setLastMessageText(lastMessage: Message?) {
        guard let lastMessage = lastMessage else {
            lastMessageText = ""
            return
        }
        var result = ""
        
        if let attachments = lastMessage.attachments, !attachments.isEmpty {
            result += "\(attachments.count) attachment" + (attachments.count > 1 ? "s\n" : "\n")
        }
        if let text = lastMessage.text {
            result += text
        }
        
        lastMessageText = result
    }
}
