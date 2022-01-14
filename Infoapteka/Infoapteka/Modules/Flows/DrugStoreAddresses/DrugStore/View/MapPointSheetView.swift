//
//  MapPointSheetView.swift
//  Infoapteka
//
//  
//

import UIKit



// MARK: Appearance
extension MapPointSheetView {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color

        let contentViewHeight: CGFloat = Constants.screenHeight / (Constants.screenHeight / 234)
        let blackViewBackgroundColor: UIColor = Asset.mainBlack.color.withAlphaComponent(0.2)
        let blackViewAlpha: CGFloat = 0.0
        
        let contentViewBackgroundColor: UIColor = Asset.mainWhite.color
        let contentViewMasksToBounds: Bool = true
        let contentViewCornerRadius: CGFloat = 16.0
        let contentViewMaskedCorners: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        let imageViewContentMode: UIImageView.ContentMode = .scaleAspectFill
        let imageViewLayerCornerRadius: CGFloat = 12.0
        let ivContentHeight: CGFloat = Constants.screenHeight / (Constants.screenHeight / 120.0)
        
        let statusTextFont: UIFont = FontFamily.Inter.medium.font(size: 11)
        let distanceTextFont: UIFont = FontFamily.Inter.medium.font(size: 11)
        let nameTextFont: UIFont = FontFamily.Inter.bold.font(size: 13)
        let addressTextFont: UIFont = FontFamily.Inter.regular.font(size: 13)
        let distanceTextColor: UIColor = Asset.secondaryGray.color
        let mainBlackColor: UIColor = Asset.mainBlack.color
        let openStatusColor: UIColor = Asset.orange.color
        let closeStatusColor: UIColor = Asset.secondaryRed.color
        
        let closeText: String = "Закрыто"
        let openText: String = "Сейчас открыто"
        
        let closeBtnHeight: CGFloat = Constants.screenHeight / (Constants.screenHeight / 46.0)
        let closeBtnBackColor: UIColor = Asset.mainGreen.color
        let closeBtnLayerRadius: CGFloat = 12.0
        let closeBtnText: String = "Закрыть"
    }
}

class MapPointSheetView: UIView {
    
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
    
    private lazy var iconIV = UIImageView().then {
        $0.contentMode = appearance.imageViewContentMode
        $0.layer.cornerRadius = appearance.imageViewLayerCornerRadius
        $0.layer.masksToBounds = true
    }
    
    private lazy var statusLbl = UILabel().then {
        $0.font = appearance.statusTextFont
        $0.textColor = appearance.mainBlackColor
    }
    
    private lazy var distanceLbl = UILabel().then {
        $0.font = appearance.distanceTextFont
        $0.textColor = appearance.distanceTextColor
        $0.textAlignment = .right
    }
    
    private lazy var titleLbl = UILabel().then {
        $0.numberOfLines = .zero
    }
    
    private lazy var closeBtn = UIButton().then {
        $0.backgroundColor = appearance.closeBtnBackColor
        $0.titleLabel?.font = FontFamily.Inter.regular.font(size: 14)
        $0.setTitleColor(Asset.mainWhite.color, for: .normal)
        $0.setTitle(appearance.closeBtnText, for: .normal)
        $0.layer.cornerRadius = appearance.closeBtnLayerRadius
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(didTappedOnCloseBtn), for: .touchUpInside)
    }
    
    // MARK: Properties
    private let appearance = Appearance()
    private struct Static { static var instance: MapPointSheetView? }
    class var instance: MapPointSheetView {
        Static.instance = Static.instance == nil ? MapPointSheetView() : Static.instance ?? self.instance
        return Static.instance!
    }
    private var drugStore: DrugStore? {
        didSet {
            guard let drugStore = drugStore else {
                return
            }
            iconIV.load(drugStore.image ?? "", Asset.icImagePlaceholder.image)
            setupStyleOfStatusLbl(drugStore.isOpen)
            distanceLbl.text = drugStore.distance
            setTitleAttribute(drugStore.name ?? "", drugStore.address ?? "")
        }
    }
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor     = appearance.backgroundColor
    }
    
    func setupData(_ drugStore: DrugStore) {
        self.drugStore = drugStore
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
        setupUIComponents()
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        iconIV.removeFromSuperview()
        statusLbl.removeFromSuperview()
        distanceLbl.removeFromSuperview()
        titleLbl.removeFromSuperview()
        closeBtn.removeFromSuperview()
        contentView.removeFromSuperview()
        backView.removeFromSuperview()
        removeFromSuperview()
        MapPointSheetView.Static.instance = nil
    }
    
    private func setupUIComponents() {
        contentView.addSubview(iconIV)
        contentView.addSubview(statusLbl)
        contentView.addSubview(distanceLbl)
        contentView.addSubview(titleLbl)
        contentView.addSubview(closeBtn)
        setConstraints()
    }
    
    private func setConstraints() {
        iconIV.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).offset(20)
            make.width.height.equalTo(appearance.ivContentHeight)
        }
        
        statusLbl.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.left.equalTo(iconIV.snp.right).offset(12)
        }
        
        distanceLbl.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.right.equalTo(contentView.snp.right).offset(-20)
            make.left.equalTo(statusLbl.snp.right).offset(20)
            make.centerY.equalTo(statusLbl.snp.centerY)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(statusLbl.snp.bottom).offset(8)
            make.left.equalTo(iconIV.snp.right).offset(12)
            make.right.equalTo(contentView.snp.right).offset(-20)
        }
        
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(iconIV.snp.bottom).offset(28)
            make.height.equalTo(appearance.closeBtnHeight)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }
    
    private func setTitleAttribute(_ name: String, _ address: String) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 1.24
        let attibute = NSMutableAttributedString(string: name, attributes: [.foregroundColor: appearance.mainBlackColor,
                                                                            .font: appearance.nameTextFont, .paragraphStyle: paragraph])
        attibute.append(.init(string: "\n\(address)", attributes: [.foregroundColor: appearance.mainBlackColor,
                                                            .font: appearance.addressTextFont, .paragraphStyle: paragraph]))
        titleLbl.attributedText = attibute
    }
    
    @objc private func didTappedOnCloseBtn() {
        closeBtn.pulsate()
        handleDismiss()
    }
    
    private func setupStyleOfStatusLbl(_ isOpen: Bool) {
        statusLbl.text = isOpen ? appearance.openText : appearance.closeText
        statusLbl.textColor = isOpen ? appearance.openStatusColor : appearance.closeStatusColor
    }
}
