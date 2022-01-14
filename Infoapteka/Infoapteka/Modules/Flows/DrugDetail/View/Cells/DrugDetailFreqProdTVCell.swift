//
//  DrugDetailFreqProdTVCell.swift
//  Infoapteka
//
//  
//

import UIKit
import PinterestLayout

protocol DrugDetailFreqProdTVCellDelegate {
    func changeInBasket(_ drug: Drug, _ sender: UIButton, _ collectionView: UICollectionView, _ animateViewTo: AnimateViewTo)
    func changeIsFavorite(_ drug: Drug, _ sender: UIButton, _ collectionView: UICollectionView, _ animateViewTo: AnimateViewTo)
    func pushToDrugDetail(_ drug: Drug)
}

// MARK: Appearance
extension DrugDetailFreqProdTVCell {
    
    struct Appearance {
        let selectionStyle: UITableViewCell.SelectionStyle = .none
        let backgroundColor: UIColor = Asset.mainWhite.color
    }
}

// MARK: UITableViewCell
class DrugDetailFreqProdTVCell: UITableViewCell {
    
    // MARK: UI Components
    private lazy var freqProductsCV: FrequentlyProductsCV = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = FrequentlyProductsCV(frame: .zero, collectionViewLayout: layout)
        view._delegate = self
        return view
    }()
    
    // MARK: Properties
    public var delegate: DrugDetailFreqProdTVCellDelegate?
    private let appearance = Appearance()
    private var similarProducts: [Drug] = [] {
        didSet {
            self.freqProductsCV.setupCV(similarProducts)
            setConstraints()
        }
    }
    
    // MARK: Initalize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup Data
    func setupCell(_ similarProducts: [Drug]) {
        self.similarProducts = similarProducts
    }
}

// MARK: Setup UI
extension DrugDetailFreqProdTVCell {
    
    private func setupUI() {
        selectionStyle = appearance.selectionStyle
        contentView.addSubview(freqProductsCV)
    }
    
    private func setConstraints() {
        freqProductsCV.snp.remakeConstraints { (maker) in
            maker.top.equalTo(contentView.snp.top)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.equalTo(contentView.snp.right)
            maker.height.equalTo(similarProducts.isEmpty ? .zero : Constants.screenWidth - 98.0)
            maker.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }
}

extension DrugDetailFreqProdTVCell: FrequentlyProductsCVDelegate {

    func changeInBasket(_ drug: Drug, _ sender: UIButton, _ collectionView: UICollectionView, _ animateViewTo: AnimateViewTo) {
        delegate?.changeInBasket(drug, sender, collectionView, animateViewTo)
    }
    
    func changeIsFavorite(_ drug: Drug, _ sender: UIButton, _ collectionView: UICollectionView, _ animateViewTo: AnimateViewTo) {
        delegate?.changeIsFavorite(drug, sender, collectionView, animateViewTo)
    }
    
    func pushToDrugDetail(_ drug: Drug) {
        delegate?.pushToDrugDetail(drug)
    }
}
