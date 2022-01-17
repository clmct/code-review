//
//  MatchViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 28.11.2021.
//

import Foundation

class MatchViewModel: BaseViewModel {
    
    // MARK: Properties
    var didCreateChat: ((Chat, NetworkService?) -> Void)?
    
    private let networkManager: NetworkService
    private let userId: String
    
    // MARK: Init
    init(networkManager: NetworkService, userId: String) {
        self.networkManager = networkManager
        self.userId = userId
    }
    
    // MARK: Public Methods
    func startChat() {
        didStartRequest?()
        networkManager.requestCreateChat(userId: userId)
        { [weak self] newChat in
            self?.didCreateChat?(newChat, self?.networkManager)
            self?.didFinishRequest?()
        } onFailure: { [weak self] error in
            self?.didRecieveError?(error)
        } onNotAuthorized: { [weak self] in
            self?.didNotAuthorize?(self?.networkManager)
        }
    }
}
