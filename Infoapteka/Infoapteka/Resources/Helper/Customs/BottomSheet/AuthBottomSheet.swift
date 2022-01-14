//
//  AuthBottomSheet.swift
//  Infoapteka
//
//

import UIKit

extension AuthBottomSheet {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color

        let blackViewBackgroundColor: UIColor = Asset.mainBlack.color.withAlphaComponent(0.2)
        let blackViewAlpha: CGFloat = 0.0

        let contentViewHeight: CGFloat = 268.0
        let contentViewBackgroundColor: UIColor = Asset.mainWhite.color
        let contentViewMasksToBounds: Bool = true
        let contentViewCornerRadius: CGFloat = 8
        let contentViewMaskedCorners: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        let iconIVContentMode  : UIView.ContentMode = .scaleAspectFit
        let iconIVImage: UIImage = Asset.icProfile.image
        let iconIVClipsToBounds: Bool = true
        let iconIVWidth    : CGFloat = 32.0
        let iconIVTopMargin: CGFloat = 24.0

        let titleLblNumberOfLines: Int = 2
        let titleLblFont     : UIFont = FontFamily.Inter.medium.font(size: 15.0)
        let titleLblTextColor: UIColor = Asset.mainBlack.color
        let titleLblTextAligment: NSTextAlignment = .center
        let titleLblTopMargin   : CGFloat = 16.0
        let titleLblLeftRightMargin: CGFloat = 20.0
        let titleLblText: String = "Авторизуйтесь для \nдля совершения покупки"

        let btnHeight: CGFloat = 46.0
        let btnLeftRightMargin: CGFloat = 20.0
        let btnLayerCorners   : CGFloat = 12.0

        let signInBtnBakcgroundColor: UIColor = Asset.mainGreen.color
        let signInBtnTitle: String = L10n.signIn
        let signInBtnTitleFont : UIFont = FontFamily.Inter.regular.font(size: 14.0)
        let signInBtnTitleColor: UIColor = Asset.mainWhite.color
        let signInBtnTopMargin : CGFloat = 24.0

        let closeBtnBakcgroundColor: UIColor = Asset.mainWhite.color
        let closeBtnTitle: String = "Закрыть"
        let closeBtnTitleFont : UIFont = FontFamily.Inter.regular.font(size: 14.0)
        let closeBtnTitleColor: UIColor = Asset.darkBlue.color
        let closeBtnBorderWidth: CGFloat = 1.0
        let closeBtnBorderColor: CGColor = Asset.secondaryGrayLight.color.cgColor
        let closeBtnTopMargin   : CGFloat = 8.0
        let closeBtnBottomMargin: CGFloat = 24.0
    }
}

class AuthBottomSheet: UIView {

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

    lazy private var iconIV: UIImageView = {
        let view = UIImageView()
        view.contentMode = appearance.iconIVContentMode
        view.clipsToBounds = appearance.iconIVClipsToBounds
        view.image = appearance.iconIVImage
        return view
    }()

    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.font = appearance.titleLblFont
        view.textColor     = appearance.titleLblTextColor
        view.textAlignment = appearance.titleLblTextAligment
        view.text = appearance.titleLblText
        view.numberOfLines = appearance.titleLblNumberOfLines
        return view
    }()

    lazy private var signInBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = appearance.signInBtnBakcgroundColor
        view.setTitle(appearance.signInBtnTitle, for: .normal)
        view.titleLabel?.font = appearance.signInBtnTitleFont
        view.setTitleColor(appearance.signInBtnTitleColor, for: .normal)
        view.layer.cornerRadius = appearance.btnLayerCorners
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(didTappedSignInBtn), for: .touchUpInside)
        return view
    }()

    lazy private var closeBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = appearance.closeBtnBakcgroundColor
        view.setTitle(appearance.closeBtnTitle, for: .normal)
        view.titleLabel?.font = appearance.closeBtnTitleFont
        view.setTitleColor(appearance.closeBtnTitleColor, for: .normal)
        view.layer.cornerRadius = appearance.btnLayerCorners
        view.layer.masksToBounds = true
        view.layer.borderWidth = appearance.closeBtnBorderWidth
        view.layer.borderColor = appearance.closeBtnBorderColor
        view.addTarget(self, action: #selector(didTappedCloseBtn), for: .touchUpInside)
        return view
    }()

    private var appearance = Appearance()

    private struct Static { static var instance: AuthBottomSheet? }
    class var instance: AuthBottomSheet {
        Static.instance = Static.instance == nil ? AuthBottomSheet() : Static.instance ?? self.instance
        return Static.instance!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = appearance.backgroundColor
    }

    static func show() {
        guard let keyWindow = UIApplication.keyWindow else { return }
        instance.setupUI(keyWindow)

        let y = Constants.screenHeight - instance.appearance.contentViewHeight
        instance.setupViewAnimation(y)
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

        contentView.addSubview(iconIV)
        contentView.addSubview(titleLbl)
        contentView.addSubview(signInBtn)
        contentView.addSubview(closeBtn)
        iconIV.snp.remakeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(appearance.iconIVTopMargin)
            make.width.height.equalTo(appearance.iconIVWidth)
            make.centerX.equalTo(contentView.snp.centerX)
        }

        titleLbl.snp.remakeConstraints { make in
            make.top.equalTo(iconIV.snp.bottom).offset(appearance.titleLblTopMargin)
            make.left.equalTo(contentView.snp.left).offset(appearance.titleLblLeftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.titleLblLeftRightMargin)
        }

        signInBtn.snp.remakeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(appearance.signInBtnTopMargin)
            make.left.equalTo(contentView.snp.left).offset(appearance.btnLeftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.btnLeftRightMargin)
            make.height.equalTo(appearance.btnHeight)
        }

        closeBtn.snp.remakeConstraints { make in
            make.top.equalTo(signInBtn.snp.bottom).offset(appearance.closeBtnTopMargin)
            make.left.equalTo(contentView.snp.left).offset(appearance.btnLeftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.btnLeftRightMargin)
            make.height.equalTo(appearance.btnHeight)
            make.bottom.equalTo(contentView.snp.bottom).offset(-appearance.closeBtnBottomMargin)
        }
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

    @objc private func didTappedSignInBtn() {
        signInBtn.pulsate()
        handleDismiss()
        guard let keyWindow = UIApplication.keyWindow else { return }
        if let rootViewController = keyWindow.rootViewController,
           let nav =  rootViewController.navigationController {
            nav.hidesBottomBarWhenPushed = true
            let authSignInVC = AuthSignInVC(.init())
            nav.pushViewController(authSignInVC, animated: true)
        } else if let rootVC = keyWindow.rootViewController {
            let authSignInVC = AuthSignInVC(.init())
            let nav = UINavigationController(rootViewController: authSignInVC)
//            nav.modalPresentationStyle = .fullScreen
            rootVC.present(nav, animated: true, completion: nil)
        }
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
        iconIV.removeFromSuperview()
        titleLbl.removeFromSuperview()
        signInBtn.removeFromSuperview()
        closeBtn.removeFromSuperview()
        contentView.removeFromSuperview()
        blackView.removeFromSuperview()
        removeFromSuperview()
        AuthBottomSheet.Static.instance = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
