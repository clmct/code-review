//
//  PeopleCellViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 30.11.2021.
//

import Foundation

class PeopleCellViewModel {
    
    // MARK: Properties
    let avatarViewModel = AvatarImageViewModel()
    let user: User
    
    var name: String?
    
    var didUpdateUser: (() -> Void)?
    
    // MARK: Init
    init(with user: User) {
        self.user = user
    }
    
    // MARK: Public Methods
    func start() {
        name = user.name
        avatarViewModel.updateAvatar(withUrl: user.avatar)
        didUpdateUser?()
    }
}
