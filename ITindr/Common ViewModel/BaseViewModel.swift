//
//  BaseViewModel.swift
//  ITindr
//
//  Created by Эдуард Логинов on 27.11.2021.
//

import Foundation

class BaseViewModel {
    var didStartRequest: (() -> Void)?
    var didFinishRequest: (() -> Void)?
    var didRecieveError: ((Error) -> Void)?
    var didNotAuthorize: ((NetworkService?) -> Void)?
}
