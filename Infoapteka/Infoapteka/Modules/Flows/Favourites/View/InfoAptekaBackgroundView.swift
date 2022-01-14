//
//  InfoAptekaBackgroundView.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK: Appearance
extension InfoAptekaBackgroundView {
    
    struct Appearance {
        let bacakgroundColor: UIColor = Asset.backgroundGray.color
        let iconContentMode: UIImageView.ContentMode = .scaleAspectFill
        let iconIVHeight: CGFloat = Constants.screenWidth - 176
        let iconIVWidht: CGFloat = Constants.screenWidth - 164
        let titleTextFont: UIFont = FontFamily.Inter.bold.font(size: 15)
        let titleTextColor: UIColor = Asset.secondaryGray.color
        let titleNumberOfLines: Int = .zero
        let titleTextAlignment: NSTextAlignment = .center
    }
}

class InfoAptekaBackgroundView: UIView {
    
    // MARK: UI Components
    private lazy var iconIV: UIImageView = {
        let view = UIImageView()
        view.contentMode = appearance.iconContentMode
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = appearance.titleTextFont
        view.textColor = appearance.titleTextColor
        view.numberOfLines = appearance.titleNumberOfLines
        view.textAlignment = appearance.titleTextAlignment
        return view
    }()
    
    // MARK: Properties
    private let appearance = Appearance()
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = appearance.bacakgroundColor
        self.addSubview(iconIV)
        self.addSubview(titleLabel)
        self.setConstraints()
    }
    
    private func setConstraints() {
        iconIV.snp.makeConstraints { (maker) in
            maker.height.equalTo(appearance.iconIVHeight)
            maker.width.equalTo(appearance.iconIVWidht)
            maker.centerX.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(iconIV.snp.bottom).offset(8)
            maker.left.equalTo(snp.left).offset(20)
            maker.right.equalTo(snp.right).offset(-20)
        }
    }
    
    func setupView(_ image: ImageAsset.Image, _ title: String) {
        iconIV.image = image
        titleLabel.text = title
    }
}
