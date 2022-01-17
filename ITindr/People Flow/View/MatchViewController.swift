//
//  MatchViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 28.10.2021.
//

import UIKit
import SnapKit

class MatchViewController: BaseViewController {
    
    // MARK: Properties
    private let viewModel: MatchViewModel
    
    private let tabController: UITabBarController?
    private let matchImageView = UIImageView()
    private let matchLabel = UILabel()
    private let startChatButton = GradientButton(Strings.writeMessage)
    
    // MARK: Init
    init(userId: String, networkManager: NetworkService, tabController: UITabBarController?) {
        viewModel = MatchViewModel(networkManager: networkManager, userId: userId)
        self.tabController = tabController
        super.init(viewModel: viewModel)
        bindToViewModel()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    override func bindToViewModel() {
        viewModel.didStartRequest = { [weak self] in
            self?.disableUserInteraction()
        }
        
        viewModel.didFinishRequest = { [weak self] in
            self?.dismiss(animated: true)
            self?.enableUserInteraction()
        }
        
        viewModel.didRecieveError = { [weak self] error in
            self?.showErrorAlert(error)
            self?.dismiss(animated: true)
        }
        
        viewModel.didNotAuthorize = { [weak self] networkManager in
            self?.dismiss(animated: true)
        }
        
        viewModel.didCreateChat = { [weak self] newChat, networkManager in
            self?.tryNavigateToCreatedChat(newChat: newChat, networkManager: networkManager)
        }
    }
    
    // MARK: Actions
    @objc private func startChat() {
        viewModel.startChat()
    }
    
    // MARK: Private Setup Methods
    private func setup() {
        setupView()
        setupMatchImageView()
        setupMatchLabel()
        setupStartChatButton()
    }
    
    private func setupView() {
        modalPresentationStyle = .overCurrentContext
        view.backgroundColor = Colors.blackBackground
        view.addSubview(matchImageView)
        view.addSubview(matchLabel)
        view.addSubview(startChatButton)
    }
    
    private func setupMatchImageView() {
        matchImageView.image = UIImage(named: ImageNames.match)
        matchImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Dimensions.matchImageTopInset)
            make.bottom.equalTo(matchLabel.snp.top).inset(-Dimensions.defaultInset)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(Dimensions.matchImageWidthMultiplier)
        }
    }
    
    private func setupMatchLabel() {
        matchLabel.text = Strings.match
        matchLabel.textColor = Colors.white
        matchLabel.font = .mediumLabelBold
        matchLabel.textAlignment = .center
        matchLabel.numberOfLines = 0
        matchLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Dimensions.largeInset)
        }
    }
    
    private func setupStartChatButton() {
        startChatButton.addTarget(self, action: #selector(startChat), for: .touchUpInside)
        startChatButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Dimensions.startChatButtonBottomInset)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Dimensions.defaultInset)
            make.height.equalTo(Dimensions.defaultHeight)
        }
    }
    
    // MARK: Private Navigation Methods
    private func tryNavigateToCreatedChat(newChat: Chat, networkManager: NetworkService?) {
        let selectedIndex = 2
        guard let tabController = tabController,
                let chatListVC = tabController.viewControllers?[selectedIndex]
                as? UINavigationController else {
            return
        }
        
        tabController.selectedIndex = selectedIndex
        chatListVC.pushViewController(
            ChatViewController(networkManager: networkManager, chat: newChat),
            animated: true)
    }
}

// MARK: Dimensions
private extension Dimensions {
    static let matchImageTopInset: CGFloat = 200
    static let matchImageWidthMultiplier: CGFloat = 0.8213
    static let startChatButtonBottomInset: CGFloat = 50
}
