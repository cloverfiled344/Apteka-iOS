//
//  PhoneNumberView.swift
//  Infoapteka
//
//

import UIKit
import PhoneNumberKit

protocol PhoneNumberViewDelegate {
    func deletePhone(_ phoneNumber: PhoneNumber)
}

struct PhoneNumber {
    var phone: String?
    var isValidNumber: Bool = false
    var id   : Int?
}

extension PhoneNumberView {
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

        let phoneNumberBottomLineBackgroundColor: UIColor = Asset.secondaryGray2.color
        let phoneNumberBottomLineBottomMargin: CGFloat = 16.0
        let phoneNumberBottomLineWidth: CGFloat = Constants.screenWidth - 40

        let removeBtnImage: UIImage = Asset.icRemove.image
        let removeBtnWidth: CGFloat = 20.0
    }
}

class PhoneNumberView: UIView {

    lazy private var phoneTitleLbl: UILabel = {
        let view = UILabel()
        view.font =      appearance.phoneTitleLblFont
        view.textColor = appearance.phoneTitleLblTextColor
        view.text =      appearance.phoneTitleLblText
        return view
    }()

    lazy private var phoneNumberKit: PhoneNumberKit = { PhoneNumberKit() }()
    lazy private var phoneNumberTF: PhoneNumberTextField = {
        let view = PhoneNumberTextField(withPhoneNumberKit: self.phoneNumberKit)
        view.withDefaultPickerUI = true
        view.withPrefix             = true
        view.withFlag               = true
        view.withExamplePlaceholder = true
        view.font = appearance.phoneNumberTFFont
        view.smartInsertDeleteType  = .yes
        view.textColor              = appearance.phoneNumberTFTextColor
        view.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        return view
    }()

    lazy private var phoneNumberBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.phoneNumberBottomLineBackgroundColor
        return view
    }()

    lazy private var removeBtn: UIButton = {
        let view = UIButton()
        view.setImage(appearance.removeBtnImage, for: .normal)
        view.alpha = 0
        return view
    }()

    // MARK: Properties
    private let appearance = Appearance()
    private var viewModel: CheckoutVM?
    private var phoneNumber: PhoneNumber? {
        didSet {
            guard let phoneNumber = phoneNumber else { return }
            phoneNumberTF.text = phoneNumber.phone
            phoneNumberTF.isEnabled = ((phoneNumber.id ?? 0) > 0 && phoneNumberTF.isValidNumber) ? true :  ((phoneNumber.id ?? 0) > 0 )
            removeBtn.alpha = (phoneNumber.id ?? 0) > 0 ? 1 : 0
            do {let phoneNumber = try phoneNumberKit.parse(phoneNumber.phone ?? "")
                phoneNumberTF.text = phoneNumberKit.format(phoneNumber, toType: .international)
                phoneNumberTF.updateFlag()
            } catch { print("Generic parser error")}
        }
    }
    var delegate: PhoneNumberViewDelegate?

    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }

    // MARK: -- public methods
    func setup(_ viewModel: CheckoutVM,
               _ phoneNumber: PhoneNumber,
               _ field: CheckoutField) {
        self.viewModel = viewModel
        self.phoneNumber = phoneNumber
        self.phoneTitleLbl.text = field.placeholder
    }

    @objc private func editingChanged() {
        guard phoneNumber != nil else { return }
        phoneNumber?.phone = phoneNumberTF.text
        phoneNumber?.isValidNumber = phoneNumberTF.isValidNumber
        viewModel?.setPhone(phoneNumber!)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup UI
extension PhoneNumberView {
    private func setupUI() {
        addSubview(phoneTitleLbl)
        addSubview(phoneNumberTF)
        addSubview(phoneNumberBottomLine)
        addSubview(removeBtn)
    }

    private func setConstraints() {
        setupPhoneNumberBottomLine()
    }

    fileprivate func setupPhoneNumberBottomLine() {
        phoneNumberBottomLine.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.phoneNumberBottomLineWidth)
            maker.height.equalTo(1.0)
            maker.bottom.equalTo(snp.bottom)
                .offset(-appearance.phoneNumberBottomLineBottomMargin)
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
        setupRemoveBtn()
    }

    fileprivate func setupPhoneTitleLblMaking() {
        phoneTitleLbl.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(snp.top)
            maker.width.equalTo(appearance.phoneTitleWidth)
            maker.bottom.equalTo(phoneNumberTF.snp.top).offset(-appearance.phoneTitleBottomMargin)
        }
    }

    fileprivate func setupRemoveBtn() {
        removeBtn.addTarget(self, action: #selector(didTappedRemoveBtn), for: .touchUpInside)
        removeBtn.snp.remakeConstraints { make in
            make.right.equalTo(snp.right).offset(-20.0)
            make.height.width.equalTo(20.0)
            make.centerY.equalTo(phoneNumberTF.snp.centerY)
        }
    }

    @objc fileprivate func didTappedRemoveBtn() {
        removeBtn.pulsate()
        guard let phoneNumber = phoneNumber else { return }
        delegate?.deletePhone(phoneNumber)
    }
}
