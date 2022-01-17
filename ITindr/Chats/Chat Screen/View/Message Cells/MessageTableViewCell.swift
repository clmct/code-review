//
//  UserMessageTableViewCell.swift
//  ITindr
//
//  Created by Эдуард Логинов on 29.10.2021.
//

import UIKit
import SnapKit

class MessageTableViewCell: UITableViewCell {
    
    // MARK: Properties
    let avatarImageView = AvatarImageView()
    let messageContainer = UIView()
    
    private let messageLabel = UILabel()
    private let datetimeLabel = UILabel()
    private let messageAttachment = UIImageView()
    
    private var viewModel: MessageCellViewModel?
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        messageAttachment.image = nil
    }
    
    // MARK: Public Setup Methods
    func configure(with viewModel: MessageCellViewModel) {
        self.viewModel = viewModel
        avatarImageView.configure(with: viewModel.avatarViewModel)
        
        viewModel.didUpdateMessage = { [weak self] in
            self?.updateMessageContent()
        }
        
        avatarImageView.snp.updateConstraints { make in
            make.bottom.equalTo(self).offset(viewModel.bottomOffset)
        }
    }
    
    func setup() {
        setupCell()
        setupMessageContainer()
        setupMessageAttachment()
        setupMessageLabel()
        setupDatetimeLabel()
    }
    
    // MARK: Private Setup Methods
    private func updateMessageContent() {
        messageLabel.text = viewModel?.messageText
        datetimeLabel.text = viewModel?.datetime
        messageAttachment.kf.setImage(with: viewModel?.attachment)
    }
    
    private func setupCell() {
        selectionStyle = .none
        addSubview(avatarImageView)
        addSubview(messageContainer)
        messageContainer.addSubview(datetimeLabel)
        messageContainer.addSubview(messageAttachment)
        messageContainer.addSubview(messageLabel)
    }
    
    private func setupMessageContainer() {
        messageContainer.backgroundColor = Colors.lightGray
        messageContainer.layer.cornerRadius = 8
    }
    
    private func setupMessageAttachment() {
        messageAttachment.contentMode = .scaleAspectFill
        messageAttachment.layer.cornerRadius = 4
        messageAttachment.layer.masksToBounds = true
        messageAttachment.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Dimensions.smallInset)
            make.bottom.equalTo(messageLabel.snp.top).inset(-Dimensions.smallInset)
            make.height.lessThanOrEqualTo(Dimensions.maxAttachmentHeight)
        }
    }
    
    private func setupMessageLabel() {
        messageLabel.font = .defaultLabel
        messageLabel.numberOfLines = 0
        messageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(datetimeLabel.snp.top).inset(-Dimensions.smallerInset)
            make.leading.trailing.equalToSuperview().inset(Dimensions.defaultInset)
        }
    }
    
    private func setupDatetimeLabel() {
        datetimeLabel.textColor = Colors.gray
        datetimeLabel.font = .smallLabel
        datetimeLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview().inset(Dimensions.defaultInset)
        }
    }
}

// MARK: Dimensions
private extension Dimensions {
    static let maxAttachmentHeight: CGFloat = 200
}
