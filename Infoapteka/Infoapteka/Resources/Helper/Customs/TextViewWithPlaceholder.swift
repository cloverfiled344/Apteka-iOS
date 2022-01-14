//
//  TextViewWithPlaceholder.swift
//  Infoapteka
//
//  
//

import UIKit

class TextViewWithPlaceholder: UITextView {

    private let placeholderTextColor: UIColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
    private var showingPlaceholder: Bool = true
    private var placeholderText: String = ""

    override var text: String! {
        get { return showingPlaceholder ? "" : super.text }
        set {
            super.text = newValue
            self.newText = newValue ?? self.newText
        }
    }

    var newText: String = ""

    func setup(_ text: String, _ placeholderText: String) {
        self.placeholderText = placeholderText
        self.showingPlaceholder = text.isEmpty
        if self.showingPlaceholder {
            self.newText = text
        } else {
            self.text = text
        }
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        if text.isEmpty && (newText.isEmpty || placeholderText == newText) {
            showPlaceholderText()
        } else {
            textColor = .black
        }
    }

    override func becomeFirstResponder() -> Bool {
        if showingPlaceholder {
            text = nil
            textColor = .black
            showingPlaceholder = false
        }
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        if text.isEmpty && (self.newText.isEmpty || self.placeholderText == self.newText) {
            self.showPlaceholderText()
        } else {
            textColor = .black
        }
        return super.resignFirstResponder()
    }

    private func showPlaceholderText() {
        showingPlaceholder = true
        textColor = placeholderTextColor
        text = placeholderText
    }
}
