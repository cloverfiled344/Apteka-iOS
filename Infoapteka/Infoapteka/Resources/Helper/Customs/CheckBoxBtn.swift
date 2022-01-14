//
//  CheckBoxBtn.swift
//  Infoapteka
//
//  
//

import UIKit

protocol CheckBoxBtnDelegate {
    func clicked(_ isChecked: Bool)
}

class CheckBoxBtn: UIButton {

    private var checkedIcon    : UIImage
    private var uncheckedIcon  :  UIImage
    var delegate: CheckBoxBtnDelegate?

    init(_ checkedIcon: UIImage,
         _ uncheckedIcon: UIImage) {
        self.checkedIcon = checkedIcon
        self.uncheckedIcon = uncheckedIcon
        super.init(frame: .zero)

        self.addTarget(self,
                       action: #selector(clicked),
                       for: .touchUpInside)
        self.setImage(uncheckedIcon,
                      for: .normal)
        self.isChecked = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Bool property
    var isChecked: Bool = false {
        didSet {
            self.setImage(isChecked ? checkedIcon : uncheckedIcon,
                          for: UIControl.State.normal)
        }
    }

    @objc private func clicked() {
        self.pulsate()
        self.isChecked = !self.isChecked
        self.delegate?.clicked(self.isChecked)
    }
}
