//
//  PreOrderPreviewBottomSheet.swift
//  Infoapteka
//
//

import UIKit

extension PreOrderPreviewBottomSheet {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color

        let blackViewBackgroundColor: UIColor = Asset.mainBlack.color.withAlphaComponent(0.2)
        let blackViewAlpha: CGFloat = 0.0

        let contentViewHeight: CGFloat = 225.0
        let contentViewBackgroundColor: UIColor = Asset.mainWhite.color
        let contentViewMasksToBounds: Bool = true
        let contentViewCornerRadius: CGFloat = 16.0
        let contentViewMaskedCorners: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        let contentViewPadding: CGFloat = 20.0

        let titleLblNumberOfLines: Int = 2
        let titleLblFont     : UIFont = FontFamily.Inter.bold.font(size: 15.0)
        let titleLblTextColor: UIColor = Asset.mainBlack.color
        let titleLblLeftRightMargin: CGFloat = 20.0
        let titleLblText: String = "Предзаказ"

        let closeBtnTopWidth : CGFloat = 24.0
        let closeBtnImage: UIImage = Asset.icClose.image

        let btnHeight: CGFloat = 46.0
        let btnLeftRightMargin: CGFloat = 20.0
        let btnLayerCorners   : CGFloat = 12.0

        let infoLblNumberOfLines: Int = 0
        let infoLblTextAligment: NSTextAlignment = .center

        let callBtnBakcgroundColor: UIColor = Asset.mainGreen.color
        let callBtnTitle: String = L10n.call
        let callBtnTitleFont : UIFont = FontFamily.Inter.regular.font(size: 14.0)
        let callBtnTitleColor: UIColor = Asset.mainWhite.color
        let callBtnImage: UIImage = Asset.icCall.image
    }
}

class PreOrderPreviewBottomSheet: UIView {

    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = appearance.blackViewAlpha
        view.backgroundColor = appearance.blackViewBackgroundColor
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(handleDismiss)))
        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.contentViewBackgroundColor
        view.layer.masksToBounds = appearance.contentViewMasksToBounds
        view.layer.cornerRadius = appearance.contentViewCornerRadius
        view.layer.maskedCorners = appearance.contentViewMaskedCorners
        return view
    }()

    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.font = appearance.titleLblFont
        view.textColor     = appearance.titleLblTextColor
        view.text = appearance.titleLblText
        view.numberOfLines = appearance.titleLblNumberOfLines
        return view
    }()

    lazy private var closeBtn: UIButton = {
        let view = UIButton()
        view.setImage(appearance.closeBtnImage, for: .normal)
        view.addTarget(self, action: #selector(didTappedCloseBtn), for: .touchUpInside)
        return view
    }()

    lazy private var infoLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = appearance.infoLblNumberOfLines
        view.textAlignment = appearance.infoLblTextAligment
        return view
    }()

    lazy private var callBtn: UIButton = {
        let view = UIButton()
        view.setImage(appearance.callBtnImage, for: .normal)
        view.backgroundColor = appearance.callBtnBakcgroundColor
        view.setTitle(appearance.callBtnTitle, for: .normal)
        view.titleLabel?.font = appearance.callBtnTitleFont
        view.setTitleColor(appearance.callBtnTitleColor, for: .normal)
        view.layer.cornerRadius = appearance.btnLayerCorners
        view.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        view.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(didTappedCallBtn), for: .touchUpInside)
        return view
    }()

    private var appearance = Appearance()
    private var profile: Profile? {
        didSet {
            setInfoLblValue()
        }
    }
    var call: ((String) -> ())?

    private struct Static { static var instance: PreOrderPreviewBottomSheet? }
    class var instance: PreOrderPreviewBottomSheet {
        Static.instance = Static.instance == nil ? PreOrderPreviewBottomSheet() : Static.instance ?? self.instance
        return Static.instance!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = appearance.backgroundColor
    }

    func show(_ profile: Profile?) {
        guard let keyWindow = UIApplication.keyWindow else { return }
        self.profile = profile
        setupUI(keyWindow)

        let y = Constants.screenHeight - appearance.contentViewHeight
        setupViewAnimation(y)
    }

    private func setupUI(_ window: UIWindow) {
        backgroundColor = appearance.backgroundColor
        setupBlackView(window)
    }

    private func setupBlackView(_ window: UIWindow) {
        window.addSubview(blackView)
        blackView.frame = window.frame
        setupContentView(window)
    }

    private func setupContentView(_ window: UIWindow) {
        window.addSubview(contentView)
        contentView.frame = CGRect(x: 0,
                                   y: window.frame.height,
                                   width: window.frame.width,
                                   height: appearance.contentViewHeight)

        contentView.addSubview(titleLbl)
        contentView.addSubview(closeBtn)
        contentView.addSubview(infoLbl)
        contentView.addSubview(callBtn)

        closeBtn.snp.remakeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(appearance.contentViewPadding)
            make.right.equalTo(contentView.snp.right).offset(-appearance.contentViewPadding)
            make.height.width.equalTo(appearance.closeBtnTopWidth)
        }

        titleLbl.snp.remakeConstraints { make in
            make.centerY.equalTo(closeBtn.snp.centerY)
            make.left.equalTo(contentView.snp.left).offset(appearance.titleLblLeftRightMargin)
            make.right.equalTo(closeBtn.snp.left).offset(-appearance.titleLblLeftRightMargin)
        }

        infoLbl.snp.remakeConstraints { make in
            make.top.equalTo(closeBtn.snp.bottom).offset(appearance.contentViewPadding)
            make.left.equalTo(contentView.snp.left).offset(appearance.contentViewPadding)
            make.right.equalTo(contentView.snp.right).offset(-appearance.contentViewPadding)
        }

        callBtn.snp.remakeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(appearance.contentViewPadding)
            make.right.equalTo(contentView.snp.right).offset(-appearance.contentViewPadding)
            make.height.equalTo(appearance.btnHeight)
            make.bottom.equalTo(contentView.snp.bottom).offset(-(appearance.contentViewPadding + 4.0))
        }
    }

    private func setInfoLblValue() {
        guard let profile = profile else { return }

        let medium15Attributes: [NSAttributedString.Key: Any] = [.font: FontFamily.Inter.medium.font(size: 15.0),
                                                                 .foregroundColor: Asset.secondaryGray.color]
        let attributedText = NSMutableAttributedString(string: profile.firstName ?? "Неизвестно",
                                                       attributes: medium15Attributes)
        attributedText.append(.init(string: "\n\(profile.address ?? "Неизвестно")",
                                    attributes: medium15Attributes))
        attributedText.append(.init(string: "\n\(profile.phoneNumber ?? "")",
                                    attributes: [.font: FontFamily.Inter.bold.font(size: 16.0),
                                                 .foregroundColor: Asset.mainBlack.color]))
        self.infoLbl.attributedText = attributedText
    }

    private func setupViewAnimation(_ y: CGFloat) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.blackView.alpha = 1
                        self.contentView.frame = CGRect(x: 0,
                                                        y: y,
                                                        width: Constants.screenWidth,
                                                        height: self.appearance.contentViewHeight)
                       })
    }

    @objc private func didTappedCallBtn() {
        callBtn.pulsate()
        guard let profile = profile, let phone = profile.phoneNumber, !phone.isEmpty else {
            BannerTop.showToast(message: "Неверный номер", and: .systemRed)
            return
        }
        call?(phone)
        handleDismiss()
    }

    @objc private func didTappedCloseBtn() {
        closeBtn.pulsate()
        handleDismiss()
    }

    @objc private func handleDismiss() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.contentView.frame = CGRect(x: 0,
                                                        y: Constants.screenHeight,
                                                        width: Constants.screenWidth,
                                                        height: self.appearance.contentViewHeight)
                        self.blackView.alpha = 0
                       }) { (isTrue) in
            guard isTrue else { return }
            self.dispose()
        }
    }

    private func dispose() {
        titleLbl.removeFromSuperview()
        callBtn.removeFromSuperview()
        closeBtn.removeFromSuperview()
        contentView.removeFromSuperview()
        blackView.removeFromSuperview()
        removeFromSuperview()
        PreOrderPreviewBottomSheet.Static.instance = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
