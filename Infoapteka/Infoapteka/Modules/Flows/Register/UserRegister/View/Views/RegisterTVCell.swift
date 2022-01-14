//
//  UserRegisterTVFooter.swift
//  Infoapteka
//
//  
//

import UIKit
import ActiveLabel

protocol RegisterTVCellDelegate {
    func register()
    func privacyPolicy()

}

// MARK: Appearance
extension RegisterTVCell {
    struct Appearance {
        let unSelectedCheckbox: UIImage = Asset.icUnselectedCheckbox.image
        let selectedCheckbox: UIImage = Asset.icSelectedCheckbox.image
        let checkBoxBtWidth: CGFloat = 20.0
        let checkBoxBtnLeftMargin: CGFloat = 20.0
        let checkBoxBtnBottomMargin: CGFloat = 40.0

        let programRulesTextColor: UIColor = Asset.secondaryGray.color
        let programRulesTextFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let programRulesText: String = L10n.programRules
        let programRulesSubText: String = "ознакомился(ась)"
        let titleLblLeftTopMargin: CGFloat = 12.0
        let titleLblRightMargin: CGFloat = 20.0

        let titleLblBottomMargin: CGFloat = 8.0
        let programRulesSubTextColor: UIColor = Asset.mainBlue.color

        let submitBtnWidth: CGFloat = Constants.screenWidth - 40
        let submitBtnnTitle: String = L10n.registerNow
        let submitBtnTitleFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let registerButtonTextColor: UIColor = Asset.mainWhite.color
        let registerButtonCornerRadius: CGFloat = 12.0
        let registerButtonBottomMargin: CGFloat = 32.0

        let privacyPolicyIsUserEnabled: Bool = true
    }
}

class RegisterTVCell: UITableViewCell {
    
    // MARK: UI Components
    private lazy var checkBoxBtn: CheckBoxBtn = {
        let view = CheckBoxBtn(appearance.selectedCheckbox,
                               appearance.unSelectedCheckbox)
        view.delegate = self
        return view
    }()
    
    lazy private var titleLbl: ActiveLabel = {
        let view = ActiveLabel()
        view.sizeToFit()

        view.numberOfLines = 0
        view.lineSpacing = 4
        view.text = "С \(appearance.programRulesText) \(appearance.programRulesSubText)"
        view.font =      appearance.programRulesTextFont
        view.textColor = appearance.programRulesTextColor

        let customType = ActiveType.custom(pattern: "\\\(appearance.programRulesText)\\b")
        view.enabledTypes.append(customType)

        view.customize { [weak self] label in
            label.customColor[customType] = appearance.programRulesSubTextColor
            label.handleCustomTap(for: customType) { [weak self] _ in
                self?.delegate?.privacyPolicy()
            }
        }
        return view
    }()
    
    private lazy var submitBtn: UIButton = {
        let view = UIButton()
        view.setTitleColor(appearance.registerButtonTextColor, for: .normal)
        view.layer.cornerRadius = appearance.registerButtonCornerRadius
        view.setTitle(appearance.submitBtnnTitle, for: .normal)
        view.titleLabel?.font = appearance.submitBtnTitleFont
        return view
    }()
    
    // MARK: Properties
    private let appearance = Appearance()
    var delegate: RegisterTVCellDelegate?
    
    // MARK: Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        self.setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup UI
private extension RegisterTVCell {
    
    private func setupUI() {
        self.contentView.addSubview(submitBtn)
        self.setSubmitBtnEnable(false)

        self.contentView.addSubview(checkBoxBtn)
        self.contentView.addSubview(titleLbl)
    }
    
    private func setConstraints() {
        self.submitBtn.addTarget(self, action: #selector(didTappedSubmitBtn), for: .touchUpInside)
        let submitBtnHeight = appearance.submitBtnWidth * 0.12
        self.submitBtn.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.submitBtnWidth)
            maker.height.equalTo(submitBtnHeight)
            maker.bottom.lessThanOrEqualTo(self.contentView.snp.bottom).offset(-appearance.registerButtonBottomMargin)
        }

        self.checkBoxBtn.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.contentView.snp.left).offset(appearance.checkBoxBtnLeftMargin)
            maker.width.height.equalTo(appearance.checkBoxBtWidth)
            maker.bottom.equalTo(self.submitBtn.snp.top).offset(-appearance.checkBoxBtnBottomMargin)
        }
        
        self.titleLbl.snp.remakeConstraints { (maker) in
            maker.centerY.equalTo(self.checkBoxBtn.snp.centerY)
            maker.left.equalTo(self.checkBoxBtn.snp.right).offset(appearance.titleLblLeftTopMargin)
            maker.right.equalTo(self.contentView.snp.right).offset(-appearance.titleLblRightMargin)
            maker.bottom.equalTo(self.submitBtn.snp.top).offset(-appearance.checkBoxBtnBottomMargin)
            maker.top.equalTo(self.contentView.snp.top).offset(appearance.titleLblLeftTopMargin)
        }
    }
    
    private func setSubmitBtnEnable(_ bool: Bool) {
        self.submitBtn.isEnabled = bool
        self.submitBtn.alpha = bool ? 1 : 0.6
        self.submitBtn.setTitleColor(bool ? Asset.mainWhite.color : Asset.secondaryGray.color, for: .normal)
        self.submitBtn.backgroundColor = bool ? Asset.mainGreen.color : Asset.secondaryGray.color.withAlphaComponent(0.5)
    }

    @objc private func didTappedSubmitBtn() {
        self.submitBtn.pulsate()
        self.delegate?.register()
    }
}


extension RegisterTVCell: CheckBoxBtnDelegate {
    func clicked(_ isChecked: Bool) {
        self.setSubmitBtnEnable(isChecked)
    }
}
