//
//  BannerCVCell.swift
//  Infoapteka
//
//  
//

import UIKit

extension BannerCVCell { 
    struct Appearance {
        let contentIV: UIImageView.ContentMode = .scaleAspectFill
        let contentViewCornerRadius: CGFloat = 12.0
        let masksToBounds: Bool = true
        let placeHolderImage: UIImage = Asset.icDefaultDrug.image
    }
}

class BannerCVCell: UICollectionViewCell {

    private lazy var contentIV: UIImageView = {
        let view = UIImageView()
        view.contentMode = appearance.contentIV
        view.layer.masksToBounds = appearance.masksToBounds
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: Appearance
    private let appearance = Appearance()
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(contentIV)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentIV.layer.cornerRadius = appearance.contentViewCornerRadius
        contentIV.snp.remakeConstraints { (maker) in
            maker.top.bottom.equalTo(contentView)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.equalTo(contentView.snp.right).offset(-20)
        }
    }
    
    func setupImage(_ image: String?) {
        contentIV.load(image ?? "", appearance.placeHolderImage)
    }
}
