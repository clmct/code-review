//
//  MateMessageCell.swift
//  ITindr
//
//  Created by Эдуард Логинов on 30.10.2021.
//

import UIKit
import SnapKit

class MateMessageCell: MessageTableViewCell {

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
            make.trailing.equalTo(messageContainer.snp.leading).inset(-Dimensions.smallInset)
            make.leading.equalTo(self).inset(Dimensions.defaultInset)
            make.width.equalTo(Dimensions.mediumInset)
            make.width.equalTo(avatarImageView.snp.height)
        }
    }
    
    private func setupMessageContainer() {
        messageContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        messageContainer.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.trailing.lessThanOrEqualTo(self).inset(Dimensions.messageTrailingInset)
        }
    }
}

// MARK: Dimensions
private extension Dimensions {
    static let messageTrailingInset: CGFloat = 80
}
