//
//  FilterTVManager.swift
//  Infoapteka
//
//

import UIKit

protocol FilterTVManagerDelegate {
    func selected(_ searchFilter: SearchFilter?)
}

class FilterTVManager: NSObject {

    private var viewModel : FilterVM
    var delegate          : FilterTVManagerDelegate?

    init(_ viewModel: FilterVM) {
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(completion: @escaping () -> ()) {
        self.viewModel.getFilters { completion() }
    }
}

extension FilterTVManager: UITableViewDelegate {

    //MARK: - Tableview Delegate
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectFilter(indexPath.row)
        delegate?.selected(viewModel.getSelectedFilter(indexPath.row))
    }
}

extension FilterTVManager: UITableViewDataSource {

    //MARK: - Tableview Data source
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.getFiltersCount()
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        makeCityCell(tableView, cellForRowAt: indexPath)
    }

    private func makeCityCell(_ tableView: UITableView,
                               cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(FilterCell.self,
                                                                  indexPath: indexPath)
        cell.setFilter(viewModel.getFilter(indexPath.row))
        return cell
    }

    // MARK: Header View
    func makeHeaderView(_ tableView: UITableView,
                        _ title: String) -> UITableViewHeaderFooterView? {
        let header = tableView.dequeueReusableHeaderFooter(CitiesTVHeader.self)
        header.setTitle(title)
        header.frame = .init(x: 0,
                             y: 0,
                             width: tableView.bounds.size.width,
                             height: 60.0)
        return header
    }

    // MARK: Footer View
    func makeFooterView(_ tableView: UITableView) -> UITableViewHeaderFooterView? {
        .init(frame: .zero)
    }
}
