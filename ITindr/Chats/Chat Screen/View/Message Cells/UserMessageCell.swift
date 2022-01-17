//
//  UserMessageCell.swift
//  ITindr
//
//  Created by Эдуард Логинов on 30.10.2021.
//

import UIKit
import SnapKit

class UserMessageCell: MessageTableViewCell {
    
    // MARK: Public Overrided Methods
    override func setup() {
        super.setup()
        setupAvatarImageView()
        setupMessageContainer()
    }
    
    // MARK: Private Setup Methods
    private func setupAvatarImageView() {
        avatarImageView.snp.makeConstraints { make in
            make.bottom.equalTo(self).inset(Dimensions.smallInset)
            make.bottom.equalTo(messageContainer.snp.bottom)
            make.leading.equalTo(messageContainer.snp.trailing).inset(-Dimensions.smallInset)
            make.trailing.equalTo(self).inset(Dimensions.defaultInset)
            make.width.equalTo(Dimensions.mediumInset)
            make.width.equalTo(avatarImageView.snp.height)
        }
    }
    
    private func setupMessageContainer() {
        messageContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        messageContainer.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.greaterThanOrEqualTo(self).inset(Dimensions.messageLeadingInset)
        }
    }
}

// MARK: Dimensions
private extension Dimensions {
    static let messageLeadingInset: CGFloat = 80
}
