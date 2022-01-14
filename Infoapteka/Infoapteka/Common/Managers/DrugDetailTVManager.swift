//
//  DrugDetailTVManager.swift
//  Infoapteka
//
//  
//

import UIKit

protocol DrugDetailTVDelegate {
    func getVCForImageSlideShow() -> UIViewController?
    func addedToBasket(_ sender: UIButton, _ animateViewTo: AnimateViewTo, _ collectionView: UICollectionView ,_ isAdded: Bool)
    func addedToFavourite(_ sender: UIButton, _ animateViewTo: AnimateViewTo, _ collectionView: UICollectionView ,_ isAdded: Bool)
    func pushToDetailFromSimilar(_ drug: Drug)
    func pushToCompanyPage(_ ownerID: Int)
}

// MARK: Manager
class DrugDetailTVManager: NSObject {
    
    public var delegate: DrugDetailTVDelegate?
    private var viewModel: DrugDetailVM
    
    init(_ viewModel: DrugDetailVM) {
        self.viewModel = viewModel
    }
    
    func setup(_ id: Int?, _ completion: @escaping(Int) -> Void) {
        viewModel.fetchData(id) { failedCount in
            completion(failedCount)
        }
    }
}

// MARK: UICollectionViewDataSource and UICollectionViewDelegate
extension DrugDetailTVManager: UITableViewDataSource,
                               UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.getDrugDetailCellType(by: section) {
        case .slideShow:
            return drugDetailSlideTVHeader(tableView, section, delegate?.getVCForImageSlideShow())
        case .desc:
            return drugDetailDescTVHeader(tableView, section)
        case .instruction:
            return drugDetailInstructTVHeader(tableView, section)
        case .drugs:
            return drugDetailFreqDrugsTVHeader(tableView, section)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.getDrugDetailCellType(by: indexPath.section) {
        case .slideShow, .desc:
            return .init()
        case .instruction:
            return drugDetailExpandTVCell(tableView, indexPath)
        case .drugs:
            return drugDetailDrugsTVCell(tableView, indexPath)
        }
    }

    // MARK: - Setup Header
    private func drugDetailSlideTVHeader(_ tableView: UITableView,
                                         _ section: Int,
                                         _ root: UIViewController?) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooter(DrugDetailSlideTVHeader.self)
        header.setImages(viewModel.getDrugDetailImages())
        header.root = root
        return header
    }
    
    private func drugDetailDescTVHeader(_ tableView: UITableView,
                                        _ section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooter(DrugDetailDescTVHeader.self)
        header.setupCell(viewModel.getDrugDetail())
        header.delegate = self
        return header
    }
    
    private func drugDetailInstructTVHeader(_ tableView: UITableView,
                                            _ section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooter(DrugDetailInstructTVHeader.self)
        header.setupCell(viewModel.getDrugDetailInstructTitle(), viewModel.getDrugDetailInstructionTxt())
        return header
    }
    
    private func drugDetailFreqDrugsTVHeader(_ tableView: UITableView,
                                             _ section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooter(DrugDetailFreqDrugTVHeader.self)
        header.setupHeader(L10n.frequentlyProducts, (viewModel.getDrugDetail()?.similar.isEmpty ?? true))
        return header
    }
    
    // MARK: - Setup Cell
    private func drugDetailExpandTVCell(_ tableView: UITableView,
                                        _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(DrugDetailExpandableTVCell.self, indexPath: indexPath)
        cell.setupCell(viewModel.getMoreInstructions(by: indexPath.row), indexPath.row) { (callback) in
            tableView.performBatchUpdates { callback() }
        }
        return cell
    }
    
    private func drugDetailDrugsTVCell(_ tableView: UITableView,
                                       _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(DrugDetailFreqProdTVCell.self, indexPath: indexPath)
        cell.setupCell(viewModel.getFreqDrugs())
        cell.delegate = self
        return cell
    }
}

extension DrugDetailTVManager: DrugDetailFreqProdTVCellDelegate {
    func changeInBasket(_ drug: Drug, _ sender: UIButton,
                        _ collectionView: UICollectionView, _ animateViewTo: AnimateViewTo) {
        viewModel.replaceDrugById(drug)
        delegate?.addedToBasket(sender, animateViewTo, collectionView, drug.isCart)
    }
    
    func changeIsFavorite(_ drug: Drug, _ sender: UIButton,
                          _ collectionView: UICollectionView,
                          _ animateViewTo: AnimateViewTo) {
        viewModel.replaceDrugById(drug)
        delegate?.addedToFavourite(sender, animateViewTo, collectionView, drug.isFavorites)
    }
    
    func pushToDrugDetail(_ drug: Drug) {
        delegate?.pushToDetailFromSimilar(drug)
    }
}

extension DrugDetailTVManager: DrugDetailDescTVHeaderDelegate {
    func didTappedOnCompanyNameBtn(_ ownerID: Int) {
        delegate?.pushToCompanyPage(ownerID)
    }
}
