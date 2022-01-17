//
//  BaseError.swift
//  ITindr
//
//  Created by Эдуард Логинов on 23.11.2021.
//

import Foundation

protocol BaseError: Error {
    init(code: Int?)
}
