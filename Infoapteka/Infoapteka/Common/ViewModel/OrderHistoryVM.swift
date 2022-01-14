//
//  OrderHistoryVM.swift
//  Infoapteka
//
//

import UIKit

final class OrderHistoryVM {

    private var orderHistory: [OrderHistory] = []

    func fetchOrderHistory(_ completion: @escaping(() -> Void)) {
        API.orderHistoryAPI.fetchOrderHistory { orderHistory in
            self.orderHistory = orderHistory ?? []
            completion()
        }
    }

    func fetchOrderHistory(_ id: Int, _ completion: @escaping((OrderHistory?) -> Void)) {
        API.orderHistoryAPI.fetchOrderHistory(id) { orderHistory in
            completion(orderHistory)
        }
    }

    var numberOfSections: Int {
        get { return orderHistory.count }
    }

    func getNumberOfRowsInSection(_ section: Int) -> Int {
        if numberOfSections > section {
            return orderHistory[section].isExpanded ? orderHistory[section].orders.count : (orderHistory[section].orders.count > 0 ? 1 : 0)
        } else { return 0 }
    }

    func getOrderHistory(_ section: Int) -> OrderHistory? {
        return numberOfSections > section ? orderHistory[section] : nil
    }

    func getOrder(_ indexPath: IndexPath) -> Order? {
        return numberOfSections > indexPath.section ? getNumberOfRowsInSection(indexPath.section) > indexPath.row ? orderHistory[indexPath.section].orders[indexPath.row] : nil : nil
    }

    func changeHistoryExpand(_ orderHistoryID: Int, _ complation: @escaping((Int) -> ())) {
        let orderIndex = orderHistory.firstIndex { $0.id == orderHistoryID }
        guard let index = orderIndex else { return }
        orderHistory[index].isExpanded = !orderHistory[index].isExpanded
        complation(index)
    }

    func makeHaederView(_ tableView: UITableView,
                        _ section: Int,
                        _ delegate: OrderHistoryHeaderDelegate) -> UITableViewHeaderFooterView {
        let header = tableView.dequeueReusableHeaderFooter(OrderHistoryHeader.self)
        header.delegate = delegate
        header.setup(getOrderHistory(section))
        return numberOfSections > 0 ? header : .init()
    }

    func makeFooterView(_ delegate: OrderHistoryFooterDelegate,
                        _ tableView: UITableView,
                        _ section: Int) -> UITableViewHeaderFooterView {
        let footer = tableView.dequeueReusableHeaderFooter(OrderHistoryFooter.self)
        footer.delegate = delegate
        footer.setup(getOrderHistory(section))
        return numberOfSections > 0 ? footer : .init()
    }
}
