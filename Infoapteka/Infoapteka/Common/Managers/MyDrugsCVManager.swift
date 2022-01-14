//
//  MyDrugsCVManager.swift
//  Infoapteka
//
//  
//

import UIKit
import PinterestLayout

protocol MyDrugsCVManagerDelegate {
    func paginateDrugs()
    func didTappedOnEdit(_ drug: Drug?)
    func didSelectItemAt(_ drug: Drug?)
}

class MyDrugsCVManager: NSObject {
    
    // MARK: UI Components
    private lazy var backView : InfoAptekaBackgroundView = {
        let view = InfoAptekaBackgroundView()
        view.setupView(Asset.icMyProductBasket.image, L10n.emptyProduct)
        return view
    }()
    
    // MARK: Properties
    public var delegate: MyDrugsCVManagerDelegate?
    private var viewModel: MyDrugsVM
    
    // MARK: Initialize
    init(_ viewModel: MyDrugsVM) {
        self.viewModel = viewModel
    }
    
    // MARK: Methods
    func setup(_ completion: @escaping() -> Void) {
        viewModel.fetchData(completion)
    }
}

// MARK: UICollectionViewDataSource and UICollectionViewDelegate
extension MyDrugsCVManager: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItemAt(viewModel.getDrug(by: indexPath.row))
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch viewModel.myDrugsCount {
        case .zero:
            backView.frame = collectionView.bounds
            collectionView.backgroundView = backView
            return .zero
        default:
            collectionView.removeNoDataPlaceholder()
            return viewModel.myDrugsCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.isPaginationNeeded(indexPath) {
            let cell = collectionView.dequeueReusableCell(IndicatorCell.self, indexPath)
            cell.setup()
            delegate?.paginateDrugs()
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(MyDrugCVCell.self, indexPath)
            cell.setupCell(viewModel.getDrug(by: indexPath.row))
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

// MARK: PinterestLayoutDelegate
extension MyDrugsCVManager: PinterestLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        collectionView.heightForDrugCVCellAtIndexPath(indexPath, viewModel.myDrugsResult,
                                                      collectionView)
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return .zero
    }
}

extension MyDrugsCVManager: MyDrugCVCellDelegate {
    func didTappedOnEditBtn(_ drug: Drug?) {
        delegate?.didTappedOnEdit(drug)
    }
}
