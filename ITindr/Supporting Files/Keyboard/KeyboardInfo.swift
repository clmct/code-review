//
//  KeyboardInfo.swift
//  ITindr
//
//  Created by Эдуард Логинов on 27.11.2021.
//

import UIKit

struct KeyboardInfo {
    // MARK: Properties
    var animationCurve: UIView.AnimationOptions?
    var animationDuration: Double?
    var isLocal: Bool?
    var frameBegin: CGRect?
    var frameEnd: CGRect?
    
    // MARK: Init
    init?(_ notification: Notification) {
        guard notification.name == UIResponder.keyboardWillShowNotification ||
                notification.name == UIResponder.keyboardWillChangeFrameNotification else { return nil }
        guard let info = notification.userInfo else { return nil }

        animationCurve = info[UIWindow.keyboardAnimationCurveUserInfoKey] as? UIView.AnimationOptions
        animationDuration = info[UIWindow.keyboardAnimationDurationUserInfoKey] as? Double
        isLocal = info[UIWindow.keyboardIsLocalUserInfoKey] as? Bool
        frameBegin = info[UIWindow.keyboardFrameBeginUserInfoKey] as? CGRect
        frameEnd = info[UIWindow.keyboardFrameEndUserInfoKey] as? CGRect
    }
}
