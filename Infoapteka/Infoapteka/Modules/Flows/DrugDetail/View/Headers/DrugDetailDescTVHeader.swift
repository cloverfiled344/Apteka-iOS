//
//  DrugDetailDescTVHeader.swift
//  Infoapteka
//
//  
//

import UIKit

protocol DrugDetailDescTVHeaderDelegate {
    func didTappedOnCompanyNameBtn(_ ownerID: Int)
}

// MARK: Appearance
extension DrugDetailDescTVHeader {
    struct Appearance {
        let backgroundColor:            UIColor = Asset.mainWhite.color
        let companyNameBtnLayerCorner:  CGFloat = 16.0
        let btnBorderWidth:             CGFloat = 1.0
        let btnBorderWidthColor:        CGColor = Asset.light.color.cgColor
        let companyOwner:               UIImage = Asset.icCompanyOwner.image
        let companyOnwerColor:          UIColor = Asset.mainBlue.color
        let companyOwnerFont:           UIFont  = FontFamily.Inter.regular.font(size: 13.0)
        let titleNumberOfLines:         Int     = 3
        let drugNameTextFont:           UIFont  = FontFamily.Inter.bold.font(size: 20.0)
        let drugNameTextColor:          UIColor = Asset.mainBlack.color
        let priceTextFont:              UIFont  = FontFamily.Inter.bold.font(size: 20.0)
        let priceTextColor:             UIColor = Asset.mainGreen.color
    }
}

class DrugDetailDescTVHeader: UITableViewHeaderFooterView {
    
    // MARK: UI Components
    private lazy var companyNameBtn = UIButton().then {
        $0.setTitleColor(appearance.companyOnwerColor, for: .normal)
        $0.titleLabel?.font = appearance.companyOwnerFont
        $0.contentEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
        $0.titleEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: -8)
        $0.sizeToFit()
        $0.addTarget(self, action: #selector(didTappedOnCompanyNameBtn), for: .touchUpInside)
    }
    
    private lazy var drugNameLbl = UILabel().then {
        $0.numberOfLines = appearance.titleNumberOfLines
        $0.font = appearance.drugNameTextFont
        $0.textColor = appearance.drugNameTextColor
    }
    
    private lazy var priceLbl = UILabel().then {
        $0.font = appearance.priceTextFont
        $0.textColor = appearance.priceTextColor
    }
    
    // MARK: Properties
    public var delegate: DrugDetailDescTVHeaderDelegate?
    private let appearance = Appearance()

    private var drug: Drug? {
        didSet {
            guard let drugDetail = drug else { return }
            companyNameBtn.setTitle(drugDetail.owner?.firstName, for: .normal)
            drugNameLbl.text = drugDetail.name
            setupPriceLbl(drugDetail.price)
            setupCompanyBtnStyle(appearance.companyOwner)
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup Data
    func setupCell(_ drug: Drug?) {
        self.drug = drug
    }
}

// MARK: Setup UI
extension DrugDetailDescTVHeader {
    private func setupUI() {
        contentView.backgroundColor = appearance.backgroundColor
        contentView.addSubview(companyNameBtn)
        contentView.addSubview(drugNameLbl)
        contentView.addSubview(priceLbl)

        companyNameBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView.snp.top)
            maker.left.equalTo(contentView.snp.left).offset(20.0)
            maker.height.equalTo(35.0)
        }

        drugNameLbl.snp.makeConstraints { (maker) in
            maker.top.equalTo(companyNameBtn.snp.bottom).offset(12.0)
            maker.left.equalTo(contentView.snp.left).offset(20.0)
            maker.right.equalTo(contentView.snp.right).offset(-20.0)
        }

        priceLbl.snp.makeConstraints { (maker) in
            maker.top.equalTo(drugNameLbl.snp.bottom).offset(16.0)
            maker.left.equalTo(contentView.snp.left).offset(20.0)
            maker.right.equalTo(contentView.snp.right).offset(-20.0)
            maker.bottom.equalTo(contentView.snp.bottom).offset(-12.0)
        }
    }
    
    private func setupCompanyBtnStyle(_ icon: ImageAsset.Image) {
        companyNameBtn.layer.cornerRadius = appearance.companyNameBtnLayerCorner
        companyNameBtn.layer.borderWidth = appearance.btnBorderWidth
        companyNameBtn.layer.borderColor = appearance.btnBorderWidthColor
        companyNameBtn.setImage(icon, for: .normal)
    }
    
    private func setupPriceLbl(_ price: Int?) {
        if let price = price {
            self.priceLbl.text = "\(price) сом"
        }
    }
    
    @objc private func didTappedOnCompanyNameBtn() {
        companyNameBtn.pulsate()
        guard let ownerID = drug?.owner?.id else { return }
        delegate?.didTappedOnCompanyNameBtn(ownerID)
    }
}
