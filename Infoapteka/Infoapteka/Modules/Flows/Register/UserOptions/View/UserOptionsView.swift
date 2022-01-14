//
//  UserOptionsView.swift
//  Infoapteka
//
//  
//

import UIKit
// MARK: Appearance
extension UserOptionsView {
    struct Appearance {
        let viewBackgroundColor: UIColor = Asset.mainWhite.color

        let layerCornerRadius: CGFloat = 12.0
        let borderWidth: CGFloat = 1.0
        let borderColor: UIColor = Asset.light.color
        let layerMaskToBounds: Bool = true

        let iconIVContentMode: UIImageView.ContentMode = .scaleAspectFit
        let iconIVTopMargin: CGFloat = 20.0

        let titleLabelNumberOfLines: Int = 1
        let titleLabelTextColor: UIColor = Asset.gray.color
        let titleLabelTextFont: UIFont = FontFamily.Inter.extraBold.font(size: 15)
        let titleLabelTextAlignment: NSTextAlignment = .center
        let titleLabelMargin: CGFloat = 16.0
    }
}

class UserOptionsView: UIView {
    
    // MARK: UI Components
    private lazy var iconIV: UIImageView = {
        let view = UIImageView()
        view.contentMode = appearance.iconIVContentMode
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = appearance.titleLabelNumberOfLines
        view.textColor = appearance.titleLabelTextColor
        view.font = appearance.titleLabelTextFont
        view.textAlignment = appearance.titleLabelTextAlignment
        return view
    }()
    
    // MARK: Properties
    private let appearance = Appearance()
    private var userOptionsType: UserOptionsType
    
    // MARK: Initialize
    required init(_ type: UserOptionsType, _ image: UIImage, _ contentName: String) {
        self.userOptionsType = type
        super.init(frame: .zero)
        self.iconIV.image = image
        self.titleLabel.text = contentName
        self.setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup UI
extension UserOptionsView {
    
    private func setupUI() {
        self.backgroundColor = appearance.viewBackgroundColor
        self.layer.cornerRadius = appearance.layerCornerRadius
        self.layer.borderWidth = appearance.borderWidth
        self.layer.borderColor = appearance.borderColor.cgColor
        self.layer.masksToBounds = appearance.layerMaskToBounds

        self.addSubview(iconIV)
        self.addSubview(titleLabel)
    }
    
    private func setConstraints() {
        self.iconIV.snp.remakeConstraints { (maker) in
            maker.top.equalTo(self.snp.top).offset(appearance.iconIVTopMargin)
            maker.left.right.equalTo(self)
        }

        self.titleLabel.snp.remakeConstraints { (maker) in
            maker.top.equalTo(self.iconIV.snp.bottom).offset(appearance.titleLabelMargin)
            maker.left.equalTo(self.snp.left).offset(appearance.titleLabelMargin)
            maker.right.equalTo(self.snp.right).offset(-appearance.titleLabelMargin)
            maker.bottom.equalTo(self.snp.bottom).offset(-appearance.titleLabelMargin)
        }
    }
}
