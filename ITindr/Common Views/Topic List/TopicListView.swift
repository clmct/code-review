//
//  TopicListView.swift
//  ITindr
//
//  Created by Эдуард Логинов on 15.10.2021.
//

import UIKit
import TagListView

class TopicListView: TagListView {
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTopicList()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTopicList()
    }
    
    // MARK: Private Methods
    private func setupTopicList() {
        backgroundColor = Colors.white
        textFont = .defaultLabelBold
        textColor = Colors.white
        selectedTextColor = Colors.white
        
        borderWidth = 1
        borderColor = Colors.pink
        
        tagBackgroundColor = Colors.pink ?? Colors.transparent
        tagSelectedBackgroundColor = Colors.pink
        
        cornerRadius = 12
        marginX = 8
        marginY = 8
        paddingX = 8
        paddingY = 3.5
    }
}
