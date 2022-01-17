//
//  ChatsViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 18.10.2021.
//

import UIKit

class ChatsViewController: UIViewController {
    
    private let networkManager: NetworkManager
    
    @IBOutlet var chatsTableView: ChatsTableView!
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        super.init(nibName: "ChatsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension ChatsViewController {
    func setup() {
        navigationItem.title = Strings.chats
        
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        chatsTableView.setup()
        
        chatsTableView.register(UINib(nibName: NibNames.chatCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifiers.chatCell)
    }
}

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.chatCell, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
