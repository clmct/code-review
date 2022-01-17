//
//  MessageSendView.swift
//  ITindr
//
//  Created by Эдуард Логинов on 29.10.2021.
//

import UIKit
import SnapKit

class MessageSendView: UIView {
    
    // MARK: Properties
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    private let attachPhotoButton = UIButton()
    private let messageTextView = CommonTextView()
    private let sendMessageButton = GradientButton(
        nil,
        icon: UIImage(named: ImageNames.sendIcon),
        contentColor: Colors.white)
    private let removeAttachmentButton = UIButton()
    private let attachmentImageView = UIImageView()
    
    private var viewModel: MessageSendViewModel?
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func configure(with viewModel: MessageSendViewModel) {
        self.viewModel = viewModel
        
        viewModel.didUpdateText = { [weak self] text in
            self?.updateTextView(withText: text)
        }
        
        viewModel.didUpdateAttachment = { [weak self] in
            self?.updateAttachment()
        }
    }
    
    // MARK: Actions
    @objc private func send() {
        viewModel?.send(text: messageTextView.inputText)
    }
    
    @objc private func attach() {
        viewModel?.attach()
    }
    
    @objc private func removeAttachment() {
        viewModel?.updateAttachment(nil)
    }
    
    // MARK: Private Update Methods
    private func updateTextView(withText text: String?) {
        messageTextView.inputText = nil
        messageTextView.text = nil
        textViewDidChange(messageTextView)
    }
    
    private func updateAttachment() {
        guard let viewModel = viewModel else { return }
        attachmentImageView.image = viewModel.attachment
        attachmentImageView.isHidden = viewModel.isAttachmentHidden
        attachmentImageView.snp.updateConstraints { make in
            make.height.equalTo(viewModel.attachmentHeight)
        }
    }
    
    // MARK: Private Setup Methods
    private func setup() {
        setupView()
        setupMessageTextView()
        setupAttachmentImageView()
        setupSendMessageButton()
        setupAttachPhotoButton()
        setupRemoveAttachmentButton()
    }
    
    private func setupView() {
        backgroundColor = Colors.white
        addSubview(attachPhotoButton)
        addSubview(attachmentImageView)
        addSubview(messageTextView)
        addSubview(sendMessageButton)
        attachmentImageView.addSubview(removeAttachmentButton)
    }
    
    private func setupMessageTextView() {
        messageTextView.changedTextDelegate = self
        messageTextView.cornerRadius = 4
        messageTextView.textInsets = UIEdgeInsets(
            top: Dimensions.textViewVerticalContentInset,
            left: Dimensions.defaultInset,
            bottom: Dimensions.textViewVerticalContentInset,
            right: Dimensions.defaultInset)
        messageTextView.placeholder = Strings.messagePlaceholder
        messageTextView.snp.makeConstraints { make in
            make.bottom.equalTo(layoutMarginsGuide).inset(Dimensions.textViewBottomInset)
            make.bottom.equalTo(attachPhotoButton.snp.bottom)
            make.bottom.equalTo(sendMessageButton.snp.bottom)
            make.leading.equalTo(attachPhotoButton.snp.trailing).inset(-Dimensions.defaultInset)
            make.trailing.equalTo(sendMessageButton.snp.leading).inset(-Dimensions.defaultInset)
            make.height.equalTo(Dimensions.mediumPlusInset)
        }
    }
    
    private func setupAttachmentImageView() {
        attachmentImageView.layer.cornerRadius = 8
        attachmentImageView.layer.masksToBounds = true
        attachmentImageView.contentMode = .scaleAspectFill
        attachmentImageView.isUserInteractionEnabled = true
        attachmentImageView.isHidden = true
        attachmentImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Dimensions.smallInset)
            make.bottom.equalTo(messageTextView.snp.top).inset(-Dimensions.smallInset)
            make.leading.equalTo(messageTextView.snp.leading)
            make.width.equalTo(attachmentImageView.snp.height)
            make.height.equalTo(0)
        }
    }
    
    private func setupSendMessageButton() {
        sendMessageButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        sendMessageButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Dimensions.defaultInset)
            make.width.equalTo(Dimensions.mediumPlusInset)
            make.height.equalTo(sendMessageButton.snp.width)
        }
    }
    
    private func setupAttachPhotoButton() {
        attachPhotoButton.addTarget(self, action: #selector(attach), for: .touchUpInside)
        attachPhotoButton.layer.borderWidth = 1
        attachPhotoButton.layer.borderColor = Colors.lightGray?.cgColor
        attachPhotoButton.layer.cornerRadius = 8
        attachPhotoButton.setImage(UIImage(named: ImageNames.cameraIcon), for: .normal)
        attachPhotoButton.imageView?.tintColor = Colors.gray
        attachPhotoButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Dimensions.defaultInset)
            make.width.equalTo(Dimensions.mediumPlusInset)
            make.height.equalTo(attachPhotoButton.snp.width)
        }
    }
    
    private func setupRemoveAttachmentButton() {
        removeAttachmentButton.addTarget(self, action: #selector(removeAttachment), for: .touchUpInside)
        removeAttachmentButton.tintColor = Colors.lightGray
        removeAttachmentButton.setImage(UIImage(named: ImageNames.crossIcon), for: .normal)
        removeAttachmentButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(attachmentImageView).inset(Dimensions.smallerInset)
            make.width.equalTo(removeAttachmentButton.snp.height)
            make.height.equalTo(Dimensions.removeAttachmentButtonSize)
        }
    }
}

// MARK: CommonTextViewDelegate
extension MessageSendView: CommonTextViewDelegate {
    func textViewDidChange(_ textView: CommonTextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.snp.updateConstraints { make in
            make.height.equalTo(min(estimatedSize.height, Dimensions.maxTextViewHeight))
        }
    }
}

// MARK: Dimensions
private extension Dimensions {
    static let textViewVerticalContentInset: CGFloat = 10
    static let textViewBottomInset: CGFloat = 6
    static let maxTextViewHeight: CGFloat = 100
    static let removeAttachmentButtonSize: CGFloat = 20
}
