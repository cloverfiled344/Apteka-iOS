//
//  rderHistoryTVManager.swift
//  Infoapteka
//
//

import UIKit

protocol OrderHistoryTVManagerDelegate {
    func reloadSection(_ section: Int)
    func didTappedPayBtn(_ orderHistory: OrderHistory)
}

class OrderHistoryTVManager: NSObject {
    
    // MARK: UI Components
    private lazy var backView : InfoAptekaBackgroundView = {
        let view = InfoAptekaBackgroundView()
        view.setupView(Asset.icEmptyNotifications.image, L10n.emptyNotifications)
        return view
    }()
    
    private var viewModel: OrderHistoryVM
    var delegate: OrderHistoryTVManagerDelegate?
    
    init(_ viewModel: OrderHistoryVM) {
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(completion: @escaping () -> ()) {
        viewModel.fetchOrderHistory(completion)
    }
}

//MARK: - Tableview Delegate
extension OrderHistoryTVManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        viewModel.makeHaederView(tableView, section, self)
    }

    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        viewModel.makeFooterView(self, tableView, section)
    }
}

//MARK: - Tableview Data source
extension OrderHistoryTVManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = viewModel.getNumberOfRowsInSection(section)
        switch numberOfRowsInSection {
        case .zero:
            backView.frame = tableView.bounds
            tableView.backgroundView = backView
            return .zero
        default:
            tableView.removeNoDataPlaceholder()
            return numberOfRowsInSection
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        makeCell(tableView, cellForRowAt: indexPath)
    }
    
    private func makeCell(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(OrderHistoryTVCell.self,
                                                 indexPath: indexPath)
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.02 * Double(indexPath.row), animations: {
            cell.alpha = 1
        })
        cell.setup(viewModel.getOrder(indexPath))
        return cell
    }
}

extension OrderHistoryTVManager: OrderHistoryFooterDelegate {
    func didTappedMoreDetailsBtn(_ orderHistoryID: Int) {
        viewModel.changeHistoryExpand(orderHistoryID) { [weak self] orderHistoryIndex in
            guard let self = self else { return }
            self.delegate?.reloadSection(orderHistoryIndex)
        }
    }
}

extension OrderHistoryTVManager: OrderHistoryHeaderDelegate {
    func didTappedPayBtn(_ orderHistory: OrderHistory) {
        delegate?.didTappedPayBtn(orderHistory)
    }
}
