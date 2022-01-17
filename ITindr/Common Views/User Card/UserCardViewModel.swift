//
//  UserCardViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 27.11.2021.
//

import UIKit

protocol UserCardViewModelDelegate {
    func onCardTap(user: User)
}

class UserCardViewModel {
    
    // MARK: Properties
    let avatarViewModel = AvatarImageViewModel()
    
    var delegate: UserCardViewModelDelegate?
    var name: String?
    var about: String?
    var topicTitles: [String] = []
    
    var didUpdateUserInfo: (() -> Void)?
    
    private var user: User?
    
    // MARK: Public Methods
    func updateUserInfo(with user: User?) {
        self.user = user
        avatarViewModel.updateAvatar(withUrl: user?.avatar)
        name = user?.name
        about = user?.aboutMyself
        topicTitles = user?.topics?.map({ $0.title }) ?? []
        didUpdateUserInfo?()
    }
    
    func userCardTap() {
        guard let user = user else { return }
        delegate?.onCardTap(user: user)
    }
}
