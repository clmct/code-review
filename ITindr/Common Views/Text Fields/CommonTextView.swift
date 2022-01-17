//
//  CommonTextView.swift
//  ITindr
//
//  Created by Эдуард Логинов on 11.10.2021.
//

import UIKit

protocol CommonTextViewDelegate {
    func textViewDidChange(_ textView: CommonTextView)
}

class CommonTextView: UITextView {
    
    // MARK: Properties
    var changedTextDelegate: CommonTextViewDelegate?
    
    var placeholder: String? = Strings.aboutPlaceholder {
        didSet {
            setText(inputText)
        }
    }
    
    var cornerRadius: CGFloat = 28 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    var textInsets = UIEdgeInsets(top: 18, left: 24, bottom: 0, right: 24) {
        didSet {
            textContainerInset = textInsets
        }
    }
    
    var textFieldFont: UIFont? = .defaultLabel {
        didSet {
            font = textFieldFont
        }
    }
    
    var inputText: String? {
        didSet {
            setText(inputText)
        }
    }
    
    // MARK: Init
    init() {
        super.init(frame: .zero, textContainer: nil)
        delegate = self
        
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
        
        setupTextField()
    }
    
    // MARK: Private Methods
    private func setupTextField() {
        inputText = nil
        textContainerInset = textInsets
        
        backgroundColor = Colors.lightGray
        textColor = Colors.gray
        textFieldFont = .defaultLabel
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
    
    private func setText(_ text: String?) {
        if let text = text {
            self.text = text
            textColor = Colors.black
        } else {
            self.text = placeholder
            textColor = Colors.gray
        }
    }
}

// MARK: UITextViewDelegate
extension CommonTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if inputText == nil {
            textView.text = nil
            textView.textColor = Colors.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            inputText = nil
        } else {
            inputText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        inputText = textView.text
        changedTextDelegate?.textViewDidChange(self)
    }
}
