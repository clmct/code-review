//
//  PeopleFlowViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 28.11.2021.
//

import Foundation

class PeopleFlowViewModel: BaseViewModel {
    
    // MARK: Properties
    let userCardViewModel: UserCardViewModel
    
    var didHidePlaceholder: ((Bool) -> Void)?
    var didMatch: ((String, NetworkService) -> Void)?
    var didTapUserCard: ((User) -> Void)?
    
    private let networkManager: NetworkService
    
    private var currentUser: User?
    private var usersFeed: [User] = []
    
    // MARK: Init
    init(networkManager: NetworkService) {
        self.networkManager = networkManager
        userCardViewModel = UserCardViewModel()
    }
    
    // MARK: Public Methods
    func start() {
        userCardViewModel.delegate = self
        if usersFeed.isEmpty {
            getUsersFeed()
        }
    }
    
    // MARK: Public Like/Dislike Methods
    func dislikeUser() {
        didStartRequest?()
        networkManager.requestDislikeUser(userId: currentUser?.userId ?? "")
        { [weak self] in
            self?.showNextUser()
            self?.didFinishRequest?()
        } onFailure: { [weak self] error in
            self?.didRecieveError?(error)
        } onNotAuthorized: { [weak self] in
            self?.didNotAuthorize?(self?.networkManager)
        } onUserAlreadyRected: { [weak self] in
            self?.showNextUser()
            self?.didFinishRequest?()
        }
    }
    
    func likeUser() {
        didStartRequest?()
        networkManager.requestLikeUser(userId: currentUser?.userId ?? "")
        { [weak self] likeResponse in
            self?.likeAction(likeResponse.isMutual)
            self?.didFinishRequest?()
        } onFailure: { [weak self] error in
            self?.didRecieveError?(error)
        } onNotAuthorized: { [weak self] in
            self?.didNotAuthorize?(self?.networkManager)
        } onUserAlreadyRected: { [weak self] in
            self?.showNextUser()
            self?.didFinishRequest?()
        }
    }
    
    // MARK: Private Like Methods
    private func likeAction(_ isMutual: Bool) {
        if isMutual {
            didMatch?(currentUser?.userId ?? "", networkManager)
        }
        showNextUser()
    }
    
    // MARK: Private User Feed Methods
    private func getUsersFeed() {
        didStartRequest?()
        networkManager.requestUserFeed { [weak self] users in
            self?.usersFeed = users
            self?.showNextUser()
            self?.didFinishRequest?()
        } onFailure: { [weak self] error in
            self?.didRecieveError?(error)
        } onNotAuthorized: { [weak self] in
            self?.didNotAuthorize?(self?.networkManager)
        }
    }
    
    private func showNextUser() {
        if let nextUser = usersFeed.popLast() {
            changeUser(withUser: nextUser)
            didHidePlaceholder?(true)
        } else {
            didHidePlaceholder?(false)
        }
    }

    private func changeUser(withUser user: User) {
        currentUser = user
        userCardViewModel.updateUserInfo(with: user)
    }
}

// MARK: UserCardViewModelDelegate
extension PeopleFlowViewModel: UserCardViewModelDelegate {
    func onCardTap(user: User) {
        didTapUserCard?(user)
    }
}
