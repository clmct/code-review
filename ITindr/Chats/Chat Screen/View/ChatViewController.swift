//
//  ChatViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 29.10.2021.
//

import UIKit
import SnapKit

class ChatViewController: ImagePickingController {
    
    // MARK: Properties
    override var inputAccessoryView: UIView? {
        get {
            return messageSendView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
     
    override var canResignFirstResponder: Bool {
        return true
    }
    
    private let viewModel: ChatViewModel
    private let messagesTableView = MessagesTableView(frame: .zero, style: .plain)
    
    private lazy var messageSendView: MessageSendView = {
        let sendView = MessageSendView()
        sendView.autoresizingMask = .flexibleHeight
        
        return sendView
    }()
    
    // MARK: Init
    init(networkManager: NetworkService?, chat: Chat) {
        viewModel = ChatViewModel(
            networkManager: networkManager ?? NetworkService(defaultsManager: UserDefaultsManager()),
            chat: chat)
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        messageSendView.configure(with: viewModel.messageSendViewModel)
        viewModel.start()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Public Overrided Methods
    override func imageSelected(_ image: UIImage) {
        viewModel.addAttachment(image)
    }
    
    override func bindToViewModel() {
        super.bindToViewModel()
        
        viewModel.didSetChatTitle = { [weak self] in
            self?.setupNavigationBarTitleView(
                image: self?.viewModel.chatAvatar,
                titleText: self?.viewModel.chatTitle ?? "")
        }
        
        viewModel.didRecieveMessages = { [weak self] in
            self?.messagesTableView.reloadData()
        }
        
        viewModel.didSendMessage = { [weak self] in
            self?.scrollToBottom()
        }
        
        viewModel.didTapAttach = { [weak self] in
            self?.chooseImage()
        }
    }
    
    // MARK: Private Setup Methods
    private func setup() {
        setupView()
        setupMessagesTableView()
    }
    
    private func setupView() {
        view.backgroundColor = Colors.white
        view.addSubview(messagesTableView)
    }
    
    private func setupMessagesTableView() {
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesTableView.register(UserMessageCell.self, forCellReuseIdentifier: ReuseIdentifiers.userMessageCell)
        messagesTableView.register(MateMessageCell.self, forCellReuseIdentifier: ReuseIdentifiers.mateMessageCell)
        
        messagesTableView.keyboardDismissMode = .interactive
        messagesTableView.contentInset = UIEdgeInsets(
            top: Dimensions.smallInset,
            left: 0, bottom: 0, right: 0)
        messagesTableView.backgroundColor = Colors.white
        messagesTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: Private Helper Methods
    private func scrollToBottom() {
        let messagesCount = viewModel.messagesCount
        guard messagesCount > 0 else { return }
        DispatchQueue.main.async { [weak self] in
            let indexPath = IndexPath(row: messagesCount - 1, section: 0)
            self?.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messagesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let identifier = viewModel.getMessageReuseIdentifierIfPossible(index: indexPath.item),
              let messageCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
                as? MessageTableViewCell else {
            return UITableViewCell()
        }
        
        let messageViewModel = viewModel.getMessageViewModel(index: indexPath.item)
        messageCell.configure(with: messageViewModel)
        messageViewModel.start()
        
        return messageCell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.getOlderMessagesIfExists(scrollOffset: scrollView.contentOffset.y)
    }
}
