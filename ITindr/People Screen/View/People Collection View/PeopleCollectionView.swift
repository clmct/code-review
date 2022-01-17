//
//  PeopleCollectionView.swift
//  ITindr
//
//  Created by Эдуард Логинов on 15.11.2021.
//

import UIKit

class PeopleCollectionView: UICollectionView {
    // MARK: Init
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
