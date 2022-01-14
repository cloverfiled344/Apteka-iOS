//
//  DrugListCVCell.swift
//  Infoapteka
//
//  
//

import UIKit

protocol DrugListCVCellDelegate {
    func changeIsFavorite(_ drug: Drug, _ sender: UIButton, _ animateViewTo: AnimateViewTo)
    func changeInBasket(_ drug: Drug, _ sender: UIButton, _ animateViewTo: AnimateViewTo)
}

extension DrugListCVCellDelegate {
    func changeIsFavorite(_ drug: Drug, _ sender: UIButton, _ animateViewTo: AnimateViewTo) {}
    func changeInBasket(_ drug: Drug, _ sender: UIButton, _ animateViewTo: AnimateViewTo) {}
}

extension DrugListCVCell {
    struct Appearance {
        let cellCornerRadius: CGFloat = 16.0
        let cellBackgroundColor: UIColor = Asset.mainWhite.color
        let cellLayerMaskToBounds: Bool = true
    }
}

class DrugListCVCell: UICollectionViewCell {
    
    // MARK: UI Components
    private lazy var listView: ListCardView = {
        let view = ListCardView()
        view.delegate = self
        return view
    }()
    
    // MARK: Properties
    private let appearance = Appearance()
    private var viewModel: CardVM?
    private var drug: Drug? {
        didSet {
            self.listView.setupView(drug)
        }
    }

    var delegate: DrugListCVCellDelegate?
    
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
        contentView.addSubview(listView)
        listView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(contentView)
        }
    }
    
    func setupCell(_ viewModel: CardVM) {
        self.viewModel = viewModel
        self.drug = viewModel.getCard()
    }

    var basketBtn: UIButton {
        get { return listView.basketBtn }
    }

    var favouriteBtn: UIButton {
        get { return listView.favouriteBtn }
    }
}

extension DrugListCVCell: ListCardViewDelegate {
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
