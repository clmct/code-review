//
//  MessagesTableView.swift
//  ITindr
//
//  Created by Эдуард Логинов on 29.10.2021.
//

import UIKit

class MessagesTableView: UITableView {
    
    // MARK: Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Keyboard Actions
    @objc private func keyboardWillShow(_ notification: Notification) {
        adjustContentForKeyboard(shown: true, notification: notification)
    }
     
    @objc private func keyboardWillHide(_ notification: Notification) {
        adjustContentForKeyboard(shown: false, notification: notification)
    }
    
    // MARK: Private Setup Methods
    private func setup() {
        backgroundColor = Colors.white
        separatorStyle = .none
        tableHeaderView = UIView()
        registerKeyboardNotifications()
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
     
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
     
    private func adjustContentForKeyboard(shown: Bool, notification: Notification) {
        guard let payload = KeyboardInfo(notification) else { return }
     
        let keyboardHeight = shown ? payload.frameEnd?.size.height : bounds.size.height
        var insets = contentInset
        insets.bottom = keyboardHeight ?? 0
     
        UIView.animate(
            withDuration: payload.animationDuration ?? 0,
            delay: 0,
            options: payload.animationCurve ?? UIView.AnimationOptions.curveEaseOut) { [weak self] in
            self?.contentInset = insets
            self?.scrollIndicatorInsets = insets
        }
    }
}
