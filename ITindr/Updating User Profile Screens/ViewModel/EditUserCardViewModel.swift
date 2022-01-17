//
//  EditUserCardViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 25.11.2021.
//

import UIKit

protocol EditUserCardViewModelDelegate {
    func chooseAvatar()
    func removeAvatar()
}

class EditUserCardViewModel {
    
    //MARK: Public Properties
    let avatarViewModel = AvatarImageViewModel()
    
    var delegate: EditUserCardViewModelDelegate?
    
    var aboutHeader: String?
    var topicsHeader: String?
    var avatarButtonTitle: String?
    
    var name: String?
    var about: String?
    var topicTitles: [String] = []
    
    // MARK: Closures
    var didUpdateLabels: (() -> Void)?
    
    var didUpdateTopics: (() -> Void)?
    var didSetTopicSelected: ((String) -> Void)?
    var selectedTopicTitles: (() -> [String]?)?
    
    var didUpdateUserInfo: (() -> Void)?
    var didUpdateAvatarButton: (() -> Void)?
    
    // MARK: Private Properties
    private var topics: [Topic] = []
    
    // MARK: Init
    init(aboutHeader: String?, topicsHeader: String?) {
        self.aboutHeader = aboutHeader
        self.topicsHeader = topicsHeader
        avatarButtonTitle = Strings.choosePhoto
    }
    
    // MARK: Public Methods
    func start() {
        didUpdateLabels?()
        didUpdateTopics?()
    }
    
    // MARK: Public Topics Methods
    func updateTopics(_ topics: [Topic]) {
        self.topics = topics
        topicTitles = topics.map { $0.title }
        didUpdateTopics?()
    }
    
    func setupSelectedTopics(_ selectedTopics: [Topic]?) {
        selectedTopics?.forEach { topic in
            if let topic = topics.first(where: { $0.title == topic.title }) {
                didSetTopicSelected?(topic.title)
            }
        }
    }
    
    func getSelectedTopicsId() -> [String] {
        guard let titles = selectedTopicTitles?() else {
            return []
        }
        
        return Array(Set(topics.filter { titles.contains($0.title) }.map { $0.id }))
    }
    
    // MARK: Public User Info Methods
    func updateUserInfo(with user: User?) {
        updateAvatar(withUrl: user?.avatar)
        name = user?.name
        about = user?.aboutMyself
        didUpdateUserInfo?()
    }
    
    // MARK: Public Avatar Methods
    func updateAvatar(with image: UIImage?) {
        avatarViewModel.updateAvatar(with: image)
        avatarButtonTitle = image == nil ? Strings.choosePhoto : Strings.deletePhoto
        didUpdateAvatarButton?()
    }
    
    func updateAvatar(withUrl url: String?) {
        avatarViewModel.updateAvatar(withUrl: url) { [weak self] image in
            self?.avatarButtonTitle = image == nil ? Strings.choosePhoto : Strings.deletePhoto
            self?.didUpdateAvatarButton?()
        }
    }
    
    func didAvatarButtonTap() {
        if avatarViewModel.avatar != nil {
            delegate?.removeAvatar()
        } else {
            delegate?.chooseAvatar()
        }
    }
}
