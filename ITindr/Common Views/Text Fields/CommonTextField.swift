//
//  CommonTextField.swift
//  ITindr
//
//  Created by Эдуард Логинов on 11.10.2021.
//

import UIKit

class CommonTextField: UITextField {
    
    // MARK: Properties
    var cornerRadius: CGFloat = 28
    var textInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    
    var placeholderColor: UIColor? = Colors.gray {
        didSet {
            setPlaceHolderColor(placeholderColor)
        }
    }
    
    var textFieldFont: UIFont? = UIFont.montserrat(.regular, size: 16) {
        didSet {
            setFont(textFieldFont)
        }
    }
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    // MARK: Public Methods
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    // MARK: Private Methods
    private func setupTextField() {
        backgroundColor = Colors.lightGray
        textColor = Colors.black
        placeholderColor = Colors.gray
        textFieldFont = .defaultLabel
        
        borderStyle = .none
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
    
    private func setPlaceHolderColor(_ color: UIColor?) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: color ?? UIColor.systemGray])
    }
    
    private func setFont(_ textFieldFont: UIFont?) {
        font = textFieldFont
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [NSAttributedString.Key.font: textFieldFont ?? UIFont.systemFont(ofSize: 16)])
    }
}
