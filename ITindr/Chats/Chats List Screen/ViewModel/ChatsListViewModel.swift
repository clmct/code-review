//
//  ChatsListViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 28.11.2021.
//

import Foundation

class ChatsListViewModel: BaseViewModel {
    
    // MARK: Properties
    var chatsCount: Int {
        get {
            return chatCellViewModels.count
        }
    }
    
    var didRecieveChatsList: (() -> Void)?
    var didTapChatCell: ((NetworkService, Chat) -> Void)?
    
    private let networkManager: NetworkService
    
    private var chatCellViewModels: [ChatsListCellViewModel] = []
    
    // MARK: Init
    init(networkManager: NetworkService) {
        self.networkManager = networkManager
    }
    
    // MARK: Public Methods
    func chatCellTap(index: Int) {
        didTapChatCell?(networkManager, chatCellViewModels[index].chatInfo)
    }
    
    func getChatsCount() -> Int {
        return chatCellViewModels.count
    }
    
    func getChatCellViewModel(at index: Int) -> ChatsListCellViewModel {
        return chatCellViewModels[index]
    }
    
    func getChats() {
        let localChatsList = DatabaseService.shared.getChatsList()
        chatCellViewModels = localChatsList.map { ChatsListCellViewModel(chat: $0) }
        didRecieveChatsList?()
        
        networkManager.requestChatsList
        { [weak self] chatsList in
            self?.addLoadedChats(chatsList)
            self?.didRecieveChatsList?()
        } onFailure: { [weak self] error in
            self?.didRecieveError?(error)
        } onNotAuthorized: { [weak self] in
            self?.didNotAuthorize?(self?.networkManager)
        }
    }
    
    // MARK: Private Methods
    private func addLoadedChats(_ chatsList: [ChatListItem]) {
        let orderedChats = DatabaseService.shared.updateChatsList(withContest: chatsList)
        chatCellViewModels = orderedChats.map { ChatsListCellViewModel(chat: $0) }
    }
}
