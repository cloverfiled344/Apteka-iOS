//
//  HomeCardBottomView.swift
//  Infoapteka
//
//  
//

import UIKit

protocol HomeCardBottomViewDelegate {
    func didTappedOnFavouriteBtn(_ drug: Drug)
    func didTappedOnBasketBtn(_ drug: Drug)
}

// MARK: Appearance
extension HomeCardBottomView {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color
        let priceTextColor: UIColor = Asset.mainBlack.color
        let priceTextFont: UIFont = FontFamily.Inter.bold.font(size: 12)
        let editButtonImage: UIImage = Asset.icProductEditButton.image
        let priceTitleLabelNumberOfLines: Int = 3
        let unselectedFavourite: UIImage = Asset.icUnselectedHeart.image
        let selectedFavourite: UIImage = Asset.icSelectedHeart.image
        let favouriteBtnBorderWidth  : CGFloat = 1.0
        let favouriteBtnCornerRadius : CGFloat = 8.0
        let favouriteBtnBorderColor  : CGColor = Asset.favouriteBtnBorder.color.cgColor

        let unselectedBasket: UIImage = Asset.icUnselectedBasket.image
        let selectedBasket: UIImage = Asset.icSelectedBasket.image
        let preProductTextColor: UIColor = Asset.orange.color
        let preProductTextFont: UIFont = FontFamily.Inter.semiBold.font(size: 12)
        let preProductText: String = L10n.preProduct
    }
}

class HomeCardBottomView: UIView {
    
    // MARK: UI Components
    private lazy var priceLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = appearance.priceTitleLabelNumberOfLines
        return view
    }()
    
    private lazy var favouriteButton: UIButton = {
        let view = UIButton()
        view.layer.borderWidth = appearance.favouriteBtnBorderWidth
        view.layer.borderColor = appearance.favouriteBtnBorderColor
        view.layer.cornerRadius = appearance.favouriteBtnCornerRadius
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(didTappedOnFavourite), for: .touchUpInside)
        return view
    }()
    
    private lazy var basketButton: UIButton = {
        let view = UIButton()
        view.setImage(appearance.unselectedBasket, for: .normal)
        view.setImage(appearance.selectedBasket, for: .highlighted)
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(didTappedOnBasket), for: .touchUpInside)
        return view
    }()
    
    // MARK: Properties
    private var cardVM: CardVM?
    private let appearance = Appearance()
    private var drug: Drug? {
        didSet {
            guard let drug = drug else { return }

            setupContent(drug.isOwner, !drug.isAvailable)
            setAttrToPrice(priceLabel, drug.price, appearance.preProductText, drug.isAvailable)
            
            favouriteButton.setImage(drug.isFavorites ? appearance.selectedFavourite : appearance.unselectedFavourite, for: .normal)
            basketButton.setImage(drug.isCart ? appearance.selectedBasket : appearance.unselectedBasket, for: .normal)
        }
    }
    var delegate: HomeCardBottomViewDelegate?
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = appearance.backgroundColor
        addSubview(priceLabel)
        addSubview(favouriteButton)
        addSubview(basketButton)
    }
    
    private func setupContent(_ isOwner: Bool, _ isAvailable: Bool) {
        basketButton.alpha      = isOwner  ? 0.5 : 1
        basketButton.isEnabled  = !isOwner
        basketButton.snp.remakeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.height.width.equalTo(28)
            maker.right.equalTo(snp.right).offset(-8)
            maker.bottom.equalTo(snp.bottom).offset(-8)
        }
        
        basketButton.isHidden = isAvailable
        
        favouriteButton.snp.remakeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.height.width.equalTo(28)
            maker.right.equalTo(!isAvailable ? basketButton.snp.left : snp.right ).offset(!isAvailable ? -4 : -8)
            maker.bottom.equalTo(snp.bottom).offset(-8)
        }
        
        priceLabel.snp.remakeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.left.equalTo(snp.left).offset(8)
            maker.bottom.equalTo(snp.bottom).offset(-4)
        }
    }
    
    private func setAttrToPrice(_ label: UILabel,
                                _ price: Int?, _ preProductTitle: String, _ isAvailable: Bool) {
        let attr = NSMutableAttributedString(string: "\(price ?? .zero) с", attributes: [.font: appearance.priceTextFont, .foregroundColor: appearance.priceTextColor])
        if !isAvailable {
            attr.append(.init(string: "\n\(preProductTitle)", attributes: [.font: appearance.preProductTextFont, .foregroundColor: appearance.preProductTextColor]))
        }
        label.attributedText = attr
    }
    
    func setupView(_ viewModel: CardVM?) {
        self.cardVM = viewModel
        self.drug = viewModel?.getCard()
    }
    
    @objc private func didTappedOnFavourite() {
        guard let drug = drug else { return }
        favouriteButton.pulsate()
        delegate?.didTappedOnFavouriteBtn(drug)
    }
    
    @objc private func didTappedOnBasket() {
        guard let drug = drug else { return }
        basketButton.pulsate()
        delegate?.didTappedOnBasketBtn(drug)
    }

    var basketBtn: UIButton {
        get { return basketButton }
    }

    var favouriteBtn: UIButton {
        get { return favouriteButton }
    }
}
