//
//  ListCardView.swift
//  Infoapteka
//
//  
//

import UIKit

protocol ListCardViewDelegate {
    func didTappedOnFavouriteBtn(_ drug: Drug)
    func didTappedOnBasketBtn(_ drug: Drug)
}

extension ListCardView {
    struct Appearance {
        let productIVContentMode: UIImageView.ContentMode = .scaleAspectFill
        let productPlaceholder: UIImage = Asset.icDefaultDrug.image
        let ivMaskToBounds: Bool = true
        let titleLabelTextColor: UIColor = Asset.mainBlack.color
        let companyNameTextColor: UIColor = Asset.secondaryGray3.color
        let titleLabelTextFont: UIFont = FontFamily.Inter.regular.font(size: 13)
        let titleLabelNumberOfLines: Int = 3
        let contentIVHeight: CGFloat = 125.0
    }
}

class ListCardView: UIView {
    
    // MARK: UI Components
    private lazy var homeCardBottomView: HomeCardBottomView = {
        let view = HomeCardBottomView()
        view.delegate = self
        return view
    }()
    
    private lazy var contentIV: UIImageView = {
        let view = UIImageView()
        view.contentMode = appearance.productIVContentMode
        view.layer.masksToBounds = appearance.ivMaskToBounds
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
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
            contentIV.load(drug.image ?? "", appearance.productPlaceholder)
            titleLabel.text        = drug.name
            companyNameLabel.text  = drug.owner?.firstName
            homeCardBottomView.setupView(.init(drug))
        }
    }
    var delegate: ListCardViewDelegate?
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup UI
    private func setupUI() {
        addSubview(contentIV)
        addSubview(titleLabel)
        addSubview(companyNameLabel)
        addSubview(homeCardBottomView)
        setConstraints()
    }
    
    private func setConstraints() {
        contentIV.snp.makeConstraints { (maker) in
            maker.top.left.equalTo(self)
            maker.height.width.equalTo(125)
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.snp.top).offset(12)
            maker.left.equalTo(contentIV.snp.right).offset(12)
            maker.right.equalTo(self.snp.right).offset(-12)
        }
        
        companyNameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(12)
            maker.left.equalTo(titleLabel.snp.left)
            maker.right.equalTo(titleLabel.snp.right)
        }
        
        homeCardBottomView.snp.makeConstraints { (maker) in
            maker.top.equalTo(companyNameLabel.snp.bottom).offset(12)
            maker.left.equalTo(titleLabel.snp.left)
            maker.right.equalTo(titleLabel.snp.right)
            maker.bottom.equalTo(self.snp.bottom).offset(-12)
        }
    }
    
    // MARK: Setup Data
    func setupView(_ drug: Drug?) {
        self.drug = drug
    }

    var basketBtn: UIButton {
        get { return homeCardBottomView.basketBtn }
    }

    var favouriteBtn: UIButton {
        get { return homeCardBottomView.favouriteBtn }
    }
}

// MARK: Card Actions
extension ListCardView: HomeCardBottomViewDelegate {
    func didTappedOnFavouriteBtn(_ drug: Drug) {
        delegate?.didTappedOnFavouriteBtn(drug)
    }

    func didTappedOnBasketBtn(_ drug: Drug) {
        delegate?.didTappedOnBasketBtn(drug)
    }
}
