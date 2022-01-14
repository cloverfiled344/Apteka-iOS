//
//  DrugStoreCVManager.swift
//  Infoapteka
//
//  
//

import UIKit
import MapKit

// MARK: Delegates
protocol DrugStoreCVManagerDelegate {
    func updateView()
    func pushToStoreDetail(_ id: Int?)
    func tappedDrugAnnotation(_ drugStore: DrugStore)
}

class DrugStoreCVManager: NSObject {
    
    // MARK: Properties
    public var delegate: DrugStoreCVManagerDelegate?
    private var viewModel: DrugStoreVM
   
    init(_ viewModel: DrugStoreVM) {
        self.viewModel = viewModel
    }
    
    func setup(_ completion: @escaping() -> Void) {
        viewModel.fetchData(completion)
    }
}

extension DrugStoreCVManager: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.drugStoreShowStates.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.drugStoreShowStates[indexPath.row] {
        case .list:
            let cell = collectionView.dequeueReusableCell(DrugStoreMapListCVCell.self, indexPath)
            cell.setData(viewModel)
            cell.delegate = self
            return cell
        case .map:
            let cell = collectionView.dequeueReusableCell(DrugStoreMapCVCell.self, indexPath)
            cell.setAnotations(viewModel.drugStoreResult)
            cell.delegate = self
            return cell
        }
    }
}

extension DrugStoreCVManager: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: Constants.screenWidth, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

// MARK: Map List Cell Delegate
extension DrugStoreCVManager: DrugStoreMapListCVCellDelegate {
    func updateView() {
        delegate?.updateView()
    }

    func pushToStoreDetail(_ id: Int?) {
        delegate?.pushToStoreDetail(id)
    }
}

// MARK: Map Cell Delegate
extension DrugStoreCVManager: DrugStoreMapCVCellDelgate {
    func tappedDrugAnnotation(_ drugStore: DrugStore) {
        delegate?.tappedDrugAnnotation(drugStore)
    }
}
