//
//  ProfileViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 27.11.2021.
//

import Foundation

class ProfileViewModel: BaseViewModel {
    
    // MARK: Properties
    let userCardViewModel: UserCardViewModel
    
    var didTapEditUser: ((NetworkService?, User?) -> Void)?
    var didTapUserCard: ((User) -> Void)?
    
    private let networkManager: NetworkService
    
    private var userData: User?
    
    // MARK: Init
    init(networkManager: NetworkService) {
        self.networkManager = networkManager
        userCardViewModel = UserCardViewModel()
    }
    
    // MARK: Public Methods
    func start() {
        userCardViewModel.delegate = self
        getUserProfileInfo()
    }
    
    func userEditTap() {
        didTapEditUser?(networkManager, userData)
    }
    
    func getUserProfileInfo() {
        guard let profile = DatabaseService.shared.getProfile() else {
            didStartRequest?()
            networkManager.requestProfileInfo { [weak self] user in
                DatabaseService.shared.updateProfile(with: user)
                self?.setupUserInfo(withModel: user)
                self?.didFinishRequest?()
            } onFailure: { [weak self] error in
                self?.didRecieveError?(error)
            } onNotAuthorized: { [weak self] in
                self?.didNotAuthorize?(self?.networkManager)
            }
            return
        }
        
        setupUserInfo(withModel: profile)
    }
    
    // MARK: Private Methods
    private func setupUserInfo(withModel userModel: User) {
        userCardViewModel.updateUserInfo(with: userModel)
        userData = userModel
    }
}

// MARK: UserCardViewModelDelegate
extension ProfileViewModel: UserCardViewModelDelegate {
    func onCardTap(user: User) {
        didTapUserCard?(user)
    }
}
