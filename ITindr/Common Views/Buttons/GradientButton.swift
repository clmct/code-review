//
//  GradientButton.swift
//  ITindr
//
//  Created by Эдуард Логинов on 10.10.2021.
//

import UIKit

class GradientButton: SolidButton {
    
    // MARK: Properties
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [
            Colors.pink?.cgColor ?? UIColor.systemPink.cgColor,
            Colors.violet?.cgColor ?? UIColor.purple.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradient, at: 0)
        
        return gradient
    }()
    
    // MARK: Init
    override init(_ title: String?, icon: UIImage? = nil, contentColor: UIColor? = Colors.white) {
        super.init(title, icon: icon, contentColor: contentColor)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tintColor = Colors.white
        setTitleColor(Colors.white, for: .normal)
    }
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.frame = bounds
    }
}
