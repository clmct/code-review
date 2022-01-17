//
//  ChatsTableViewCell.swift
//  ITindr
//
//  Created by Эдуард Логинов on 18.10.2021.
//

import UIKit

class ChatsTableViewCell: UITableViewCell {
    
    @IBOutlet var avatarImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

private extension ChatsTableViewCell {
    private func setupCell() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.masksToBounds = true
        
        separatorInset = UIEdgeInsets(top: 0, left: 32 + avatarImageView.frame.width, bottom: 0, right: 0)
    }
}
