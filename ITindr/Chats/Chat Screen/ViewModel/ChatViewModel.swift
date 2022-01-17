//
//  ChatViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 30.11.2021.
//

import UIKit
import Kingfisher

class ChatViewModel: BaseViewModel {
    
    // MARK: Public Properties
    let messageSendViewModel = MessageSendViewModel()
    
    var chatTitle: String?
    var chatAvatar: UIImage?
    var isPaging: Bool = false
    var messagesCount: Int {
        get {
            return messageViewModels.count
        }
    }
    
    // MARK: Closures
    var didSetChatTitle: (() -> Void)?
    var didTapAttach: (() -> Void)?
    var didRecieveMessages: (() -> Void)?
    var didSendMessage: (() -> Void)?
    
    // MARK: Private Properties
    private let networkManager: NetworkService
    private let chat: Chat
    private let senderId = UserDefaults.standard.string(forKey: UserDefaultsKeys.userId)
    
    private var messageViewModels: [MessageCellViewModel] = []
    private var currentOffset: Int = 0
    
    // MARK: Init
    init(networkManager: NetworkService, chat: Chat) {
        self.networkManager = networkManager
        self.chat = chat
    }
    
    // MARK: Public Methods
    func start() {
        messageSendViewModel.delegate = self
        setupChatTitle()
        getMessages()
    }
    
    func addAttachment(_ attachment: UIImage) {
        messageSendViewModel.updateAttachment(attachment)
    }
    
    func getOlderMessagesIfExists(scrollOffset: CGFloat) {
        if scrollOffset < 0 && !isPaging {
            loadOldMessages()
        }
    }
    
    func getMessageReuseIdentifierIfPossible(index: Int) -> String? {
        guard let senderId = senderId else {
            return nil
        }
        
        return senderId == messageViewModels[index].userId
        ? ReuseIdentifiers.userMessageCell
        : ReuseIdentifiers.mateMessageCell
    }
    
    func getMessageViewModel(index: Int) -> MessageCellViewModel {
        return messageViewModels[index]
    }
    
    func loadOldMessages() {
        isPaging = true
        networkManager.requestChatMessages(
            chatId: chat.id,
            limit: 20,
            offset: currentOffset)
        { [weak self] messages in
            let orderedMessages = DatabaseService.shared.updateMessages(
                withContest: messages, forChat: self?.chat.id ?? "")
            self?.addLoadedMessages(orderedMessages)
            self?.isPaging = false
        } onFailure: { [weak self] error in
            self?.didRecieveError?(error)
            self?.isPaging = false
        } onNotAuthorized: { [weak self] in
            self?.didNotAuthorize?(self?.networkManager)
        }
    }
    
    // MARK: Private Setup Methods
    private func setupChatTitle() {
        chatTitle = chat.title
        guard let url = URL(string: chat.avatar ?? "") else {
            didSetChatTitle?()
            return
        }
        
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] response in
            self?.chatAvatar = try? response.get().image
            self?.didSetChatTitle?()
        }
    }
    
    // MARK: Private Messages Load Methods
    private func getMessages() {
        let localMessages = DatabaseService.shared.getMessages(forChat: chat.id)
        updateLoadedMessages(localMessages)
        didSendMessage?()
        
        guard currentOffset != 0 else {
            loadOldMessages()
            return
        }
        
        isPaging = true
        networkManager.requestChatMessages(
            chatId: chat.id,
            limit: currentOffset,
            offset: 0)
        { [weak self] messages in
            let orderedMessages = DatabaseService.shared.updateMessages(
                withContest: messages, forChat: self?.chat.id ?? "")
            self?.updateLoadedMessages(orderedMessages)
            self?.isPaging = false
            self?.loadOldMessagesIfNeeded()
        } onFailure: { [weak self] error in
            self?.didRecieveError?(error)
            self?.isPaging = false
        } onNotAuthorized: { [weak self] in
            self?.didNotAuthorize?(self?.networkManager)
        }
    }
    
    private func loadOldMessagesIfNeeded() {
        if currentOffset < 20 {
            loadOldMessages()
        }
    }
    
    private func updateLoadedMessages(_ newMessages: [Message]) {
        messageViewModels = newMessages.reversed().map { MessageCellViewModel(with: $0) }
        if !newMessages.isEmpty {
            setupMessageViewModels(inRange: (0..<newMessages.count))
        }
        currentOffset = newMessages.count
        didRecieveMessages?()
    }
    
    private func addLoadedMessages(_ newMessages: [Message]) {
        messageViewModels.insert(
            contentsOf: newMessages.reversed().map { MessageCellViewModel(with: $0) },
            at: 0)
        if !newMessages.isEmpty {
            setupMessageViewModels(inRange: (0..<newMessages.count))
        }
        currentOffset += newMessages.count
        didRecieveMessages?()
    }
    
    private func setupMessageViewModels(inRange range: Range<Int>) {
        for index in range {
            messageViewModels[index].shouldIncreaseBottomOffset(IsMessageFromDifferentUser(index: index))
        }
    }
    
    private func IsMessageFromDifferentUser(index: Int) -> Bool {
        guard (0..<messagesCount).contains(index) && (0..<messagesCount).contains(index + 1) else {
            return false
        }
        return messageViewModels[index].userId != messageViewModels[index + 1].userId
    }
    
    // MARK: Private Message Send Methods
    private func sendMessage(text: String?, attachment: UIImage?) {
        guard isSentMessageValid(text: text, attachment: attachment) else { return }
        
        networkManager.requestSendMessage(
            chatId: chat.id,
            messageText: text,
            attachment: attachment)
        { [weak self] message in
            self?.addMessage(message)
            self?.didRecieveMessages?()
            self?.didSendMessage?()
        } onFailure: { [weak self] error in
            self?.didRecieveError?(error)
        } onNotAuthorized: { [weak self] in
            self?.didNotAuthorize?(self?.networkManager)
        }
        
        clearUserInput()
    }
    
    private func isSentMessageValid(text: String?, attachment: UIImage?) -> Bool {
        return text != nil || attachment != nil
    }
    
    private func addMessage(_ message: Message) {
        currentOffset += 1
        messageViewModels.append(MessageCellViewModel(with: message))
    }
    
    private func clearUserInput() {
        messageSendViewModel.updateText(with: nil)
        messageSendViewModel.updateAttachment(nil)
    }
}

// MARK: MessageSendViewModelDelegate
extension ChatViewModel: MessageSendViewModelDelegate {
    func send(text: String?, attachment: UIImage?) {
        sendMessage(text: text, attachment: attachment)
    }
    
    func attach() {
        didTapAttach?()
    }
}
