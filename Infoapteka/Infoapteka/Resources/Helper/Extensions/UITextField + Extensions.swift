//
//  UITextField + Extensions.swift
//  Infoapteka
//
//  
//

import UIKit

extension UITextField {
    
    func changePlaceholderStyle(and placeholder: String, and color: UIColor, and font: UIFont) {
        let attributes = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: font
        ]
        self.attributedPlaceholder = .init(string: placeholder, attributes: attributes)
    }

    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
