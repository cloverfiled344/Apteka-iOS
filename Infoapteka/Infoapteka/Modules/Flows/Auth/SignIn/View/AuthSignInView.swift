//
//  SignInView.swift
//  Infoapteka
//
//

import UIKit
import PhoneNumberKit
import FirebaseAuth

protocol AuthSignInViewDelegate {
    func didTappedLoginBtn(_ phoneNumber: String, complation: @escaping () -> ())
}

extension AuthSignInView {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color

        let appLogoImage: UIImage = Asset.icLaunch.image
        let appLogoContentMode: UIView.ContentMode = .scaleAspectFill
        let appLogoMasksToBounds: Bool = true
        let appLogoBackgroundColor: UIColor = Asset.mainWhite.color

        let largeTitleLblText = L10n.signIn
        let largeTitleLblTextColor: UIColor = Asset.mainBlack.color
        let largeTitleLblFont: UIFont = FontFamily.Inter.bold.font(size: 24)
        let largeTitleLblWidth: CGFloat = Constants.screenWidth - 40
        let largeTitleLblBottomMargin: CGFloat = 8.0

        let subtitleText: String = "\(L10n.dontHaveAnAccount)  \(L10n.registration)"
        let subtitleLblTextColor: UIColor = Asset.secondaryGray.color
        let subtitleLblFont: UIFont = FontFamily.Inter.medium.font(size: 15)
        let subtitleCustomText: String = L10n.registration
        let subtitleLblCustomColor: UIColor = Asset.mainGreen.color
        let subtitleLblWidth: CGFloat = Constants.screenWidth - 40
        let subtitleLblBottomMargin: CGFloat = 32.0

        let phoneTitleLblText = L10n.phoneNumber
        let phoneTitleLblTextColor: UIColor = Asset.secondaryGray3.color
        let phoneTitleLblFont: UIFont = FontFamily.Inter.semiBold.font(size: 13)
        let phoneTitleWidth: CGFloat = Constants.screenWidth - 40
        let phoneTitleBottomMargin: CGFloat = 4.0

        let phoneNumberTFWidth: CGFloat = Constants.screenWidth - 40
        let phoneNumberTFTextColor: UIColor = Asset.mainBlack.color
        let phoneNumberTFHeight: CGFloat = 34
        let phoneNumberWidth: CGFloat = Constants.screenWidth - 40

        let phoneErrorTitleLblText = L10n.enteredIncorrectPhoneNumber
        let phoneErrorTitleLblTextColor: UIColor = Asset.secondaryRed.color
        let phoneErrorTitleLblFont: UIFont = FontFamily.Inter.regular.font(size: 13)
        let phoneErrorTitleWidth: CGFloat = Constants.screenWidth - 40
        let phoneErrorTitleTopMargin: CGFloat = 4.0

        let phoneNumberBottomLineBackgroundColor: UIColor = Asset.secondaryGray2.color
        let phoneNumberBottomLineBottomMargin: CGFloat = 42.0
        let phoneNumberBottomLineWidth: CGFloat = Constants.screenWidth - 40

        let loginBtnTitleLblText = L10n.login
        let loginBtnTitleLblActiveTextColor: UIColor = Asset.mainWhite.color
        let loginBtnTitleLblInActiveTextColor: UIColor = Asset.mainWhite.color.withAlphaComponent(0.5)
        let loginBtnTitleLblFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let loginBtnWidth: CGFloat = Constants.screenWidth - 40
        let loginActiveColor: UIColor = Asset.mainGreen.color
        let loginInActiveColor: UIColor = Asset.secondaryGray.color.withAlphaComponent(0.5)
    }
}


class AuthSignInView: UIView {

    lazy private var appLogoIV: UIImageView = {
        let view = UIImageView()
        view.image = appearance.appLogoImage
        view.contentMode = appearance.appLogoContentMode
        view.layer.masksToBounds = appearance.appLogoMasksToBounds
        view.backgroundColor = appearance.appLogoBackgroundColor
        view.alpha = 0
        return view
    }()
    
    lazy private var largeTitleLbl: UILabel = {
        let view = UILabel()
        view.font =      appearance.largeTitleLblFont
        view.textColor = appearance.largeTitleLblTextColor
        view.text =      appearance.largeTitleLblText
        return view
    }()

    lazy private var phoneTitleLbl: UILabel = {
        let view = UILabel()
        view.font =      appearance.phoneTitleLblFont
        view.textColor = appearance.phoneTitleLblTextColor
        view.text =      appearance.phoneTitleLblText
        return view
    }()

    lazy private var phoneNumberTF: PhoneNumberTextField = {
        let view = PhoneNumberTextField()
        view.withDefaultPickerUI = true
        view.withPrefix             = true
        view.withFlag               = true
        view.withExamplePlaceholder = true
        view.smartInsertDeleteType  = .yes
        view.textColor              = appearance.phoneNumberTFTextColor
        view.addTarget(self, action: #selector(didChangedPhoneValue), for: .allEvents)
        return view
    }()

    lazy private var phoneNumberBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.phoneNumberBottomLineBackgroundColor
        return view
    }()

    lazy private var loginBtn: UIButton = {
        let view = UIButton()
        view.isEnabled = false
        view.titleLabel?.font = appearance.loginBtnTitleLblFont
        view.setTitleColor(appearance.loginBtnTitleLblInActiveTextColor, for: .normal)
        view.setTitle(appearance.loginBtnTitleLblText, for: .normal)
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        view.titleLabel?.minimumScaleFactor = 0.5
        view.titleLabel?.lineBreakMode = .byClipping
        view.backgroundColor = appearance.loginInActiveColor
        return view
    }()

    private let appearance = Appearance()
    private var delegate: AuthSignInViewDelegate

    init(_ delegate: AuthSignInViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)

        self.backgroundColor = appearance.backgroundColor
        self.setupUI()
    }

    fileprivate func setupUI() {
        self.addSubview(self.loginBtn)
        self.addSubview(self.phoneNumberBottomLine)
        self.addSubview(self.phoneNumberTF)
        self.addSubview(self.phoneTitleLbl)
        self.addSubview(self.largeTitleLbl)
        self.addSubview(self.appLogoIV)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.setupMaking()
    }

    fileprivate func setupMaking() {
        self.setupLoginBtnMaking()
    }

    fileprivate func setupLoginBtnMaking() {
        self.loginBtn.addTarget(self, action: #selector(didTappedLoginBtn), for: .touchUpInside)
        let loginBtnHeight = appearance.loginBtnWidth * 0.14
        self.loginBtn.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.loginBtnWidth)
            maker.height.equalTo(loginBtnHeight)
            maker.bottom.equalTo(self.snp.bottom)
        }
        self.loginBtn.layer.cornerRadius = loginBtnHeight * 0.2

        self.setupPhoneNumberBottomLine()
    }

    fileprivate func setupPhoneNumberBottomLine() {
        self.phoneNumberBottomLine.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.phoneNumberBottomLineWidth)
            maker.height.equalTo(1)
            maker.bottom.equalTo(self.loginBtn.snp.top).offset(-appearance.phoneNumberBottomLineBottomMargin)
        }

        self.setupPhoneNumberTFMaking()
    }

    fileprivate func setupPhoneNumberTFMaking() {
        self.phoneNumberTF.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.phoneNumberWidth)
            maker.height.equalTo(appearance.phoneNumberTFHeight)
            maker.bottom.equalTo(self.phoneNumberBottomLine.snp.top)
        }

        self.setupPhoneTitleLblMaking()
    }

    fileprivate func setupPhoneTitleLblMaking() {
        self.phoneTitleLbl.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.phoneTitleWidth)
            maker.bottom.equalTo(self.phoneNumberTF.snp.top).offset(-appearance.phoneTitleBottomMargin)
        }

        self.setupLargeTitleLblMaking()
    }

    fileprivate func setupLargeTitleLblMaking() {
        self.largeTitleLbl.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.largeTitleLblWidth)
            maker.bottom.equalTo(self.phoneTitleLbl.snp.top).offset(-appearance.largeTitleLblBottomMargin)
        }

        self.setupAppLogoIVMaking()
    }

    fileprivate func setupAppLogoIVMaking() {
        let appLogoHeight: CGFloat = Constants.screenWidth / 2
        self.appLogoIV.snp.remakeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.height.width.equalTo(appLogoHeight)
            make.bottom.equalTo(self.largeTitleLbl.snp.top).offset(-(appLogoHeight/2))
        }

        self.beginAlphaAnimation()
    }

    private func beginAlphaAnimation() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.appLogoIV.alpha = 1
                       })
    }

    private func setLoginBtnEnable(_ bool: Bool) {
//        self.phoneTitleLbl.textColor = bool ? appearance.phoneTitleLblTextColor : appearance.phoneErrorTitleLblTextColor
        self.loginBtn.isEnabled = bool
        self.loginBtn.backgroundColor = bool ? appearance.loginActiveColor : appearance.loginInActiveColor
        self.loginBtn.setTitleColor(bool ? appearance.loginBtnTitleLblActiveTextColor : appearance.loginBtnTitleLblInActiveTextColor, for: .normal)
    }

    @objc private func didChangedPhoneValue() {
        self.setLoginBtnEnable(self.phoneNumberTF.isValidNumber)
    }

    @objc private func didTappedLoginBtn() {
        self.loginBtn.pulsate()
        guard let phoneNumber = self.phoneNumberTF.text, !phoneNumber.isEmpty, phoneNumberTF.isValidNumber else {
            self.setLoginBtnEnable(false)
            return
        }
        self.endEditing(true)
        self.loginBtn.isEnabled = false
        self.loginBtn.backgroundColor = appearance.loginInActiveColor
        self.loginBtn.setTitleColor(appearance.loginBtnTitleLblInActiveTextColor, for: .normal)

//        Auth.auth().languageCode = self.phoneNumberTF.currentRegion.lowercased()
        self.delegate.didTappedLoginBtn(phoneNumber) { [weak self] in
            guard let self = self else { return }
            self.setLoginBtnEnable(true)
        }
    }

    //MARK: -- deinit
    deinit {
        self.phoneNumberTF.endEditing(true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
    lazy private var subtitleLbl: ActiveLabel = {
        let view = ActiveLabel()
        view.text = appearance.subtitleText
        view.font =      appearance.subtitleLblFont
        view.textColor = appearance.subtitleLblTextColor
        let customType = ActiveType.custom(pattern: "\\\(appearance.subtitleCustomText)\\b")
        view.enabledTypes.append(customType)
        view.customize { label in
            label.customColor[customType] = Asset.mainGreen.color
            label.handleCustomTap(for: customType) { [weak self] _ in
                self?.delegate.didTappedRegisterLbl()
            }
        }
        return view
    }()
        self.addSubview(self.subtitleLbl)
        self.setupSubtitleLblMaking()
    fileprivate func setupSubtitleLblMaking() {
        self.subtitleLbl.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.largeTitleLblWidth)
            maker.bottom.equalTo(self.phoneTitleLbl.snp.top).offset(-appearance.subtitleLblBottomMargin)
        }

        self.setupLargeTitleLblMaking()
    }
*/
