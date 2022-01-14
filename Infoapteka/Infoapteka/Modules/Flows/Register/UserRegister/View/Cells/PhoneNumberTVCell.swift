//
//  PhoneNumberTVCell.swift
//  Infoapteka
//
//  
//

import UIKit
import PhoneNumberKit

extension PhoneNumberTVCell {
    struct Appearance {
        let cellSelectioStyle: UITableViewCell.SelectionStyle = .none

        let phoneTitleLblText = L10n.phoneNumber
        let phoneTitleLblTextColor: UIColor = Asset.secondaryGray3.color
        let phoneTitleLblFont: UIFont = FontFamily.Inter.semiBold.font(size: 13)
        let phoneTitleWidth: CGFloat = Constants.screenWidth - 40
        let phoneTitleBottomMargin: CGFloat = 4.0

        let phoneNumberTFWidth: CGFloat = Constants.screenWidth - 40
        let phoneNumberTFTextColor: UIColor = Asset.mainBlack.color
        let phoneNumberTFFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let phoneNumberTFHeight: CGFloat = 34
        let phoneNumberWidth: CGFloat = Constants.screenWidth - 40

        let phoneErrorTitleLblText = L10n.enteredIncorrectPhoneNumber
        let phoneErrorTitleLblTextColor: UIColor = Asset.secondaryRed.color
        let phoneErrorTitleLblFont: UIFont = FontFamily.Inter.regular.font(size: 13)
        let phoneErrorTitleWidth: CGFloat = Constants.screenWidth - 40
        let phoneErrorTitleTopMargin: CGFloat = 4.0

        let phoneNumberBottomLineBackgroundColor: UIColor = Asset.secondaryGray2.color
        let phoneNumberBottomLineBottomMargin: CGFloat = 32.0
        let phoneNumberBottomLineWidth: CGFloat = Constants.screenWidth - 40
    }
}

class PhoneNumberTVCell: UITableViewCell {

    lazy private var phoneTitleLbl: UILabel = {
        let view = UILabel()
        view.font =      appearance.phoneTitleLblFont
        view.textColor = appearance.phoneTitleLblTextColor
        view.text =      appearance.phoneTitleLblText
        return view
    }()

    lazy private var phoneNumberKit: PhoneNumberKit = {
        let kit = PhoneNumberKit()
        return kit
    }()

    lazy private var phoneNumberTF: PhoneNumberTextField = {
        let view = PhoneNumberTextField(withPhoneNumberKit: self.phoneNumberKit)
        view.isEnabled = false
        view.withDefaultPickerUI = true
        view.withPrefix             = true
        view.withFlag               = true
        view.withExamplePlaceholder = true
        view.font = appearance.phoneNumberTFFont
        view.smartInsertDeleteType  = .yes
        view.textColor              = appearance.phoneNumberTFTextColor
        view.addTarget(self, action: #selector(didChangedPhoneValue), for: .allEvents)
        return view
    }()

    lazy private var phoneErrorLbl: UILabel = {
        let view = UILabel()
        view.font =      appearance.phoneErrorTitleLblFont
        view.textColor = appearance.phoneErrorTitleLblTextColor
        view.text =      appearance.phoneErrorTitleLblText
        view.alpha = 0
        return view
    }()

    lazy private var phoneNumberBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.phoneNumberBottomLineBackgroundColor
        return view
    }()
    
    // MARK: Properties
    private let appearance = Appearance()

    // MARK: Initialize
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)

        self.setupUI()
    }

    @objc private func didChangedPhoneValue() {
        self.phoneErrorLbl.alpha = self.phoneNumberTF.isValidNumber ? 0 : 1
        self.phoneTitleLbl.textColor = self.phoneNumberTF.isValidNumber ? appearance.phoneTitleLblTextColor : appearance.phoneErrorTitleLblTextColor
    }

    // MARK: -- public methods
    func setFieid(_ field: RegisterField) {
        self.phoneTitleLbl.text = field.type.rawValue
        do {
            let phoneNumber = try phoneNumberKit.parse((field.value as? String) ?? "")
            phoneNumberTF.text = phoneNumberKit.format(phoneNumber, toType: .international)
            phoneNumberTF.updateFlag()
        }
        catch {
            print("Generic parser error")
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup UI
extension PhoneNumberTVCell {

    private func setupUI() {
        selectionStyle = appearance.cellSelectioStyle

        contentView.addSubview(phoneTitleLbl)
        contentView.addSubview(phoneNumberTF)
        contentView.addSubview(phoneErrorLbl)
        contentView.addSubview(phoneNumberBottomLine)

        setConstraints()
    }

    private func setConstraints() {
        setupPhoneNumberBottomLine()
    }

    fileprivate func setupPhoneNumberBottomLine() {
        phoneNumberBottomLine.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.phoneNumberBottomLineWidth)
            maker.height.equalTo(1.0)
            maker.bottom.equalTo(contentView.snp.bottom)
                .offset(-appearance.phoneNumberBottomLineBottomMargin)
        }

        setupPhoneErrorLblMaking()
    }

    fileprivate func setupPhoneErrorLblMaking() {
        phoneErrorLbl.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.phoneNumberBottomLineWidth)
            maker.top.equalTo(phoneNumberBottomLine.snp.bottom)
        }

        setupPhoneNumberTFMaking()
    }

    fileprivate func setupPhoneNumberTFMaking() {
        phoneNumberTF.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.phoneNumberWidth)
            maker.height.equalTo(appearance.phoneNumberTFHeight)
            maker.bottom.equalTo(phoneNumberBottomLine.snp.top)
        }

        setupPhoneTitleLblMaking()
    }

    fileprivate func setupPhoneTitleLblMaking() {
        phoneTitleLbl.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(contentView.snp.top)
            maker.width.equalTo(appearance.phoneTitleWidth)
            maker.bottom.equalTo(phoneNumberTF.snp.top).offset(-appearance.phoneTitleBottomMargin)
        }
    }
}

