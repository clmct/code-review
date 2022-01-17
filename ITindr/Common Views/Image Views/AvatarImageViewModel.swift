//
//  AvatarImageViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 29.11.2021.
//

import UIKit
import Kingfisher

class AvatarImageViewModel {
    
    // MARK: Properties
    var avatar: UIImage?
    
    var didUpdateAvatar: (() -> Void)?
    
    // MARK: Public Methods
    func updateAvatar(with image: UIImage?) {
        avatar = image
        didUpdateAvatar?()
    }
    
    func updateAvatar(withUrl url: String?, completion: ((UIImage?) -> Void)? = nil) {
        guard let url = URL(string: url ?? "") else {
            avatar = nil
            didUpdateAvatar?()
            completion?(nil)
            return
        }
        
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            let image  = try? result.get().image
            self?.avatar = image
            self?.didUpdateAvatar?()
            completion?(image)
        }
    }
}
