//
//  EditUserCardView.swift
//  ITindr
//
//  Created by Эдуард Логинов on 26.10.2021.
//

import UIKit
import SnapKit

class EditUserCardView: UIView {
    
    // MARK: Properties
    private let aboutHeaderLabel = UILabel()
    private let avatarImageView = AvatarImageView()
    private let chooseAvatarButton = UIButton()
    private let nameTextField = CommonTextField()
    private let aboutTextView = CommonTextView()
    private let topicsHeaderLabel = UILabel()
    private let topicListView = SelectableTopicListView()
    
    private var viewModel: EditUserCardViewModel?
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func configure(with viewModel: EditUserCardViewModel) {
        self.viewModel = viewModel
        avatarImageView.configure(with: viewModel.avatarViewModel)
        chooseAvatarButton.setTitle(viewModel.avatarButtonTitle, for: .normal)
        
        viewModel.didUpdateLabels = { [weak self] in
            self?.aboutHeaderLabel.text = viewModel.aboutHeader
            self?.topicsHeaderLabel.text = viewModel.topicsHeader
        }
        
        viewModel.didUpdateTopics = { [weak self] in
            self?.topicListView.removeAllTags()
            self?.topicListView.addTags(viewModel.topicTitles)
        }
        
        viewModel.didSetTopicSelected = { [weak self] topicTitle in
            self?.setTopicSelected(title: topicTitle)
        }
        
        viewModel.selectedTopicTitles = { [weak self] in
            return self?.topicListView.selectedTags().map { $0.currentTitle ?? "" }
        }
        
        viewModel.didUpdateAvatarButton = { [weak self] in
            self?.chooseAvatarButton.setTitle(viewModel.avatarButtonTitle, for: .normal)
        }
        
        viewModel.didUpdateUserInfo = { [weak self] in
            self?.nameTextField.text = viewModel.name
            self?.aboutTextView.inputText = viewModel.about
        }
    }
    
    // MARK: Actions
    @objc private func didAvatarButtonTap() {
        viewModel?.didAvatarButtonTap()
    }
    
    // MARK: Private Setup Methods
    private func setTopicSelected(title: String) {
        let topic = topicListView.tagViews.first(
            where: { $0.currentTitle == title }
        )
        topic?.isSelected = true
        topic?.textFont = .defaultLabelBold
    }
    
    private func setup() {
        setupView()
        setupAboutHeaderLabel()
        setupAvatarImageView()
        setupChooseAvatarButton()
        setupNameTextField()
        setupAboutTextView()
        setupTopicsHeaderLabel()
        setupTopicListView()
    }
    
    private func setupView() {
        addSubview(aboutHeaderLabel)
        addSubview(avatarImageView)
        addSubview(chooseAvatarButton)
        addSubview(nameTextField)
        addSubview(aboutTextView)
        addSubview(topicsHeaderLabel)
        addSubview(topicListView)
    }
    
    private func setupAboutHeaderLabel() {
        aboutHeaderLabel.textColor = Colors.pink
        aboutHeaderLabel.font = .largeLabelBold
        aboutHeaderLabel.textAlignment = .left
        aboutHeaderLabel.snp.makeConstraints { make in
            make.bottom.equalTo(avatarImageView.snp.top).inset(-Dimensions.defaultInset)
            make.top.leading.equalToSuperview()
            make.leading.equalTo(avatarImageView.snp.leading)
        }
    }
    
    private func setupAvatarImageView() {
        avatarImageView.snp.makeConstraints { make in
            make.bottom.equalTo(nameTextField.snp.top).inset(-Dimensions.defaultInset)
            make.leading.equalTo(nameTextField.snp.leading)
            make.trailing.equalTo(chooseAvatarButton.snp.leading).inset(-Dimensions.localMediumInset)
            make.width.equalToSuperview().multipliedBy(Dimensions.avatarWidthMultiplier)
            make.height.equalTo(avatarImageView.snp.width)
        }
    }
    
    private func setupChooseAvatarButton() {
        chooseAvatarButton.addTarget(self, action: #selector(didAvatarButtonTap), for: .touchUpInside)
        chooseAvatarButton.setTitleColor(Colors.pink, for: .normal)
        chooseAvatarButton.titleLabel?.font = .defaultLabelBold
        chooseAvatarButton.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView)
        }
    }
    
    private func setupNameTextField() {
        nameTextField.delegate = self
        nameTextField.placeholder = Strings.namePlaceholder
        nameTextField.snp.makeConstraints { make in
            make.bottom.equalTo(aboutTextView.snp.top).inset(-Dimensions.defaultInset)
            make.leading.equalTo(aboutTextView.snp.leading)
            make.trailing.equalToSuperview()
            make.height.equalTo(Dimensions.defaultHeight)
        }
    }
    
    private func setupAboutTextView() {
        aboutTextView.changedTextDelegate = self
        aboutTextView.snp.makeConstraints { make in
            make.bottom.equalTo(topicsHeaderLabel.snp.top).inset(-Dimensions.localMediumInset)
            make.leading.equalTo(topicsHeaderLabel.snp.leading)
            make.trailing.equalToSuperview()
            make.height.equalTo(Dimensions.aboutTextViewHeight)
        }
    }
    
    private func setupTopicsHeaderLabel() {
        topicsHeaderLabel.textColor = Colors.pink
        topicsHeaderLabel.font = .largeLabelBold
        topicsHeaderLabel.textAlignment = .left
        topicsHeaderLabel.snp.makeConstraints { make in
            make.bottom.equalTo(topicListView.snp.top).inset(-Dimensions.defaultInset)
            make.trailing.equalToSuperview()
        }
    }
    
    private func setupTopicListView() {
        topicListView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: CommonTextViewDelegate, UITextFieldDelegate
extension EditUserCardView: CommonTextViewDelegate, UITextFieldDelegate {
    func textViewDidChange(_ textView: CommonTextView) {
        viewModel?.about = textView.inputText
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel?.name = textField.text
    }
}

// MARK: Dimensions
private extension Dimensions {
    static let avatarWidthMultiplier: CGFloat = 0.235
    static let localMediumInset: CGFloat = 24
    static let aboutTextViewHeight: CGFloat = 128
}
