//
//  PeopleViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 30.11.2021.
//

import UIKit

class PeopleViewModel: BaseViewModel {
    
    // MARK: Properties
    var isPaging: Bool = false
    var peopleCount: Int {
        get {
            return peopleViewModels.count
        }
    }
    
    var didRecievePeople: (() -> Void)?
    var didTapUserCell: ((NetworkService, User) -> Void)?
    
    private let networkManager: NetworkService
    
    private var peopleViewModels: [PeopleCellViewModel] = []
    private var currentOffset: Int = 0
    
    // MARK: Init
    init(networkManager: NetworkService) {
        self.networkManager = networkManager
    }
    
    // MARK: Public Methods
    func userCellTap(index: Int) {
        didTapUserCell?(networkManager, peopleViewModels[index].user)
    }
    
    func getPeopleIfExists(distanceFromBottom: CGFloat, frameHeight: CGFloat) {
        if distanceFromBottom < frameHeight && !isPaging {
            loadNewPeople()
        }
    }
    
    func getPeopleViewModel(index: Int) -> PeopleCellViewModel {
        return peopleViewModels[index]
    }
    
    func getPeople() {
        let localPeople = DatabaseService.shared.getPeopleList()
        updateLoadedPeople(localPeople)
        
        guard currentOffset != 0 else {
            loadNewPeople()
            return
        }
        
        isPaging = true
        networkManager.requestUsersList(
            limit: currentOffset,
            offset: 0) { [weak self] users in
                DatabaseService.shared.updatePeopleList(withContest: users)
                self?.updateLoadedPeople(users)
                self?.isPaging = false
                self?.loadNewPeopleIfNeeded()
            } onFailure: { [weak self] error in
                self?.didRecieveError?(error)
                self?.isPaging = false
            } onNotAuthorized: { [weak self] in
                self?.didNotAuthorize?(self?.networkManager)
            }
    }
    
    // MARK: Private People Load Methods
    private func loadNewPeopleIfNeeded() {
        if currentOffset < 20 {
            loadNewPeople()
        }
    }
    
    private func loadNewPeople() {
        isPaging = true
        networkManager.requestUsersList(
            limit: 20,
            offset: currentOffset) { [weak self] users in
                DatabaseService.shared.updatePeopleList(withContest: users)
                self?.addLoadedPeople(users)
                self?.isPaging = false
            } onFailure: { [weak self] error in
                self?.didRecieveError?(error)
                self?.isPaging = false
            } onNotAuthorized: { [weak self] in
                self?.didNotAuthorize?(self?.networkManager)
            }
    }
    
    private func updateLoadedPeople(_ users: [User]) {
        peopleViewModels = users.map { PeopleCellViewModel(with: $0) }
        currentOffset = users.count
        didRecievePeople?()
    }
    
    private func addLoadedPeople(_ users: [User]) {
        peopleViewModels.append(contentsOf: users.map { PeopleCellViewModel(with: $0) })
        currentOffset += users.count
        didRecievePeople?()
    }
}
