//
//  DrugGridCVCell.swift
//  Infoapteka
//
//  
//

import UIKit

protocol DrugGridCVCellDelegate {
    func changeIsFavorite(_ drug: Drug, _ sender: UIButton, _ animateViewTo: AnimateViewTo)
    func changeInBasket(_ drug: Drug, _ sender: UIButton, _ animateViewTo: AnimateViewTo)
}

extension DrugGridCVCellDelegate {
    func changeIsFavorite(_ drug: Drug, _ sender: UIButton, _ animateViewTo: AnimateViewTo, _ isAdded: Bool) {}
    func changeInBasket(_ drug: Drug, _ sender: UIButton, _ animateViewTo: AnimateViewTo, _ isAdded: Bool) {}
}

// MARK: Appearance
extension DrugGridCVCell {
    struct Appearance {
        let cellCornerRadius: CGFloat = 16.0
        let cellBackgroundColor: UIColor = Asset.mainWhite.color
        let cellLayerMaskToBounds: Bool = true
    }
}

class DrugGridCVCell: UICollectionViewCell {
    
    // MARK: - UI Components
    private lazy var cardTopView: CardTopView = {
        let view = CardTopView()
        return view
    }()
    
    private lazy var homeCardBottomView: HomeCardBottomView = {
        let view = HomeCardBottomView()
        view.delegate = self
        return view
    }()
    
    // MARK: Appearance
    private let appearance = Appearance()
    private var viewModel: CardVM?
    public var delegate  : DrugGridCVCellDelegate?
    private var drug: Drug? {
        didSet {
            guard let drug = drug else { return }
            cardTopView.setupView(drug)
            homeCardBottomView.setupView(.init(drug))
            setupConstraintsOfGridView(homeCardBottomView)
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
    
    private func setupUI() {
        contentView.backgroundColor = appearance.cellBackgroundColor
        contentView.layer.cornerRadius = appearance.cellCornerRadius
        contentView.layer.masksToBounds = appearance.cellLayerMaskToBounds
        contentView.addSubview(cardTopView)
    }
    
    
    fileprivate func setupConstraintsOfGridView(_ view: UIView) {
        cardTopView.snp.remakeConstraints { (maker) in
            maker.left.top.equalTo(contentView)
            maker.right.equalTo(contentView.snp.right)
        }
        
        contentView.addSubview(view)
        view.snp.remakeConstraints { (maker) in
            maker.top.equalTo(cardTopView.snp.bottom).offset(2)
            maker.left.right.equalTo(contentView)
            maker.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    func setupCell(_ viewModel: CardVM?) {
        self.viewModel = viewModel
        self.drug = viewModel?.getCard()
    }
    
    func setupCellStyle() {
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = Asset.light.color.cgColor
    }

    var basketBtn: UIButton {
        get { return homeCardBottomView.basketBtn }
    }

    var favouriteBtn: UIButton {
        get { return homeCardBottomView.favouriteBtn }
    }
}

extension DrugGridCVCell: HomeCardBottomViewDelegate {
    func didTappedOnFavouriteBtn(_ drug: Drug) {
        guard let viewModel = viewModel else { return }
        viewModel.favouriteUnFavourite(drug, { [weak self] isAdded in
            guard let self = self, let isAdded = isAdded else { return }
            self.drug = viewModel.changeCardFavourite(isAdded)

            guard let currentDrug = self.drug else { return }
            self.delegate?.changeIsFavorite(currentDrug, self.favouriteBtn, .toFavorite)
        })
    }
    
    func didTappedOnBasketBtn(_ drug: Drug) {
        guard let viewModel = viewModel else { return }
        viewModel.changeQuantity(drug) { [weak self] in
            guard let self = self else { return }
            self.drug = viewModel.getCard()

            guard let currentDrug = self.drug else { return }
            self.delegate?.changeInBasket(currentDrug, self.basketBtn, .toBasket)
        }
    }
}
