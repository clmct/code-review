//
//  ChatsTableViewCell.swift
//  ITindr
//
//  Created by Эдуард Логинов on 18.10.2021.
//

import UIKit
import SnapKit

class ChatsListTableViewCell: UITableViewCell {
    
    // MARK: Properties
    private let avatarImageView = AvatarImageView()
    private let titleLabel = UILabel()
    private let lastMessageLabel = UILabel()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        separatorInset = UIEdgeInsets(
            top: 0,
            left: Dimensions.mediumInset + avatarImageView.frame.width,
            bottom: 0,
            right: 0)
    }
    
    // MARK: Public Methods
    func configure(with viewModel: ChatsListCellViewModel) {
        avatarImageView.configure(with: viewModel.avatarViewModel)
        
        viewModel.didUpdateChatInfo = { [weak self] in
            self?.titleLabel.text = viewModel.title
            self?.lastMessageLabel.text = viewModel.lastMessageText
        }
    }
    
    // MARK: Private Setup Methods
    private func setup() {
        setupCell()
        setupAvatarImageView()
        setupTitleLabel()
        setupLastMessageLabel()
    }
    
    private func setupCell() {
        selectionStyle = .none
        addSubview(avatarImageView)
        addSubview(titleLabel)
        addSubview(lastMessageLabel)
    }
    
    private func setupAvatarImageView() {
        avatarImageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(Dimensions.defaultInset)
            make.trailing.equalTo(titleLabel.snp.leading).inset(-Dimensions.defaultInset)
            make.width.equalTo(avatarImageView.snp.height)
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .defaultLabelBold
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.top)
            make.trailing.equalToSuperview().inset(Dimensions.defaultInset)
        }
    }
    
    private func setupLastMessageLabel() {
        lastMessageLabel.textColor = Colors.darkGray
        lastMessageLabel.font = .defaultLabel
        lastMessageLabel.numberOfLines = 2
        lastMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-Dimensions.smallerInset)
            make.leading.trailing.equalTo(titleLabel)
        }
    }
}
