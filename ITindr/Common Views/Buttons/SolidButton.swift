//
//  DefaultButton.swift
//  ITindr
//
//  Created by Эдуард Логинов on 10.10.2021.
//

import UIKit

class SolidButton: UIButton {
    
    // MARK: Properties
    var cornerRadius: CGFloat = 28 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // MARK: Init
    init(_ title: String?, icon: UIImage? = nil, contentColor: UIColor? = Colors.pink) {
        super.init(frame: .zero)
        tintColor = contentColor
        setTitleColor(contentColor, for: .normal)
        setTitle(title, for: .normal)
        setImage(icon, for: .normal)
        setupButtonStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tintColor = Colors.pink
        setTitleColor(Colors.pink, for: .normal)
        setupButtonStyle()
    }
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        cornerRadius = frame.height / 2
    }
    
    // MARK: Private Methods
    private func setupButtonStyle() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = Colors.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 24
        layer.shadowOffset = CGSize(width: 0, height: 4)
        
        titleLabel?.font = .defaultLabelBold
        backgroundColor = Colors.white
        
        if (imageView?.image != nil && currentTitle != nil) {
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        }
    }
}
