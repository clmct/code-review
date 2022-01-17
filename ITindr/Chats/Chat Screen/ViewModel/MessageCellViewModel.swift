//
//  MessageCellViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 30.11.2021.
//

import UIKit

class MessageCellViewModel {
    
    // MARK: Properties
    let avatarViewModel = AvatarImageViewModel()
    let userId: String
    
    var bottomOffset: CGFloat = -8
    var messageText: String?
    var datetime: String?
    var attachment: URL?
    
    var didUpdateMessage: (() -> Void)?
    
    private let message: Message
    
    // MARK: Init
    init(with message: Message) {
        self.message = message
        userId = message.user.userId
    }
    
    // MARK: Public Methods
    func start() {
        messageText = message.text
        datetime = getFormattedDate(from: message.createdAt)
        avatarViewModel.updateAvatar(withUrl: message.user.avatar)
        setMessageAttachment(urls: message.attachments)
        didUpdateMessage?()
    }
    
    func shouldIncreaseBottomOffset(_ shouldIncrease: Bool) {
        if shouldIncrease {
            bottomOffset = -24
        }
    }
    
    // MARK: Private Methods
    private func setMessageAttachment(urls: [String]?) {
        guard let urls = urls, !urls.isEmpty, let url = URL(string: urls[0]) else { return }
        attachment = url
    }
    
    private func getFormattedDate(from stringDate: String) -> String? {
        let date = Date.from(string: stringDate)
        return date?.toMessageFormat()
    }
}
