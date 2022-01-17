//
//  SelectableTopicsListView.swift
//  ITindr
//
//  Created by Эдуард Логинов on 18.10.2021.
//

import UIKit
import TagListView

protocol SelectableTopicListViewDelegate {
    func topicPressed(_ title: String, topicView: TagView, sender: TagListView)
}

class SelectableTopicListView: TopicListView {
    
    // MARK: Properties
    var topicsDelegate: SelectableTopicListViewDelegate?
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTopicList()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTopicList()
    }
    
    // MARK: Public Methods
    func toggleSelected(tagView: TagView) {
        tagView.isSelected = !tagView.isSelected
        if tagView.isSelected {
            tagView.textFont = .defaultLabelBold
            tagView.paddingX = 0
            tagView.paddingY = 0
        } else {
            tagView.textFont = .defaultLabel
            tagView.paddingX = 8
            tagView.paddingY = 3.5
        }
    }
    
    // MARK: Private Methods
    private func setupTopicList() {
        delegate = self
        
        textFont = .defaultLabel
        textColor = Colors.pink ?? Colors.black
        
        tagBackgroundColor = Colors.transparent
    }
}

// MARK: TagListViewDelegate
extension SelectableTopicListView: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        toggleSelected(tagView: tagView)
        topicsDelegate?.topicPressed(title, topicView: tagView, sender: sender)
    }
}
