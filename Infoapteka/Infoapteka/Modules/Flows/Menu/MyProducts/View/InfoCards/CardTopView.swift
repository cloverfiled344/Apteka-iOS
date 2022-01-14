//
//  CardTopView.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK: Appearance
extension CardTopView {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color
        let ivMaskToBounds: Bool = true
        let productPlaceholder: UIImage = Asset.icDefaultDrug.image
        let productIVContentMode: UIImageView.ContentMode = .scaleAspectFill
        let productIVHeightWidth: CGFloat = 183.0
        let titleLabelTextColor: UIColor = Asset.mainBlack.color
        let titleLabelTextFont: UIFont = FontFamily.Inter.regular.font(size: 13)
        let titleLabelNumberOfLines: Int = 3
        let companyNameTextColor: UIColor = Asset.secondaryGray3.color
    }
}

class CardTopView: UIView {
    
    // MARK: UI Components
    private lazy var productIV: UIImageView = {
        let view = UIImageView()
        view.contentMode = appearance.productIVContentMode
        view.layer.masksToBounds = appearance.ivMaskToBounds
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = appearance.titleLabelNumberOfLines
        view.textColor = appearance.titleLabelTextColor
        view.font = appearance.titleLabelTextFont
        return view
    }()
    
    private lazy var companyNameLabel: UILabel = {
        let view = UILabel()
        view.textColor = appearance.companyNameTextColor
        view.font = appearance.titleLabelTextFont
        return view
    }()
    
    // MARK: Properties
    private let appearance = Appearance()
    private var drug: Drug? {
        didSet {
            guard let drug = drug else { return }
            productIV.load(drug.image ?? "", appearance.productPlaceholder)
            titleLabel.text        = drug.name
            companyNameLabel.text  = drug.owner?.firstName ?? ""
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup UI
    private func setupUI() {
        backgroundColor = appearance.backgroundColor
        addSubview(productIV)
        addSubview(titleLabel)
        addSubview(companyNameLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        productIV.snp.remakeConstraints { (maker) in
            maker.top.left.right.equalToSuperview()
            maker.height.equalTo(frame.size.width)
        }

        titleLabel.snp.remakeConstraints { (maker) in
            maker.top.equalTo(productIV.snp.bottom)
            maker.left.equalTo(snp.left).offset(8)
            maker.right.equalTo(snp.right).offset(-8)
        }

        companyNameLabel.snp.remakeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom)
            maker.left.equalTo(titleLabel.snp.left)
            maker.right.equalTo(titleLabel.snp.right)
            maker.bottom.lessThanOrEqualTo(snp.bottom).offset(-6)
        }

    }
    
    func setupView(_ drug: Drug?) {
        self.drug = drug
    }
}

