//
//  ChatsViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 18.10.2021.
//

import UIKit
import SnapKit

class ChatsListViewController: BaseViewController {
    
    // MARK: Properties
    private let viewModel: ChatsListViewModel
    private let chatsTableView = ChatsListTableView(frame: .zero, style: .plain)
    
    // MARK: Init
    init(networkManager: NetworkService) {
        viewModel = ChatsListViewModel(networkManager: networkManager)
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getChats()
    }
    
    // MARK: Public Methods
    override func bindToViewModel() {
        super.bindToViewModel()
        
        viewModel.didRecieveChatsList = { [weak self] in
            self?.chatsTableView.reloadData()
        }
        
        viewModel.didTapChatCell = { [weak self] networkManager, chat in
            self?.navigationController?.pushViewController(
                ChatViewController(networkManager: networkManager, chat: chat),
                animated: true)
        }
    }
    
    // MARK: Private Setup Methods
    private func setup() {
        setupView()
        setupChatsTableView()
    }
    
    private func setupView() {
        setupBackButton()
        navigationItem.title = Strings.chats
        view.backgroundColor = Colors.white
        view.addSubview(chatsTableView)
    }
    
    private func setupChatsTableView() {
        chatsTableView.backgroundColor = Colors.white
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        chatsTableView.register(ChatsListTableViewCell.self, forCellReuseIdentifier: ReuseIdentifiers.chatCell)
        chatsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension ChatsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chatsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let chatCell = tableView.dequeueReusableCell(
            withIdentifier: ReuseIdentifiers.chatCell,
            for: indexPath) as? ChatsListTableViewCell else {
                return UITableViewCell()
        }
        
        let chatCellViewModel = viewModel.getChatCellViewModel(at: indexPath.item)
        chatCell.configure(with: chatCellViewModel)
        chatCellViewModel.start()
        
        return chatCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.chatCellTap(index: indexPath.item)
    }
}
