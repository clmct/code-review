//
//  PeopleCollectionViewCell.swift
//  ITindr
//
//  Created by Эдуард Логинов on 15.11.2021.
//

import UIKit
import SnapKit

class PeopleCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    private let avatarImageView = AvatarImageView()
    private let nameLabel = UILabel()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func configure(with viewModel: PeopleCellViewModel) {
        avatarImageView.configure(with: viewModel.avatarViewModel)
        
        viewModel.didUpdateUser = { [weak self] in
            self?.nameLabel.text = viewModel.name
        }
    }
    
    // MARK: Private Setup Methods
    private func setup() {
        setupCell()
        setupAvatarImageView()
        setupNameLabel()
    }
    
    private func setupCell() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
    }
    
    private func setupAvatarImageView() {
        avatarImageView.snp.makeConstraints { make in
            make.bottom.equalTo(nameLabel.snp.top).inset(-Dimensions.defaultInset)
            make.top.leading.trailing.equalTo(self)
            make.height.equalTo(avatarImageView.snp.width)
        }
    }
    
    private func setupNameLabel() {
        nameLabel.font = .defaultLabelBold
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 1
        nameLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(self)
        }
    }
}
