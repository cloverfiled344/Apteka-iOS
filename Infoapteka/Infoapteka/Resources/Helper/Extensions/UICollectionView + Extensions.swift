//
//  UICollectionView + Extensions.swift
//  Infoapteka
//
//  
//

import UIKit

extension UICollectionView {
    func heightForDrugCVCellAtIndexPath(_ indexPath: IndexPath,
                                        _ drugResult: DrugResult?,
                                        _ collectionView: UICollectionView) -> CGFloat {
        var totalHeight: CGFloat = .zero

        let offsets         : CGFloat = 48.0
        let bottomViewHeight: CGFloat = 70.0

        let cellWidth: CGFloat = (collectionView.bounds.size.width - offsets) / 2
        totalHeight = totalHeight + cellWidth

        let drugNameHeight = drugResult?.results[indexPath.row].name?
            .height(withConstrainedWidth: cellWidth - 16,
                    font: FontFamily.Inter.regular.font(size: 13)) ?? .zero

        totalHeight += drugNameHeight > 62 ? 62 : drugNameHeight

        let ownerNameHeight = drugResult?.results[indexPath.row].ownerName?.height(withConstrainedWidth: cellWidth - 16,
                    font: FontFamily.Inter.regular.font(size: 13)) ?? .zero
        totalHeight += ownerNameHeight > 36 ? 36 : ownerNameHeight

        totalHeight += bottomViewHeight
        return totalHeight
    }
}

extension UICollectionView {

    func registerdequeueReusableCell<T: UICollectionViewCell>(_ cellType: T.Type) {
        let className = String(describing: cellType)
        let identifier = className + "ID"
        register(cellType, forCellWithReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(_ cellType: T.Type,
                                                      _ indexPath: IndexPath) -> T {
        let className = String(describing: cellType)
        let identifier = className + "ID"
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }

    func registerdequeueReusableHeader<T: UICollectionReusableView>(_ cellType: T.Type) {
        let className = String(describing: cellType)
        let identifier = className + "ID"
        register(cellType, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    func registerdequeueReusableFooter<T: UICollectionReusableView>(_ cellType: T.Type) {
        let className = String(describing: cellType)
        let identifier = className + "ID"
        register(cellType, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
    }

    func dequeueReusableHeader<T: UICollectionReusableView>(_ cellType: T.Type,
                                                            _ indexPath: IndexPath) -> T {
        let className = String(describing: cellType)
        let identifier = className + "ID"
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                withReuseIdentifier: identifier, for: indexPath) as! T
    }

    func dequeueReusableFooter<T: UICollectionReusableView>(_ cellType: T.Type,
                                                            _ indexPath: IndexPath) -> T {
        let className = String(describing: cellType)
        let identifier = className + "ID"
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                withReuseIdentifier: identifier, for: indexPath) as! T
    }
    
    func removeNoDataPlaceholder() {
        self.isScrollEnabled = true
        self.backgroundView = nil
    }
}



