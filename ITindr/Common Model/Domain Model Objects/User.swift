//
//  UserModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 25.10.2021.
//

import Foundation

struct User: Codable {
    let userId: String
    let name: String
    let aboutMyself: String?
    let avatar: String?
    let topics: [Topic]?
}
