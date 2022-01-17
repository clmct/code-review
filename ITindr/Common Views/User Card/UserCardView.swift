//
//  UserCardView.swift
//  ITindr
//
//  Created by Эдуард Логинов on 26.10.2021.
//

import UIKit
import SnapKit

class UserCardView: UIView {
    
    // MARK: Properties
    private let avatarImageView = AvatarImageView()
    private let nameLabel = UILabel()
    private let topicListView = TopicListView()
    private let aboutLabel = UILabel()
    
    private var viewModel: UserCardViewModel?
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func configure(with viewModel: UserCardViewModel) {
        self.viewModel = viewModel
        avatarImageView.configure(with: viewModel.avatarViewModel)
        
        viewModel.didUpdateUserInfo = { [weak self] in
            self?.updateUserInfo()
        }
    }
    
    // MARK: Actions
    @objc private func cardTap() {
        viewModel?.userCardTap()
    }
    
    // MARK: Private Update User Methods
    private func updateUserInfo() {
        nameLabel.text = viewModel?.name
        aboutLabel.text = viewModel?.about
        topicListView.removeAllTags()
        topicListView.addTags(viewModel?.topicTitles ?? [])
    }
    
    // MARK: Private Setup Methods
    private func setup() {
        setupView()
        setupAvatarImageView()
        setupNameLabel()
        setupTopicListView()
        setupAboutLabel()
    }
    
    private func setupView() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardTap)))
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(topicListView)
        addSubview(aboutLabel)
    }
    
    private func setupAvatarImageView() {
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(nameLabel.snp.top).inset(-Dimensions.mediumInset)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(Dimensions.widhtMultiplier)
            make.height.equalTo(avatarImageView.snp.width)
        }
    }
    
    private func setupNameLabel() {
        nameLabel.textAlignment = .center
        nameLabel.font = .largeLabelBold
        nameLabel.numberOfLines = 0
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(topicListView.snp.top).inset(-Dimensions.defaultInset)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupTopicListView() {
        topicListView.alignment = .center
        topicListView.snp.makeConstraints { make in
            make.bottom.equalTo(aboutLabel.snp.top).inset(-Dimensions.mediumInset)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupAboutLabel() {
        aboutLabel.textAlignment = .center
        aboutLabel.font = .defaultLabel
        aboutLabel.numberOfLines = 0
        aboutLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: Dimensions
private extension Dimensions {
    static let widhtMultiplier: CGFloat = 0.55
}
