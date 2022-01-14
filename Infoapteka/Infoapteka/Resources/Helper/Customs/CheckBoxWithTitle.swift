//
//  CheckBoxWithTitle.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK: Appearance
extension CheckBoxWithTitle {
    struct Appearance {
        let unSelectedCheckbox: UIImage = Asset.icUnselectedRadioButton.image
        let selectedCheckbox: UIImage = Asset.icSelectedRadioButton.image

        let checkBoxBtWidth: CGFloat = 20.0
        let checkBoxBtnLeftMargin: CGFloat = 20.0

        let titleLblTextColor: UIColor = Asset.mainBlack.color
        let titleLblFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let titleLblLeftMargin: CGFloat = 12.0
        let titleLblRightMargin: CGFloat = 20.0
    }
}

protocol CheckBoxWithTitleDelegate {
    func didTappedCheckBoxBtn()
}

class CheckBoxWithTitle: UIView {

    private lazy var checkBoxBtn: CheckBoxBtn = {
        let view = CheckBoxBtn(appearance.selectedCheckbox,
                               appearance.unSelectedCheckbox)
        view.isUserInteractionEnabled = false
        return view
    }()
    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.font = appearance.titleLblFont
        view.textColor = appearance.titleLblTextColor
        return view
    }()

    private var appearance = Appearance()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(checkBoxBtn)
        checkBoxBtn.snp.remakeConstraints { make in
            make.left.equalTo(snp.left).offset(appearance.checkBoxBtnLeftMargin)
            make.width.height.equalTo(appearance.checkBoxBtWidth)
            make.centerY.equalTo(snp.centerY)
        }

        addSubview(titleLbl)
        titleLbl.snp.remakeConstraints { make in
            make.left.equalTo(checkBoxBtn.snp.right).offset(appearance.titleLblLeftMargin)
            make.right.equalToSuperview().offset(-appearance.titleLblRightMargin)
            make.centerY.equalTo(checkBoxBtn.snp.centerY)
        }
    }

    func setup(_ isChecked: Bool, _ title: String) {
        checkBoxBtn.isChecked = isChecked
        titleLbl.text = title
    }

    var isChecked: Bool {
        set { checkBoxBtn.isChecked = newValue }
        get { return checkBoxBtn.isChecked }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
