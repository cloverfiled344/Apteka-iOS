//
//  InputMaskTextField.swift
//  Infoapteka
//
//

import UIKit
import InputMask

protocol InputMaskTextFieldDelegate {
    func textChanged(_ isValid: Bool, _ text: String)
}

class InputMaskTextField: UITextField, UITextFieldDelegate, MaskedTextFieldDelegateListener {

    private var maskedDelegate: MaskedTextFieldDelegate!
    var inputMaskDelegate: InputMaskTextFieldDelegate?

    init(_ format: String) {
        super.init(frame: .zero)
        self.setupMaskForTextField(format)
    }

    fileprivate func setupMaskForTextField(_ format: String) {
        self.delegate = self
        self.maskedDelegate = MaskedTextFieldDelegate(primaryFormat: format,
                                                      autocomplete: true,
                                                      autocompleteOnFocus: true,
                                                      autoskip: true,
                                                      rightToLeft: false,
                                                      affineFormats: [format],
                                                      affinityCalculationStrategy: .prefix,
                                                      customNotations: [],
                                                      onMaskedTextChangedCallback: { (input, str, bool) in
                                                        self.inputMaskDelegate?.textChanged(bool, str)
                                                      })
        self.maskedDelegate.listener = self
        self.delegate = self.maskedDelegate
    }

    deinit {
        self.maskedDelegate = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
