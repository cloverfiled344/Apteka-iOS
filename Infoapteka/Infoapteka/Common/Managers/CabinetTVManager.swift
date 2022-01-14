//
//  CabinetTVManager.swift
//  Infoapteka
//
//

import UIKit

protocol CabinetTVManagerDelegate {
    func selectedItem(_ item: MenuItem)
}

class CabinetTVManager: NSObject {

    private var viewModel: CabinetVM
    var delegate: CabinetTVManagerDelegate?

    init(_ viewModel: CabinetVM) {
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fetchData(completion: @escaping () -> ()) {
        viewModel.getMenuItems { completion() }
    }
}

extension CabinetTVManager: UITableViewDelegate {

    //MARK: - Tableview Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = self.viewModel.getMenuItem(indexPath.item) else { return }
        delegate?.selectedItem(item)
    }
}

extension CabinetTVManager: UITableViewDataSource {

    //MARK: - Tableview Data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getMenuItemsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        makeCabinetCell(tableView, cellForRowAt: indexPath)
    }

    private func makeCabinetCell(_ tableView: UITableView,
                                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CabinetTVCell.self, indexPath: indexPath)
        cell.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0.02 * Double(indexPath.row), animations: {
            cell.alpha = 1
        })
        cell.setMenuItem(viewModel.getMenuItem(indexPath.item))
        return cell
    }
}
