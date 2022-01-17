//
//  MessageSendViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 30.11.2021.
//

import UIKit

protocol MessageSendViewModelDelegate {
    func send(text: String?, attachment: UIImage?)
    func attach()
}

class MessageSendViewModel {
    
    // MARK: Properties
    var delegate: MessageSendViewModelDelegate?
    
    var attachment: UIImage?
    var isAttachmentHidden: Bool = true
    var attachmentHeight: CGFloat = 0
    
    var didUpdateText: ((String?) -> Void)?
    var didUpdateAttachment: (() -> Void)?
    
    // MARK: Public Methods
    func updateText(with text: String?) {
        didUpdateText?(text)
    }
    
    func updateAttachment(_ image: UIImage?) {
        let imageExists = image != nil
        attachment = image
        isAttachmentHidden = !imageExists
        attachmentHeight = imageExists ? 90 : 0
        didUpdateAttachment?()
    }
    
    func send(text: String?) {
        delegate?.send(text: text, attachment: attachment)
    }
    
    func attach() {
        delegate?.attach()
    }
}
