//
//  FrequentlyProductsCV.swift
//  Infoapteka
//
//  
//

import UIKit

protocol FrequentlyProductsCVDelegate {
    func changeInBasket(_ drug: Drug, _ sender: UIButton, _ collectionView: UICollectionView, _ animateViewTo: AnimateViewTo)
    func changeIsFavorite(_ drug: Drug, _ sender: UIButton, _ collectionView: UICollectionView, _ animateViewTo: AnimateViewTo)
    func pushToDrugDetail(_ drug: Drug)
}

extension FrequentlyProductsCV {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color
    }
}

// MARK: CollectionView
class FrequentlyProductsCV: UICollectionView {
    
    // MARK: Properties
    public var _delegate: FrequentlyProductsCVDelegate?
    private let appearance = Appearance()
    private var similarProducts: [Drug] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    // MARK: Initialize
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        collectionViewLayout.collectionView?.backgroundColor = appearance.backgroundColor
        collectionViewLayout.collectionView?.registerdequeueReusableCell(DrugGridCVCell.self)
        collectionViewLayout.collectionView?.dataSource = self
        collectionViewLayout.collectionView?.delegate = self
    }
    
    // MARK: Pass data to this method
    func setupCV(_ similarProducts: [Drug]) {
        self.similarProducts = similarProducts
    }
}

// MARK: Setup CollectionView with dataSource and delegate
extension FrequentlyProductsCV: UICollectionViewDataSource,
                                UICollectionViewDelegate,
                                UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return similarProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(DrugGridCVCell.self, indexPath)
        cell.setupCellStyle()
        cell.setupCell(.init(similarProducts[indexPath.row]))
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        _delegate?.pushToDrugDetail(similarProducts[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // MARK: Calculate with using Figma
        let width: CGFloat = (collectionView.frame.size.width - 48)/2
        let height: CGFloat = width * 1.7
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
}

extension FrequentlyProductsCV: DrugGridCVCellDelegate {
    
    func changeInBasket(_ drug: Drug, _ sender: UIButton, _ animateViewTo: AnimateViewTo) {
        _delegate?.changeInBasket(drug, sender, collectionViewLayout.collectionView ?? .init(), animateViewTo)
    }
    
    func changeIsFavorite(_ drug: Drug, _ sender: UIButton, _ animateViewTo: AnimateViewTo) {
        _delegate?.changeIsFavorite(drug, sender, collectionViewLayout.collectionView ?? .init(), animateViewTo)
    }
    
    func replaceDrugById(_ drug: Drug) {
        let drugIndex = similarProducts.firstIndex { $0.id == drug.id }
        guard let index = drugIndex else { return }
        similarProducts[index] = drug
    }
}
