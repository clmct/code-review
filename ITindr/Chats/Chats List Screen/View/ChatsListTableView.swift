//
//  ChatsTableViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 18.10.2021.
//

import UIKit

class ChatsListTableView: UITableView {
    
    // MARK: Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: Private Setup Methods
    private func setup() {
        backgroundColor = Colors.white
        estimatedRowHeight = 96
        rowHeight = 96
        separatorColor = Colors.gray
        tableHeaderView = UIView()
    }
}
