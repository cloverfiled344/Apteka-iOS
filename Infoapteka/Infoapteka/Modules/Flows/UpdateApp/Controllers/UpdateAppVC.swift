//
//  UpdateAppVC.swift
//  Infoapteka
//
//

import UIKit

extension UpdateAppVC {
    struct Appearance {
        let backgroundColor = UIColor.clear

        let blackViewBackgroundColor: UIColor = Asset.mainBlack.color.withAlphaComponent(0.2)
        let blackViewAlpha: CGFloat = 0.0

        let contentViewBackgroundColor: UIColor = Asset.mainWhite.color
        let contentViewMasksToBounds: Bool = true
        let contentViewCornerRadius: CGFloat = 8
        let contentViewMaskedCorners: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        let titleLblNumberOfLines: Int = 1
        let titleLblFont     : UIFont = FontFamily.Inter.bold.font(size: 15.0)
        let titleLblTextColor: UIColor = Asset.mainBlack.color
        let titleLblTextAligment: NSTextAlignment = .center
        let titleLblTopMargin   : CGFloat = 24.0
        let titleLblLeftRightMargin: CGFloat = 20.0
        let titleLblText: String = "Обновление"

        let subtitleLblNumberOfLines: Int = 2
        let subtitleLblFont     : UIFont = FontFamily.Inter.regular.font(size: 14.0)
        let subtitleLblTextColor: UIColor = Asset.mainBlack.color
        let subtitleLblTextAligment: NSTextAlignment = .center
        let subtitleLblTopMargin   : CGFloat = 8.0
        let subtitleLblLeftRightMargin: CGFloat = 20.0
        let subtitleLblText: String = "Доступно новое обновление. \nВерсия: "

        let btnHeight: CGFloat = 46.0
        let btnLeftRightMargin: CGFloat = 20.0
        let btnLayerCorners   : CGFloat = 12.0

        let updateBtnBakcgroundColor: UIColor = Asset.mainGreen.color
        let updateBtnTitle: String = "Обновить"
        let updateBtnTitleFont : UIFont = FontFamily.Inter.regular.font(size: 14.0)
        let updateBtnTitleColor: UIColor = Asset.mainWhite.color
        let updateBtnTopMargin : CGFloat = 24.0

        let skipBtnBakcgroundColor: UIColor = Asset.mainWhite.color
        let skipBtnTitle: String = "Напомнить позже"
        let skipBtnTitleFont : UIFont = FontFamily.Inter.regular.font(size: 14.0)
        let skipBtnTitleColor: UIColor = Asset.darkBlue.color
        let skipBtnBorderWidth: CGFloat = 1.0
        let skipBtnBorderColor: CGColor = Asset.secondaryGrayLight.color.cgColor
        let skipBtnTopMargin   : CGFloat = 8.0
        let skipBtnBottomMargin: CGFloat = 24.0
    }
}

class UpdateAppVC: BaseVC {
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
        view.textAlignment = appearance.titleLblTextAligment
        view.text = appearance.titleLblText
        view.numberOfLines = appearance.titleLblNumberOfLines
        return view
    }()

    lazy private var subtitleLbl: UILabel = {
        let view = UILabel()
        view.font = appearance.subtitleLblFont
        view.textColor     = appearance.subtitleLblTextColor
        view.textAlignment = appearance.subtitleLblTextAligment
        view.text = "\(appearance.subtitleLblText)\(appVersion.version)"
        view.numberOfLines = appearance.subtitleLblNumberOfLines
        return view
    }()

    lazy private var updateBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = appearance.updateBtnBakcgroundColor
        view.setTitle(appearance.updateBtnTitle, for: .normal)
        view.titleLabel?.font = appearance.updateBtnTitleFont
        view.setTitleColor(appearance.updateBtnTitleColor, for: .normal)
        view.layer.cornerRadius = appearance.btnLayerCorners
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(didTappedUpdateBtn), for: .touchUpInside)
        return view
    }()

    lazy private var skipBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = appearance.skipBtnBakcgroundColor
        view.setTitle(appearance.skipBtnTitle, for: .normal)
        view.titleLabel?.font = appearance.skipBtnTitleFont
        view.setTitleColor(appearance.skipBtnTitleColor, for: .normal)
        view.layer.cornerRadius = appearance.btnLayerCorners
        view.layer.masksToBounds = true
        view.layer.borderWidth = appearance.skipBtnBorderWidth
        view.layer.borderColor = appearance.skipBtnBorderColor
        view.addTarget(self, action: #selector(didTappedSkipBtn), for: .touchUpInside)
        return view
    }()

    private var appearance = Appearance()
    private var appVersion: AppVersion
    private var contentViewHeight: CGFloat {
        get { appVersion.forceUpdate ? 192.0 : 246.0 }
    }
    var skipBtnClicked: (() -> ())?

    init(_ appVersion: AppVersion) {
        self.appVersion = appVersion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let y = Constants.screenHeight - contentViewHeight
        setupViewAnimation(y)
    }

    private func setupUI() {
        view.backgroundColor = appearance.backgroundColor
        setNavBarBackColor(title: "",
                           statusBarBackColor: .clear,
                           navBarBackColor: .clear,
                           navBarTintColor: .clear,
                           prefersLargeTitles: false)
        setupContentView()
    }

    private func setupContentView() {
        view.addSubview(contentView)
        contentView.frame = CGRect(x: 0,
                                   y: view.frame.height,
                                   width: view.frame.width,
                                   height: contentViewHeight)

        contentView.addSubview(titleLbl)
        contentView.addSubview(subtitleLbl)
        contentView.addSubview(updateBtn)
        contentView.addSubview(skipBtn)

        titleLbl.snp.remakeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(appearance.titleLblTopMargin)
            make.centerX.equalTo(contentView.snp.centerX)
        }

        subtitleLbl.snp.remakeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(appearance.subtitleLblTopMargin)
            make.left.equalTo(contentView.snp.left).offset(appearance.titleLblLeftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.titleLblLeftRightMargin)
        }

        updateBtn.snp.remakeConstraints { make in
            make.top.equalTo(subtitleLbl.snp.bottom).offset(appearance.updateBtnTopMargin)
            make.left.equalTo(contentView.snp.left).offset(appearance.btnLeftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.btnLeftRightMargin)
            make.height.equalTo(appearance.btnHeight)
        }

        guard !appVersion.forceUpdate else { return }
        skipBtn.snp.remakeConstraints { make in
            make.top.equalTo(updateBtn.snp.bottom).offset(appearance.skipBtnTopMargin)
            make.left.equalTo(contentView.snp.left).offset(appearance.btnLeftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.btnLeftRightMargin)
            make.height.equalTo(appearance.btnHeight)
            make.bottom.equalTo(contentView.snp.bottom).offset(-appearance.skipBtnBottomMargin)
        }
    }

    private func setupViewAnimation(_ y: CGFloat) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.contentView.frame = CGRect(x: 0,
                                                        y: y,
                                                        width: Constants.screenWidth,
                                                        height: self.contentViewHeight)
                       })
    }

    @objc private func didTappedUpdateBtn() {
        updateBtn.pulsate()
        openLink(Constants.appstorelink)
    }

    @objc private func didTappedSkipBtn() {
        skipBtn.pulsate()
        handleDismiss()
        skipBtnClicked?()
    }

    @objc private func handleDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.contentView.frame = CGRect(x: 0, y: Constants.screenHeight,
                                            width: Constants.screenWidth,
                                            height: self.contentViewHeight)
        }, completion: nil)
    }
}
