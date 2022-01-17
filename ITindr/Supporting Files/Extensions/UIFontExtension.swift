//
//  UIFontExtension.swift
//  ITindr
//
//  Created by Эдуард Логинов on 10.10.2021.
//

import UIKit

extension UIFont {
    public enum FontType: String {
        case semibold = "-SemiBold"
        case regular = "-Regular"
        case medium = "-Medium"
        case bold = "-Bold"
    }

    static func montserrat(_ type: FontType = .regular, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "Montserrat\(type.rawValue)", size: size)!
    }
}

// MARK: Constants
extension UIFont {
    static let smallerLabelMedium = UIFont.montserrat(.medium, size: 10)
    
    static let smallLabel = UIFont.montserrat(.regular, size: 12)
    
    static let defaultLabel = UIFont.montserrat(.regular, size: 16)
    static let defaultLabelBold = UIFont.montserrat(.bold, size: 16)
    
    static let mediumLabel = UIFont.montserrat(.regular, size: 18)
    static let mediumLabelSemibold = UIFont.montserrat(.semibold, size: 18)
    static let mediumLabelBold = UIFont.montserrat(.bold, size: 18)
    
    static let largeLabelBold = UIFont.montserrat(.bold, size: 24)
    
    static let largerLabelBold = UIFont.montserrat(.bold, size: 28)
}
