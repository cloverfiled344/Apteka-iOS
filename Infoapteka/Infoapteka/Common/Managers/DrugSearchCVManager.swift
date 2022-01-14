//
//  DrugSearchCVManager.swift
//  Infoapteka
//
//

import UIKit
import PinterestLayout

protocol DrugSearchCVManagerDelegate {
    func didSelectFilterView()
    func changeCollectionType(_ collectionType: CollectionType)
    func paginateDrugs()
    func addedToBasket(_ sender: UIButton, _ animateViewTo: AnimateViewTo, _ isAdded: Bool)
    func addedToFavourite(_ sender: UIButton, _ animateViewTo: AnimateViewTo, _ isAdded: Bool)
    func pushToDrugSearchDetail(_ drug: Drug?)
}

class DrugSearchCVManager: NSObject, PinterestLayoutDelegate {

    // MARK: UI Components
    private lazy var backView : InfoAptekaBackgroundView = {
        let view = InfoAptekaBackgroundView()
        view.setupView(Asset.icSearchResult.image, "Результатов не найдено")
        return view
    }()
    
    private var viewModel: DrugSearchVM
    var delegate: DrugSearchCVManagerDelegate?

    init(_ viewModel: DrugSearchVM) {
        self.viewModel = viewModel
    }

    func setup(completion: @escaping () -> ()) {
        viewModel.drugResult.next = nil
        switch viewModel.showType {
        case .search:
            viewModel.search(true) { completion() }
        case .ownerProfile:
            viewModel.getOwner { completion() }
        }
    }
}

// MARK: UICollectionViewDataSource and UICollectionViewDelegate
extension DrugSearchCVManager: UICollectionViewDelegate,
                               UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch viewModel.drugsCount {
        case .zero:
            backView.frame = collectionView.bounds
            collectionView.backgroundView = backView
            return .zero
        default:
            collectionView.removeNoDataPlaceholder()
            return viewModel.drugsCount
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        viewModel.makeHaederView(self, collectionView, indexPath)
    }

    func collectionView(collectionView: UICollectionView,
                        sizeForSectionHeaderViewForSection section: Int) -> CGSize {
        let ownerInfoViewHeight: CGFloat = 145.0
        let filterViewHeight: CGFloat = 116.0
        let height: CGFloat = viewModel.owner != nil ? (ownerInfoViewHeight + filterViewHeight) : filterViewHeight
        return .init(width: collectionView.frame.size.width,
                     height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.isPaginationNeeded(indexPath) {
            let cell = collectionView.dequeueReusableCell(IndicatorCell.self, indexPath)
            cell.setup()
            viewModel.isLoading = true
            viewModel.search(false) { self.delegate?.paginateDrugs() }
            return cell
        } else {
            guard let drug = viewModel.getDrug(indexPath.row) else { return .init() }
            switch viewModel.collectionType {
            case .grid:
                let cell = collectionView.dequeueReusableCell(DrugGridCVCell.self, indexPath)
                cell.setupCell(.init(drug))
                cell.delegate = self
                return cell
            case .list:
                let cell = collectionView.dequeueReusableCell(DrugListCVCell.self, indexPath)
                cell.setupCell(.init(drug))
                cell.delegate = self
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.pushToDrugSearchDetail(viewModel.getDrug(indexPath.row))
    }

    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        switch viewModel.collectionType {
        case .grid:
            return collectionView.heightForDrugCVCellAtIndexPath(indexPath,
                                                                 viewModel.drugResult,
                                                                 collectionView)
        case .list:
            return 140.0
        }
    }

    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
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

// MARK: Card Actions
extension DrugSearchCVManager: DrugGridCVCellDelegate, DrugListCVCellDelegate {
    func changeInBasket(_ drug: Drug,
                        _ sender: UIButton,
                        _ animateViewTo: AnimateViewTo) {
        viewModel.replaceDrugById(drug)
        delegate?.addedToBasket(sender, animateViewTo, drug.isCart)
    }

    func changeIsFavorite(_ drug: Drug,
                          _ sender: UIButton,
                          _ animateViewTo: AnimateViewTo) {
        viewModel.replaceDrugById(drug)
        delegate?.addedToFavourite(sender, animateViewTo, drug.isFavorites)
    }
}

// MARK: Search Actions
extension DrugSearchCVManager: DrugSearchCVHeaderDelegate {
    func didSelectFilterView() {
        delegate?.didSelectFilterView()
    }

    func didSelectGridTypeIV() {
        delegate?.changeCollectionType(.grid)
    }
    
    func didSelectListTypeIV() {
        delegate?.changeCollectionType(.list)
    }
}
