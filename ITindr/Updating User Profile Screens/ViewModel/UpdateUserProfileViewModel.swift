//
//  UpdateUserProfileViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 25.11.2021.
//

import Foundation
import Kingfisher

class UpdateUserProfileViewModel: BaseViewModel {
    
    // MARK: Properties
    let editUserCardViewModel: EditUserCardViewModel
    
    var didCompleteUpdating: ((NetworkService?) -> Void)?
    var didTapChooseAvatar: (() -> Void)?
    
    private let networkManager: NetworkService
    private let userData: User?
    
    private var isAvatarSet: Bool?
    private var avatar: UIImage?
    
    // MARK: Init
    init(networkManager: NetworkService, user: User?, aboutHeader: String?, topicsHeader: String?) {
        self.networkManager = networkManager
        userData = user
        editUserCardViewModel = EditUserCardViewModel(aboutHeader: aboutHeader, topicsHeader: topicsHeader)
    }
    
    // MARK: Public Methods
    func start() {
        editUserCardViewModel.delegate = self
        editUserCardViewModel.start()
        editUserCardViewModel.updateUserInfo(with: userData)
        addAllTopics()
    }
    
    func addAllTopics() {
        let topics = DatabaseService.shared.getTopics()
        editUserCardViewModel.updateTopics(topics)
        editUserCardViewModel.setupSelectedTopics(userData?.topics)
        
        networkManager.requestAllTopics { [weak self] topicsResponse in
            DatabaseService.shared.updateTopics(with: topicsResponse)
            self?.editUserCardViewModel.updateTopics(topicsResponse)
            self?.editUserCardViewModel.setupSelectedTopics(self?.userData?.topics)
        } onFailure: { [weak self] error in
            self?.didRecieveError?(error)
        } onNotAuthorized: { [weak self] in
            self?.didNotAuthorize?(self?.networkManager)
        }
    }
    
    func setAvatar(_ image: UIImage) {
        avatar = image
        isAvatarSet = true
        editUserCardViewModel.updateAvatar(with: image)
    }
    
    func removeUserAvatar() {
        avatar = nil
        isAvatarSet = false
        removeAvatarAndKfCache()
    }
    
    func saveUpdatedUser() {
        guard validateName() else {
            didRecieveError?(ProfileError.updatingProfileFailed)
            return
        }
        
        didStartRequest?()
        guard let isAvatarSet = isAvatarSet else {
            saveUserInfo()
            return
        }
        
        if let avatar = avatar, isAvatarSet {
            saveUserWithAvatar(avatar)
        } else {
            saveUserWithNoAvatar()
        }
    }
    
    // MARK: Private Saving User Methods
    private func saveUserWithNoAvatar() {
        networkManager.removeAvatar { [weak self] in
            self?.saveUserInfo()
        } onFailure: { [weak self] error in
            self?.didRecieveError?(error)
            self?.saveUserInfo()
        } onNotAuthorized: { [weak self] in
            self?.didNotAuthorize?(self?.networkManager)
        }
    }
    
    private func saveUserWithAvatar(_ userAvatar: UIImage) {
        networkManager.updloadAvatar(userAvatar)
        { [weak self] in
            self?.saveUserInfo()
        } onFailure: { [weak self] error in
            self?.didRecieveError?(error)
            self?.saveUserInfo()
        } onNotAuthorized: { [weak self] in
            self?.didNotAuthorize?(self?.networkManager)
        }
    }
    
    private func saveUserInfo() {
        networkManager.requestUpdateProfile(
            name: editUserCardViewModel.name ?? "",
            about: editUserCardViewModel.about ?? "",
            topics: editUserCardViewModel.getSelectedTopicsId())
        { [weak self] user in
            self?.setUserId(userId: user.userId)
            DatabaseService.shared.updateProfile(with: user)
            self?.didFinishRequest?()
            self?.didCompleteUpdating?(self?.networkManager)
        } onFailure: { [weak self] error in
            self?.didRecieveError?(error)
            self?.didFinishRequest?()
        } onNotAuthorized: { [weak self] in
            self?.didNotAuthorize?(self?.networkManager)
        }
    }
    
    // MARK: Private Helper Methods
    private func validateName() -> Bool {
        guard let name = editUserCardViewModel.name else {
            return false
        }
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func removeAvatarAndKfCache() {
        if let url = userData?.avatar {
            KingfisherManager.shared.cache.removeImage(forKey: url)
        }
        editUserCardViewModel.updateAvatar(with: nil)
    }
    
    private func setUserId(userId: String) {
        if UserDefaults.standard.string(forKey: UserDefaultsKeys.userId) == nil {
            UserDefaults.standard.set(userId, forKey: UserDefaultsKeys.userId)
        }
    }
}

// MARK: EditUserCardViewModelDelegate
extension UpdateUserProfileViewModel: EditUserCardViewModelDelegate {
    func chooseAvatar() {
        didTapChooseAvatar?()
    }
    
    func removeAvatar() {
        removeUserAvatar()
    }
}
