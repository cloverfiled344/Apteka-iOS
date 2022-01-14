//
//  AuthCodeConfirmView.swift
//  Infoapteka
//
//

import UIKit
import ActiveLabel

protocol AuthCodeConfirmViewDelegate: AnyObject {
    func didTappedConfirmBtn(_ verificationCode: String, complation: @escaping () -> ())
    func didTappedIncorrectNumberLbl()
    func didTappedTrySendSms()
}

extension AuthCodeConfirmView {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color

        let largeTitleLblText = L10n.confirmCode
        let largeTitleLblTextColor: UIColor = Asset.mainBlack.color
        let largeTitleLblFont: UIFont = FontFamily.Inter.bold.font(size: 24)
        let largeTitleLblWidth: CGFloat = Constants.screenWidth - 40
        let largeTitleLblBottomMargin: CGFloat = 32.0

        let subtitleLblTextColor: UIColor = Asset.mainBlack.color
        let subtitleLblFont: UIFont = FontFamily.Inter.medium.font(size: 15)
        let subtitleCustomText: String = L10n.incorrectPhoneNumber
        let subtitleLblCustomColor: UIColor = Asset.mainGreen.color
        let subtitleLblWidth: CGFloat = Constants.screenWidth - 40
        let subtitleLblBottomMargin: CGFloat = 32.0

        let codeTitleLblText = L10n.phoneNumber
        let codeTitleLblTextColor: UIColor = Asset.secondaryGray3.color
        let codeTitleLblFont: UIFont = FontFamily.Inter.semiBold.font(size: 13)
        let codeTitleWidth: CGFloat = Constants.screenWidth - 40
        let codeTitleBottomMargin: CGFloat = 4.0

        let codeTFWidth: CGFloat = Constants.screenWidth - 40
        let codeTFTextColor: UIColor = Asset.mainBlack.color
        let codeTFHeight: CGFloat = 34
        let codeTFFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let codeTFFormat: String = "[000] [000]"
        let codeTFPlaceholder: String = L10n.enterCode

        let codeTFBottomLineBackgroundColor: UIColor = Asset.secondaryGray2.color
        let codeTFBottomLineBottomMargin: CGFloat = 42.0
        let codeTFBottomLineWidth: CGFloat = Constants.screenWidth - 40

        let confirmBtnTitleLblText = L10n.login
        let confirmBtnTitleLblActiveTextColor: UIColor = Asset.mainWhite.color
        let confirmBtnTitleLblInActiveTextColor: UIColor = Asset.mainWhite.color.withAlphaComponent(0.5)
        let confirmBtnTitleLblFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let confirmBtnWidth: CGFloat = Constants.screenWidth - 40
        let confirmBtnBottomMargin: CGFloat = 30.0
        let confirmActiveColor: UIColor = Asset.mainGreen.color
        let confirmInActiveColor: UIColor = Asset.secondaryGray.color.withAlphaComponent(0.5)

        let codeInfoLblTextColor: UIColor = Asset.secondaryGray.color
        let codeInfoLblFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let codeInfoLblTextAlignment: NSTextAlignment = .center
        let codeInfoLblText: String = L10n.codeInfoLbl
        let codeInfoLblWidth: CGFloat = Constants.screenWidth - 40
        let codeInfoLblBottomMargin: CGFloat = 6.0

        let trySendInCode: Int = 59
        let trySendBtnWidth: CGFloat = Constants.screenWidth - 40
        let trySendCodeBtnTitle: String = L10n.trySend
        let trySendCodeBtnSendTitle: String = L10n.send
        let trySendCodeBtnFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let activeTrySendCodeBtnTitleColor: UIColor = Asset.mainWhite.color
        let inactiveTSendCodeBtnTitleColor: UIColor = Asset.secondaryGray.color.withAlphaComponent(0.5)
        let trySendBtnActiveColor: UIColor = Asset.secondaryGray.color
        let trySendBtnInActiveColor: UIColor = .clear
        let trySendCodeBtnBorderColor: CGColor = Asset.secondaryGray.color.cgColor
        let trySendCodeBtnBorderWidth: CGFloat = 1.0
    }
}

class AuthCodeConfirmView: UIView {

    //MARK: -- UI Properties
    lazy private var largeTitleLbl: UILabel = {
        let view = UILabel()
        view.font =      appearance.largeTitleLblFont
        view.textColor = appearance.largeTitleLblTextColor
        view.text =      appearance.largeTitleLblText
        view.numberOfLines = 3
        return view
    }()

    lazy private var subtitleLbl: ActiveLabel = {
        let view = ActiveLabel()
        view.numberOfLines = 0
        view.lineSpacing = 4
        view.text = "\(phoneNumber)  \n\(appearance.subtitleCustomText)"
        view.font =      appearance.subtitleLblFont
        view.textColor = appearance.subtitleLblTextColor
        let customType = ActiveType.custom(pattern: "\\\(appearance.subtitleCustomText)\\b")
        view.enabledTypes.append(customType)
        view.customize { [weak self] label in
            label.customColor[customType] = Asset.mainGreen.color
            label.handleCustomTap(for: customType) { [weak self] _ in
                self?.delegate?.didTappedIncorrectNumberLbl()
            }
        }
        return view
    }()

    lazy private var codeTFTitleLbl: UILabel = {
        let view = UILabel()
        view.font =      appearance.codeTitleLblFont
        view.textColor = appearance.codeTitleLblTextColor
        view.text =      appearance.codeTitleLblText
        return view
    }()

    lazy private var codeTF: InputMaskTextField = {
        let view = InputMaskTextField(appearance.codeTFFormat)
        view.placeholder = appearance.codeTFPlaceholder
        view.textColor = appearance.codeTFTextColor
        view.font = appearance.codeTFFont
        view.keyboardType = .numberPad
        return view
    }()

    lazy private var codeTFBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.codeTFBottomLineBackgroundColor
        return view
    }()

    lazy private var codeConfirmBtn: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = appearance.confirmBtnTitleLblFont
        view.setTitleColor(appearance.confirmBtnTitleLblInActiveTextColor, for: .normal)
        view.setTitle(appearance.confirmBtnTitleLblText, for: .normal)
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        view.titleLabel?.minimumScaleFactor = 0.5
        view.titleLabel?.lineBreakMode = .byClipping
        view.backgroundColor = appearance.confirmInActiveColor
        return view
    }()

    lazy private var codeInfoLbl: UILabel = {
        let view = UILabel()
        view.textColor = appearance.codeInfoLblTextColor
        view.font = appearance.codeInfoLblFont
        view.textAlignment = appearance.codeInfoLblTextAlignment
        view.text = appearance.codeInfoLblText
        return view
    }()

    lazy private var trySendCodeBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = appearance.trySendBtnInActiveColor
        view.isEnabled = false
        view.setTitleColor(appearance.inactiveTSendCodeBtnTitleColor, for: .normal)
        view.titleLabel?.font = appearance.trySendCodeBtnFont
        view.contentHorizontalAlignment = .center
        view.layer.borderWidth = appearance.trySendCodeBtnBorderWidth
        view.layer.borderColor = appearance.trySendCodeBtnBorderColor
        return view
    }()

    //MARK: -- Properties
    private let appearance = Appearance()
    private weak var timer: Timer?
    private var phoneNumber: String
    weak var delegate: AuthCodeConfirmViewDelegate?

    //MARK: -- Init
    init(_ phoneNumber: String) {
        self.phoneNumber = phoneNumber
        super.init(frame: .zero)
        self.backgroundColor = appearance.backgroundColor
        self.setupUI()
    }

    //MARK: -- public methods
    func updateScheduledTimer() {
        self.codeTF.text = ""
        self.codeTF.endEditing(true)
        self.setCodeConfirmBtnEnable(false)
        self.setTrySendInitValue()
        self.setupScheduledTimer()
    }

    //MARK: -- private methods
    fileprivate func setupUI() {
        self.addSubview(self.trySendCodeBtn)
        self.setTrySendInitValue()

        self.addSubview(self.codeInfoLbl)

        self.addSubview(self.codeConfirmBtn)
        self.setCodeConfirmBtnEnable(false)

        self.addSubview(self.codeTFBottomLine)
        self.addSubview(self.codeTF)
        self.codeTF.inputMaskDelegate = self

        self.addSubview(self.codeTFTitleLbl)
        self.addSubview(self.subtitleLbl)
        self.addSubview(self.largeTitleLbl)
    }

    private func setTrySendInitValue() {
        let title: String = "\(self.appearance.trySendCodeBtnTitle) 0:\(appearance.trySendInCode)"
        self.setTrySendBtnEnable(false, title)
    }
    //MARK: -- Making
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupMaking()
    }

    fileprivate func setupMaking() {
        self.setupTrySendBtnMaking()
    }

    fileprivate func setupTrySendBtnMaking() {
        self.trySendCodeBtn.addTarget(self, action: #selector(didTappedTrySendSmsBtn), for: .touchUpInside)
        let trySendBtnHeight = appearance.confirmBtnWidth * 0.14
        self.trySendCodeBtn.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.trySendBtnWidth)
            maker.height.equalTo(trySendBtnHeight)
            maker.bottom.equalTo(self.snp.bottom)
        }
        self.trySendCodeBtn.layer.cornerRadius = trySendBtnHeight * 0.2

        self.setupCodeInfoLblMaking()
    }

    fileprivate func setupCodeInfoLblMaking() {
        self.codeInfoLbl.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.codeInfoLblWidth)
            maker.bottom.equalTo(self.trySendCodeBtn.snp.top).offset(-appearance.codeInfoLblBottomMargin)
        }

        self.setupConfirmBtnMaking()
    }

    fileprivate func setupConfirmBtnMaking() {
        self.codeConfirmBtn.addTarget(self, action: #selector(didTappedConfirmBtn), for: .touchUpInside)
        let loginBtnHeight = appearance.confirmBtnWidth * 0.14
        self.codeConfirmBtn.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.confirmBtnWidth)
            maker.height.equalTo(loginBtnHeight)
            maker.bottom.equalTo(self.codeInfoLbl.snp.top).offset(-appearance.confirmBtnBottomMargin)
        }
        self.codeConfirmBtn.layer.cornerRadius = loginBtnHeight * 0.2

        self.setupPhoneNumberBottomLine()
    }

    fileprivate func setupPhoneNumberBottomLine() {
        self.codeTFBottomLine.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.codeTFBottomLineWidth)
            maker.height.equalTo(1)
            maker.bottom.equalTo(self.codeConfirmBtn.snp.top).offset(-appearance.codeTFBottomLineBottomMargin)
        }

        self.setupCodeTFMaking()
    }

    fileprivate func setupCodeTFMaking() {
        self.codeTF.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.confirmBtnWidth)
            maker.height.equalTo(appearance.codeTFHeight)
            maker.bottom.equalTo(self.codeTFBottomLine.snp.top)
        }

        self.setupCodeTFTitleLblMaking()
    }

    fileprivate func setupCodeTFTitleLblMaking() {
        self.codeTFTitleLbl.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.codeTitleWidth)
            maker.bottom.equalTo(self.codeTF.snp.top).offset(-appearance.codeTitleBottomMargin)
        }

        self.setupSubtitleLblMaking()
    }

    fileprivate func setupSubtitleLblMaking() {
        self.subtitleLbl.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.largeTitleLblWidth)
            maker.bottom.lessThanOrEqualTo(self.codeTFTitleLbl.snp.top).offset(-appearance.subtitleLblBottomMargin)
        }

        self.setupLargeTitleLblMaking()
    }

    fileprivate func setupLargeTitleLblMaking() {
        self.largeTitleLbl.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.largeTitleLblWidth)
            maker.top.lessThanOrEqualTo(16)
            maker.bottom.equalTo(self.subtitleLbl.snp.top).offset(-appearance.largeTitleLblBottomMargin)
        }
    }

    //MARK: -- change btns state
    private func setCodeConfirmBtnEnable(_ bool: Bool) {
        self.codeConfirmBtn.isEnabled = bool
        self.codeConfirmBtn.backgroundColor = bool ? appearance.confirmActiveColor : appearance.confirmInActiveColor
        self.codeConfirmBtn.setTitleColor(bool ? appearance.confirmBtnTitleLblActiveTextColor : appearance.confirmBtnTitleLblInActiveTextColor, for: .normal)
    }

    func setTrySendBtnEnable(_ bool: Bool, _ title: String) {
        self.trySendCodeBtn.isEnabled = bool
        self.trySendCodeBtn.backgroundColor = bool ? appearance.trySendBtnActiveColor : appearance.trySendBtnInActiveColor
        self.trySendCodeBtn.setTitleColor(bool ? appearance.activeTrySendCodeBtnTitleColor : appearance.inactiveTSendCodeBtnTitleColor, for: .normal)
        self.trySendCodeBtn.setTitle(title, for: .normal)
        !bool ? self.setupScheduledTimer() : self.timer?.invalidate()
    }

    //MARK: -- schedule
    private func setupScheduledTimer() {
        var second = appearance.trySendInCode
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if second == 0 {
                timer.invalidate()
                self.setTrySendBtnEnable(true, self.appearance.trySendCodeBtnSendTitle)
            } else {
                self.trySendCodeBtn.setTitle("\(self.appearance.trySendCodeBtnTitle) 0:\(second > 9 ? "\(second)" : "0\(second)")", for: .normal)
            }
            second -= 1
        }
    }

    //MARK: -- actions
    @objc private func didTappedConfirmBtn() {
        self.codeConfirmBtn.pulsate()
        self.codeTF.endEditing(true)
        guard let verificationCode = self.codeTF.text, verificationCode.digits.count == 6 else {
            self.setCodeConfirmBtnEnable(false)
            return
        }
        self.delegate?.didTappedConfirmBtn(verificationCode.digits) { [weak self] in
            guard let self = self else { return }
            self.setCodeConfirmBtnEnable(true)
        }
    }

    @objc private func didTappedTrySendSmsBtn() {
        self.trySendCodeBtn.pulsate()
        self.codeTF.endEditing(true)
        self.setCodeConfirmBtnEnable(false)
        self.delegate?.didTappedTrySendSms()
    }

    //MARK: -- deinit
    deinit {
        self.timer?.invalidate()
        self.codeTF.endEditing(true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: -- InputMaskTextFieldDelegate
extension AuthCodeConfirmView: InputMaskTextFieldDelegate {
    func textChanged(_ isValid: Bool, _ text: String) {
        self.setCodeConfirmBtnEnable(isValid)
    }
}
