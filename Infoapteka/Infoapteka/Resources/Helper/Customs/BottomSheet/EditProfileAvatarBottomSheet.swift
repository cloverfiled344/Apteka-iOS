//
//  EditProfileAvatarBottomSheet.swift
//  Infoapteka
//
//

import UIKit

extension EditProfileAvatarBottomSheet {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color

        let blackViewBackgroundColor: UIColor = Asset.mainBlack.color.withAlphaComponent(0.2)
        let blackViewAlpha: CGFloat = 0.0

        let contentViewHeight: CGFloat = 144.0
        let contentViewBackgroundColor: UIColor = Asset.mainWhite.color
        let contentViewMasksToBounds: Bool = true
        let contentViewCornerRadius: CGFloat = 16.0
        let contentViewMaskedCorners: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        let btnHeight: CGFloat = 46.0
        let btnLeftRightMargin: CGFloat = 20.0
        let btnLayerCorners   : CGFloat = 12.0

        let uploadAvatarBtnBakcgroundColor: UIColor = Asset.mainGreen.color
        let uploadAvatarBtnTitle: String = L10n.uploadPhoto
        let uploadAvatarBtnTitleFont : UIFont = FontFamily.Inter.regular.font(size: 14.0)
        let uploadAvatarBtnTitleColor: UIColor = Asset.mainWhite.color
        let uploadAvatarBtnTopMargin : CGFloat = 20.0
        let uploadAvatarBtnImage: UIImage = Asset.icCamera.image

        let deleteAvatarBtnBakcgroundColor: UIColor = Asset.mainWhite.color
        let deleteAvatarBtnTitle: String = L10n.removePhoto
        let deleteAvatarBtnTitleFont : UIFont = FontFamily.Inter.regular.font(size: 14.0)
        let deleteAvatarBtnTitleColor: UIColor = Asset.darkBlue.color
        let deleteAvatarBtnBorderWidth: CGFloat = 1.0
        let deleteAvatarBtnBorderColor: CGColor = Asset.secondaryGrayLight.color.cgColor
        let deleteAvatarBtnTopMargin   : CGFloat = 8.0
        let deleteAvatarBtnBottomMargin: CGFloat = 24.0
        let deleteAvatarBtnImage: UIImage = Asset.icTrash.image
    }
}

class EditProfileAvatarBottomSheet: UIView {

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

    lazy private var uploadOrEditAvatarBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = appearance.uploadAvatarBtnBakcgroundColor
        view.titleLabel?.font = appearance.uploadAvatarBtnTitleFont
        view.layer.cornerRadius = appearance.btnLayerCorners
        view.layer.masksToBounds = true
        view.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        view.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        view.addTarget(self, action: #selector(didTappedUploadAvatarBtn), for: .touchUpInside)
        return view
    }()

    lazy private var deleteAvatarOrCloseBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = appearance.deleteAvatarBtnBakcgroundColor
        view.titleLabel?.font = appearance.deleteAvatarBtnTitleFont
        view.setTitleColor(appearance.deleteAvatarBtnTitleColor, for: .normal)
        view.layer.cornerRadius = appearance.btnLayerCorners
        view.layer.masksToBounds = true
        view.layer.borderWidth = appearance.deleteAvatarBtnBorderWidth
        view.layer.borderColor = appearance.deleteAvatarBtnBorderColor
        view.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        view.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        view.addTarget(self, action: #selector(didTappedDeleteAvatarBtn), for: .touchUpInside)
        return view
    }()

    var uploadAvatar: (() -> ())?
    var deleteAvatar: (() -> ())?

    private var appearance = Appearance()
    private var avatarIsHave: Bool = false

    private struct Static { static var instance: EditProfileAvatarBottomSheet? }
    class var instance: EditProfileAvatarBottomSheet {
        Static.instance = Static.instance == nil ? EditProfileAvatarBottomSheet() : Static.instance ?? self.instance
        return Static.instance!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = appearance.backgroundColor
    }

    func show(_ avatarIsHave: Bool) {
        guard let keyWindow = UIApplication.keyWindow else { return }
        self.avatarIsHave = avatarIsHave
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

        contentView.addSubview(uploadOrEditAvatarBtn)
        let uploadOrEditAvatarBtnTitle = avatarIsHave ? "Изменить фото" : appearance.uploadAvatarBtnTitle
        uploadOrEditAvatarBtn.setTitle(uploadOrEditAvatarBtnTitle, for: .normal)

        let uploadOrEditAvatarBtnImage = avatarIsHave ? Asset.icEditProfile.image : appearance.uploadAvatarBtnImage
        uploadOrEditAvatarBtn.setImage(uploadOrEditAvatarBtnImage, for: .normal)
        uploadOrEditAvatarBtn.snp.remakeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(appearance.uploadAvatarBtnTopMargin)
            make.left.equalTo(contentView.snp.left).offset(appearance.btnLeftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.btnLeftRightMargin)
            make.height.equalTo(appearance.btnHeight)
        }

        contentView.addSubview(deleteAvatarOrCloseBtn)
        let deleteAvatarOrCloseBtnTitle = avatarIsHave ? appearance.deleteAvatarBtnTitle : "Отмена"
        deleteAvatarOrCloseBtn.setTitle(deleteAvatarOrCloseBtnTitle, for: .normal)

        let deleteAvatarOrCloseBtnImage = avatarIsHave ? appearance.deleteAvatarBtnImage : nil
        deleteAvatarOrCloseBtn.setImage(deleteAvatarOrCloseBtnImage, for: .normal)
        deleteAvatarOrCloseBtn.snp.remakeConstraints { make in
            make.top.equalTo(uploadOrEditAvatarBtn.snp.bottom).offset(appearance.deleteAvatarBtnTopMargin)
            make.left.equalTo(contentView.snp.left).offset(appearance.btnLeftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.btnLeftRightMargin)
            make.height.equalTo(appearance.btnHeight)
            make.bottom.equalTo(contentView.snp.bottom).offset(-appearance.deleteAvatarBtnBottomMargin)
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

    @objc private func didTappedUploadAvatarBtn() {
        uploadOrEditAvatarBtn.pulsate()
        handleDismiss()
        uploadAvatar?()
    }

    @objc private func didTappedDeleteAvatarBtn() {
        deleteAvatarOrCloseBtn.pulsate()
        handleDismiss()
        avatarIsHave ? deleteAvatar?() : nil
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
        uploadOrEditAvatarBtn.removeFromSuperview()
        deleteAvatarOrCloseBtn.removeFromSuperview()
        contentView.removeFromSuperview()
        blackView.removeFromSuperview()
        removeFromSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
