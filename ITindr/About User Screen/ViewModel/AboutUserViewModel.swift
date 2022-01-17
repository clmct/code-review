//
//  AboutUserViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 30.11.2021.
//

import UIKit
import Kingfisher

class AboutUserViewModel {
    
    // MARK: Properties
    var avatar: UIImage?
    var name: String?
    var about: String?
    var topicTitles: [String]?
    
    var didUpdateUser: (() -> Void)?
    
    private let user: User
    
    // MARK: Init
    init(with user: User) {
        self.user = user
    }
    
    // MARK: Public Methods
    func start() {
        name = user.name
        about = user.aboutMyself
        topicTitles = user.topics?.map { $0.title }
        
        guard let url = URL(string: user.avatar ?? "") else {
            avatar = UIImage(named: ImageNames.personPlaceholder)
            didUpdateUser?()
            return
        }
        
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            let image  = try? result.get().image
            self?.avatar = image
            self?.didUpdateUser?()
        }
    }
}
