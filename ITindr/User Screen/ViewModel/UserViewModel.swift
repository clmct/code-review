//
//  UserViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 01.12.2021.
//

import Foundation

class UserViewModel: BaseViewModel {
    
    // MARK: Properties
    let userCardViewModel = UserCardViewModel()
    
    var didMatch: ((String, NetworkService) -> Void)?
    var didTapUserCard: ((User) -> Void)?
    
    private let networkManager: NetworkService
    private let user: User
    
    // MARK: Init
    init(networkManager: NetworkService, user: User) {
        self.networkManager = networkManager
        self.user = user
    }
    
    // MARK: Public Methods
    func start() {
        userCardViewModel.delegate = self
        userCardViewModel.updateUserInfo(with: user)
    }
    
    // MARK: Public Like/Dislike Methods
    func dislikeUser() {
        didStartRequest?()
        networkManager.requestDislikeUser(userId: user.userId)
        { [weak self] in
            self?.didFinishRequest?()
        } onFailure: { [weak self] error in
            self?.didRecieveError?(error)
        } onNotAuthorized: { [weak self] in
            self?.didNotAuthorize?(self?.networkManager)
        } onUserAlreadyRected: { [weak self] in
            self?.didRecieveError?(UserReactionError.userAlreadyReacted)
        }
    }
    
    func likeUser() {
        didStartRequest?()
        networkManager.requestLikeUser(userId: user.userId)
        { [weak self] likeResponse in
            self?.likeAction(likeResponse.isMutual)
        } onFailure: { [weak self] error in
            self?.didRecieveError?(error)
        } onNotAuthorized: { [weak self] in
            self?.didNotAuthorize?(self?.networkManager)
        } onUserAlreadyRected: { [weak self] in
            self?.didRecieveError?(UserReactionError.userAlreadyReacted)
        }
    }
    
    // MARK: Private Like Methods
    private func likeAction(_ isMutual: Bool) {
        if isMutual {
            didMatch?(user.userId, networkManager)
        }
    }
}

// MARK: UserCardViewModelDelegate
extension UserViewModel: UserCardViewModelDelegate {
    func onCardTap(user: User) {
        didTapUserCard?(user)
    }
}
