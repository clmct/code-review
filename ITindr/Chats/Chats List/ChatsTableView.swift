//
//  ChatsTableViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 18.10.2021.
//

import UIKit

class ChatsTableView: UITableView {
    func setup() {
        backgroundColor = Colors.white
        estimatedRowHeight = 96
        rowHeight = 96
        separatorColor = Colors.gray
        tableHeaderView = UIView()
    }
}
