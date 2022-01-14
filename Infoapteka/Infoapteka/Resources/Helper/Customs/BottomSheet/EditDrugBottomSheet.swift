//
//  EditDrugBottomSheet.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK: Appearance
extension EditDrugBottomSheet {
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
        let btnTopMargin: CGFloat = 20.0
        let btnLeftRightMargin: CGFloat = 20.0
        let btnLayerCorners   : CGFloat = 12.0

        let removeBtnBakcgroundColor: UIColor = Asset.secondaryRed.color
        let removeBtnTitle: String = L10n.remove
        let removeBtnTitleFont : UIFont = FontFamily.Inter.regular.font(size: 14.0)
        let removeBtnTitleColor: UIColor = Asset.mainWhite.color
        let removeBtnTopMargin   : CGFloat = 8.0
        let removeBtnBottomMargin: CGFloat = 20.0

        let editBtnBakcgroundColor: UIColor = Asset.mainWhite.color
        let editBtnTitle: String = L10n.edit
        let editBtnTitleFont : UIFont = FontFamily.Inter.regular.font(size: 14.0)
        let editBtnTitleColor: UIColor = Asset.darkBlue.color
        let editBtnBorderWidth: CGFloat = 1.0
        let editBtnBorderColor: CGColor = Asset.secondaryGrayLight.color.cgColor
        
        let editBtnBottomMargin: CGFloat = 24.0
        
        let editText: String = L10n.edit
        let removeText: String = L10n.remove
        let titleColor: UIColor = Asset.mainBlack.color
        let titleFont: UIFont = FontFamily.Inter.regular.font(size: 13)
        let contentLayerCornerRadius: CGFloat = 12.0
        let contentBorderWidth: CGFloat = 1.0
        let contentBorderColor: CGColor = Asset.light.color.cgColor
    }
}

// MARK: UIView
class EditDrugBottomSheet: UIView {
    
    // MARK: UI Components
    private lazy var backView = UIView().then {
        $0.alpha = appearance.blackViewAlpha
        $0.backgroundColor = appearance.blackViewBackgroundColor
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(handleDismiss)))
    }
    
    private lazy var contentView = UIView().then {
        $0.backgroundColor = appearance.contentViewBackgroundColor
        $0.layer.masksToBounds = appearance.contentViewMasksToBounds
        $0.layer.cornerRadius = appearance.contentViewCornerRadius
        $0.layer.maskedCorners = appearance.contentViewMaskedCorners
    }
    
    private lazy var editBtn = UIButton().then {
        $0.setTitle(appearance.editText, for: .normal)
        $0.setTitleColor(appearance.titleColor, for: .normal)
        $0.titleLabel?.font = appearance.titleFont
        $0.backgroundColor = appearance.editBtnBakcgroundColor
        $0.layer.cornerRadius = appearance.btnLayerCorners
        $0.layer.borderWidth = appearance.editBtnBorderWidth
        $0.layer.borderColor = appearance.editBtnBorderColor
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(didTappedOnEditBtn), for: .touchUpInside)
    }
    
    private lazy var deleteBtn = UIButton().then {
        $0.setTitle(appearance.removeText, for: .normal)
        $0.setTitleColor(appearance.removeBtnTitleColor, for: .normal)
        $0.titleLabel?.font = appearance.titleFont
        $0.backgroundColor = appearance.removeBtnBakcgroundColor
        $0.layer.cornerRadius = appearance.btnLayerCorners
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(didTappedOnDeleteBtn), for: .touchUpInside)
    }
    
    // MARK: Properties
    private let appearance = Appearance()
    private struct Static { static var instance: EditDrugBottomSheet? }
    class var instance: EditDrugBottomSheet {
        Static.instance = Static.instance == nil ? EditDrugBottomSheet() : Static.instance ?? self.instance
        return Static.instance!
    }
    
    // MARK: Closure
    var editDrug: (() -> ())?
    var deleteDrug: (() -> ())?
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = appearance.backgroundColor
    }

    func show() {
        guard let keyWindow = UIApplication.keyWindow else { return }
        setupUI(keyWindow)
        
        let y = Constants.screenHeight - appearance.contentViewHeight
        setupViewAnimation(y)
    }
    
    func hide() {
        handleDismiss()
    }
    
    private func setupUI(_ window: UIWindow) {
        backgroundColor = appearance.backgroundColor
        setupBackView(window)
    }
    
    private func setupBackView(_ window: UIWindow) {
        window.addSubview(backView)
        backView.frame = window.frame
        setupContentView(window)
    }
    
    private func setupContentView(_ window: UIWindow) {
        window.addSubview(contentView)
        contentView.frame = .init(x: 0,
                                  y: window.frame.height,
                                  width: window.frame.width,
                                  height: appearance.contentViewHeight)
        contentView.addSubview(editBtn)
        contentView.addSubview(deleteBtn)
        
        editBtn.snp.remakeConstraints { (maker) in
            maker.height.equalTo(appearance.btnHeight)
            maker.top.equalTo(contentView.snp.top).offset(appearance.btnTopMargin)
            maker.left.equalTo(contentView.snp.left).offset(appearance.btnLeftRightMargin)
            maker.right.equalTo(contentView.snp.right).offset(-appearance.btnLeftRightMargin)
        }
        
        deleteBtn.snp.remakeConstraints { (maker) in
            maker.height.equalTo(appearance.btnHeight)
            maker.top.equalTo(editBtn.snp.bottom).offset(appearance.removeBtnTopMargin)
            maker.left.right.equalTo(editBtn)
            maker.bottom.equalTo(contentView.snp.bottom).offset(-appearance.removeBtnBottomMargin)
        }
    }
    
    private func setupViewAnimation(_ y: CGFloat) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            self.backView.alpha = 1
            self.contentView.frame = .init(x: 0, y: y, width: Constants.screenWidth, height: self.appearance.contentViewHeight)
        }
    }
    
    // MARK: Actions
    @objc private func didTappedOnEditBtn() {
        editBtn.pulsate()
        handleDismiss()
        editDrug?()
    }
    
    @objc private func didTappedOnDeleteBtn() {
        deleteBtn.pulsate()
        handleDismiss()
        deleteDrug?()
    }
    
    @objc private func handleDismiss() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: .curveEaseOut) {
            self.contentView.frame = .init(x: 0,
                                           y: Constants.screenHeight,
                                           width: Constants.screenWidth,
                                           height: self.appearance.contentViewHeight)
            self.backView.alpha = 0
        } completion: { (isTrue) in
            guard isTrue else { return }
            self.dispose()
        }
    }
    
    private func dispose() {
        editBtn.removeFromSuperview()
        deleteBtn.removeFromSuperview()
        contentView.removeFromSuperview()
        backView.removeFromSuperview()
        removeFromSuperview()
        EditDrugBottomSheet.Static.instance = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
