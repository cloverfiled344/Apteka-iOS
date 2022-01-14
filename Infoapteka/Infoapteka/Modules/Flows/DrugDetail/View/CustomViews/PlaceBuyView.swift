//
//  PlaceBuyView.swift
//  Infoapteka
//
//  
//

import UIKit

protocol PlaceBuyViewDelegate {
    func didTappedOnFavouriteBtn(_ drug: Drug?)
    func didTappedOnPurchaseBtn(_ drug: Drug?, _ type: DrugDetailBasketPushType)
}

// MARK: Appearance
extension PlaceBuyView {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color
        let centerViewCornerRadius: CGFloat = 16.0
        let btnCornerRadius: CGFloat = 12.0
        
        let maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let unselectedFavouriteBtn: UIImage = Asset.icUnselectedHeartPdf.image
        let selectedFavouriteBtn: UIImage = Asset.icSelectedHeartPdf.image
        let bottomLineColor: UIColor = Asset.secondaryLight.color
        
        let purchaseBtnBackground: UIColor = Asset.mainGreen.color
        let titleColor: UIColor = Asset.mainWhite.color
        let preOrderBackgroundColor: UIColor = Asset.orange.color
        let preOrderText: String = "Предзаказ"
    }
}

// MARK: UIView
class PlaceBuyView: UIView {
    
    // MARK: UI Components
    lazy private var favouriteBtn = UIButton().then {
        $0.contentVerticalAlignment = .center
        $0.contentHorizontalAlignment = .center
        $0.addTarget(self, action: #selector(didTappedOnFavourite), for: .touchUpInside)
    }
    
    private lazy var purchaseBtn = UIButton().then {
        $0.layer.cornerRadius = appearance.btnCornerRadius
        $0.addTarget(self, action: #selector(didTappedOnPurchaseBtn), for: .touchUpInside)
    }
    
    private lazy var bottomLine = UIView().then {
        $0.backgroundColor = appearance.bottomLineColor
    }
    
    // MARK: Properties
    var delegate: PlaceBuyViewDelegate?
    private let appearance = Appearance()
    private var drug: Drug? {
        didSet {
            guard let drug = drug, let price = drug.price else { return }
            favouriteBtn.setImage(drug.isFavorites ? appearance.selectedFavouriteBtn : appearance.unselectedFavouriteBtn, for: .normal)
            drug.isAvailable ? setupStyleOfButton(drug.isCart, price) : setupPreOrderBtnStyle()
        }
    }
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor     = appearance.backgroundColor
        layer.cornerRadius  = appearance.centerViewCornerRadius
        layer.maskedCorners = appearance.maskedCorners
        layer.shadowRadius = 16
        layer.shadowOffset = CGSize(width: 0, height: -3)

        addTopShadow(shadowColor: Asset.mainBlack.color.withAlphaComponent(0.15),
                     shadowOpacity: 1,
                     shadowRadius: 16,
                     offset: CGSize(width: 8.0,
                                    height : 0.0))

        addSubview(bottomLine)
        addSubview(favouriteBtn)
        addSubview(purchaseBtn)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    private func setupConstraints() {
        favouriteBtn.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(16.0)
            make.left.equalToSuperview().offset(12.0)
            make.width.equalTo(44.0)
        }

        purchaseBtn.snp.remakeConstraints { (make) in
            make.top.bottom.equalTo(favouriteBtn)
            make.right.equalToSuperview().offset(-12.0)
            make.left.equalTo(favouriteBtn.snp.right).offset(8.0)
        }

        bottomLine.snp.remakeConstraints { make in
            make.top.equalTo(favouriteBtn.snp.bottom).offset(16.0)
            make.bottom.lessThanOrEqualToSuperview().offset(-16.0)
            make.left.equalToSuperview().offset(20.0)
            make.right.equalToSuperview().offset(-20.0)
            make.height.equalTo(1.0)
        }
    }
    
    private func setupStyleOfButton(_ isCart: Bool, _ price: Int) {
        if isCart {
            purchaseBtn.backgroundColor = Asset.mainWhite.color
            purchaseBtn.layer.borderWidth = 1.0
            purchaseBtn.layer.borderColor = Asset.light.color.cgColor
            purchaseBtn.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 15)
            purchaseBtn.setImage(Asset.icUnselectedCart.image, for: .normal)
            purchaseBtn.setTitle("В корзине", for: .normal)
            purchaseBtn.setTitleColor(Asset.secondaryGray3.color, for: .normal)
        }
        else {
            purchaseBtn.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 15)
            purchaseBtn.backgroundColor = appearance.purchaseBtnBackground
            purchaseBtn.setImage(Asset.icWhiteBasket.image, for: .normal)
            purchaseBtn.setTitle("Купить за \(price) с", for: .normal)
            purchaseBtn.setTitleColor(Asset.mainWhite.color, for: .normal)
        }
    }
    
    private func setupPreOrderBtnStyle() {
        purchaseBtn.backgroundColor = appearance.preOrderBackgroundColor
        purchaseBtn.setTitle(appearance.preOrderText, for: .normal)
    }

    // MARK: SetupData
    func setupView(_ drug: Drug?) {
        self.drug = drug
    }
    
    // MARK: Actions
    @objc private func didTappedOnFavourite() {
        favouriteBtn.pulsate()
        delegate?.didTappedOnFavouriteBtn(drug)
    }
    
    @objc private func didTappedOnPurchaseBtn() {
        purchaseBtn.pulsate()
        delegate?.didTappedOnPurchaseBtn(drug, (drug?.isAvailable ?? false) ? .purchase : .preOrder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

