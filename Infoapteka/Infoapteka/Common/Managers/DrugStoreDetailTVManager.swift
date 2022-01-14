//
//  DrugStoreDetailTVManager.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK: Delegate
protocol DrugStoreDetailTVManagerDelegate {
    func makeCall(_ phone: String?)
}

class DrugStoreDetailTVManager: NSObject {
    
    // MARK: Properties
    public var delegate: DrugStoreDetailTVManagerDelegate?
    private var viewModel: DrugStoreDetailVM
    
    // MARK: Initialize
    init(_ viewModel: DrugStoreDetailVM) {
        self.viewModel = viewModel
    }
    
    func setup(_ id: Int?, _ completion: @escaping() -> Void) {
        viewModel.getDrugStoreById(id) {
            completion()
        }
    }
}

// MARK: UITableViewDataSource
extension DrugStoreDetailTVManager: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.drugStorePhonesCount
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooter(DrugStoreDetailTVHeader.self)
        header.setupHeader(viewModel.drugStoreDetail)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(DrugStorePhoneTVCell.self, indexPath: indexPath)
        cell.setupCell(viewModel.getDrugStorePhone(by: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooter(DrugStoreTVFooter.self)
        footer.setupFooter(viewModel.drugStoreDetail)
        return footer
    }
}

// MARK: UITableViewDelegate
extension DrugStoreDetailTVManager: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.pulsate(sender: tableView.cellForRow(at: indexPath) ?? .init())
        delegate?.makeCall(viewModel.getDrugStorePhone(by: indexPath.row))
    }
}
