//
//  FavouritesCVManager.swift
//  Infoapteka
//
//  
//

import UIKit
import PinterestLayout

protocol FavouritesCVManagerDelegate {
    func paginateDrugs()
    func changeIsFavorite(_ drug: Drug)
    func changeInBasket(_ drug: Drug, _ sender: UIButton, _ animateViewTo: AnimateViewTo, _ isAdded: Bool)
    func pushToFavouriteDetailPage(_ drug: Drug?)
}

class FavouritesCVManager: NSObject {
    
    // MARK: UI Components
    private lazy var backView : InfoAptekaBackgroundView = {
        let view = InfoAptekaBackgroundView()
        view.setupView(Asset.icEmptyFavourites.image, L10n.emptyFavourites)
        return view
    }()
    
    private var viewModel: FavouritesVM
    var delegate: FavouritesCVManagerDelegate?
    
    init(_ viewModel: FavouritesVM) {
        self.viewModel = viewModel
    }
    
    func setup(_ completion: @escaping() -> Void) {
        viewModel.drugResult.next = nil
        viewModel.getFavourties(true) {
            completion()
        }
    }
}

// MARK: UICollectionViewDataSource and UICollectionViewDelegate
extension FavouritesCVManager: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch viewModel.getDrugsCount() {
        case .zero:
            backView.frame = collectionView.bounds
            collectionView.backgroundView = backView
            return .zero
        default:
            collectionView.removeNoDataPlaceholder()
            return viewModel.getDrugsCount()
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.pushToFavouriteDetailPage(viewModel.getDrug(indexPath.row))
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.isPaginationNeeded(indexPath) {
            let cell = collectionView.dequeueReusableCell(IndicatorCell.self, indexPath)
            cell.setup()
            viewModel.isLoading = true
            viewModel.getFavourties(false) { self.delegate?.paginateDrugs() }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(DrugGridCVCell.self, indexPath)
            cell.setupCell(.init(viewModel.getDrug(indexPath.row)))
            cell.delegate = self
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard !viewModel.isLoading else { return }
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 200, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard !viewModel.isLoading else { return .zero }
        let numberOfCellsInRow = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfCellsInRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfCellsInRow))
        return CGSize(width: size, height: size)
    }
}

// MARK: PinterestLayout Delegate
extension FavouritesCVManager: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return collectionView.heightForDrugCVCellAtIndexPath(indexPath,
                                                             viewModel.drugResult,
                                                             collectionView)
    }

    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return .zero
    }
}

extension FavouritesCVManager: DrugGridCVCellDelegate {
    func changeInBasket(_ drug: Drug, _ sender: UIButton, _ animateViewTo: AnimateViewTo) {
        delegate?.changeInBasket(drug, sender, animateViewTo, drug.isCart)
    }

    func changeIsFavorite(_ drug: Drug, _ sender: UIButton, _ animateViewTo: AnimateViewTo) {
        delegate?.changeIsFavorite(drug)
    }
}
