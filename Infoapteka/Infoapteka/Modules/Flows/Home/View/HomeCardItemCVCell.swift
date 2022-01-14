//
//  HomeCardItemCVCell.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK: Appearance
extension HomeCardItemCVCell {
    struct Appearance {
        let contentViewCornerRadius: CGFloat = 12.0
        let contentViewBorderWidth: CGFloat = 1.0
        let contentViewBorderColor: UIColor = Asset.light.color
        let backgroundColor: UIColor = Asset.mainWhite.color
        let imageViewContenMode: UIImageView.ContentMode = .scaleAspectFill
        let imageViewMaskToBounds: Bool = true
        let titleTextColor: UIColor = Asset.mainBlack.color
        let titleTextFont: UIFont = FontFamily.Inter.semiBold.font(size: 12)
        let subtitleTextColor: UIColor = Asset.secondaryGray3.color
        let subtitleTextFont: UIFont = FontFamily.Inter.regular.font(size: 11)
        let titleLabelNumberOfLines: Int = .zero
    }
}

class HomeCardItemCVCell: UICollectionViewCell {
    
    private lazy var iconIV: UIImageView = {
        let view = UIImageView()
        view.contentMode = appearance.imageViewContenMode
        view.layer.masksToBounds = appearance.imageViewMaskToBounds
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = appearance.titleLabelNumberOfLines
        return view
    }()
    
    // MARK: Properties
    private let appearance = Appearance()
    private var instruction: Instruction? {
        didSet {
            guard let instruction = instruction else { return }
            self.iconIV.image = instruction.image
            self.setAttribute(titleLabel, instruction.title, instruction.subtitle)
        }
    }
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup UI
extension HomeCardItemCVCell {
    private func setupUI() {
        contentView.backgroundColor    = appearance.backgroundColor
        contentView.layer.cornerRadius = appearance.contentViewCornerRadius
        contentView.layer.borderWidth  = appearance.contentViewBorderWidth
        contentView.layer.borderColor  = appearance.contentViewBorderColor.cgColor

        contentView.addSubview(iconIV)
        contentView.addSubview(titleLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        self.iconIV.snp.makeConstraints { (maker) in
            maker.top.left.equalTo(self.contentView).offset(10)
            maker.height.width.equalTo(32)
        }
        
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.iconIV.snp.bottom).offset(10)
            maker.left.equalTo(iconIV.snp.left)
            maker.right.equalTo(self.contentView.snp.right).offset(-10)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-20)
        }
    }
    
    private func setAttribute(_ label: UILabel, _ title: String, _ subtitle: String) {
        let attr = NSMutableAttributedString(string: title,
                                             attributes: [.font: appearance.titleTextFont,
                                                          .foregroundColor: appearance.titleTextColor])
        attr.append(.init(string: "\n\(subtitle)",
                          attributes: [.font: appearance.subtitleTextFont,
                                       .foregroundColor: appearance.subtitleTextColor]))
        label.attributedText = attr
    }
    
    func setCardItem(_ instruction: Instruction?) {
        self.instruction = instruction
    }
}
