//
//  AvatarImageView.swift
//  ITindr
//
//  Created by Эдуард Логинов on 20.11.2021.
//

import UIKit

class AvatarImageView: UIImageView {
    
    // MARK: Properties
    var avatarImage: UIImage? {
        didSet {
            image = avatarImage ?? UIImage(named: ImageNames.personPlaceholder)
        }
    }
    
    // MARK: Init
    init() {
        super.init(image: nil)
        avatarImage = nil
        setup()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        avatarImage = image
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    // MARK: Public Methods
    func configure(with viewModel: AvatarImageViewModel) {
        viewModel.didUpdateAvatar = { [weak self] in
            self?.image = viewModel.avatar ?? UIImage(named: ImageNames.personPlaceholder)
        }
    }
    
    // MARK: Private Methods
    private func setup() {
        image = avatarImage ?? UIImage(named: ImageNames.personPlaceholder)
        tintColor = Colors.gray
        contentMode = .scaleAspectFill
        backgroundColor = Colors.lightGray
        layer.masksToBounds = true
    }
}
