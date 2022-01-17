//
//  EditProfileViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 26.10.2021.
//

import UIKit
import SnapKit

class EditProfileViewController: UpdateUserProfileViewController {
    
    // MARK: Init
    init(networkManager: NetworkService?, user: User? = nil) {
        super.init(networkManager: networkManager,
                   user: user,
                   aboutHeader: Strings.editProfileTitle,
                   topicsHeader: Strings.editProfileTopicsHeader)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Public Overrided Methods
    override func setup() {
        super.setup()
        setupView()
        setupScrollView()
        setupEditUserCardView()
        setupSaveButton()
    }
    
    // MARK: Private Setup Methods
    private func setupView() {
        navigationItem.title = Strings.editProfileTitle
    }
    
    private func setupScrollView() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupEditUserCardView() {
        editUserCardView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
                .inset(UIEdgeInsets(
                    top: Dimensions.mediumInset,
                    left: Dimensions.defaultInset,
                    bottom: Dimensions.largerInset,
                    right: -Dimensions.defaultInset))
            make.centerX.equalTo(scrollView)
            make.width.equalTo(scrollView.frameLayoutGuide).priority(750)
            make.height.equalTo(0).priority(500)
        }
    }
    
    private func setupSaveButton() {
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(Dimensions.defaultHeight)
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Dimensions.defaultInset)
        }
    }
}
