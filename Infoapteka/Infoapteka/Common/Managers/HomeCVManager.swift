//
//  HomeCVManager.swift
//  Infoapteka
//
//

import UIKit
import PinterestLayout

// MARK: HomeManager Delegate
protocol HomeCVManagerDelegate {
    func paginateDrugs()
    func pushToDrugDetail(_ drug: Drug?)
    func addedToBasket(_ sender: UIButton, _ animateViewTo: AnimateViewTo, _ isAdded: Bool)
    func addedToFavourite(_ sender: UIButton, _ animateViewTo: AnimateViewTo, _ isAdded: Bool)
    func pushToMapPage()
    func pushToDeliveryPage(_ programPolicy: PrivacyPolicy?)
    func pushToInstructionPage(_ programPolicy: PrivacyPolicy?)
    func openBannerByLink(_ url: String)
}

// MARK: Appearance
extension HomeCVManager {
    struct Appearance {}
}

class HomeCVManager: NSObject, PinterestLayoutDelegate {
    
    private var appearance = Appearance()
    private var viewModel: HomeVM
    private var isLoading: Bool = false
    var delegate: HomeCVManagerDelegate?
    
    init(_ viewModel: HomeVM) {
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(completion: @escaping () -> ()) {
        viewModel.fetchHomePage { completion() }
    }
}

// MARK: UICollectionViewDataSource and UICollectionViewDelegate
extension HomeCVManager: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.getDrugsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.pushToDrugDetail(viewModel.getDrug(indexPath.row))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableHeader(HomeCVHeader.self, indexPath)
        header.setupHeaderView(viewModel.banners, viewModel.instructions, viewModel.isHaveHits())
        header.delegate = self
        return header
    }
    
    func collectionView(collectionView: UICollectionView,
                        sizeForSectionHeaderViewForSection section: Int) -> CGSize {
        viewModel.sizeForSectionHeaderViewForSection()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.isPaginationNeeded(indexPath) {
            let cell = collectionView.dequeueReusableCell(IndicatorCell.self, indexPath)
            cell.setup()
            viewModel.paginateDrugs { self.delegate?.paginateDrugs() }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(DrugGridCVCell.self, indexPath)
            cell.setupCell(.init(viewModel.getDrug(indexPath.row)))
            cell.delegate = self
            return cell
        }
    }
    
    // MARK: Calculate cell heights with PinterestLayout
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return collectionView.heightForDrugCVCellAtIndexPath(indexPath,
                                                             viewModel.drugResult, collectionView)
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return .zero
    }
}

extension HomeCVManager: DrugGridCVCellDelegate {
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

extension HomeCVManager: HomeCVHeaderDelgate {
    
    func openBannerByLink(_ link: String) {
        delegate?.openBannerByLink(link)
    }
    
    func pushToMapPage() {
        delegate?.pushToMapPage()
    }
    
    func pushToDeliveryPage(_ programPolicy: PrivacyPolicy?) {
        delegate?.pushToDeliveryPage(programPolicy)
    }
    
    func pushToInstructionPage(_ programPolicy: PrivacyPolicy?) {
        delegate?.pushToInstructionPage(programPolicy)
    }
}
