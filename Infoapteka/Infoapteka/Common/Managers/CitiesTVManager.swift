//
//  CitiesTVManager.swift
//  Infoapteka
//
//

import UIKit

protocol CitiesTVManagerDelegate {
    func citySelected(_ city: City?)
}

class CitiesTVManager: NSObject {

    private var viewModel: CitiesVM
    var delegate: CitiesTVManagerDelegate?

    init(_ viewModel: CitiesVM) {
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(completion: @escaping () -> ()) {
        viewModel.getCities {
            completion()
        }
    }
}

//MARK: - Tableview Delegate
extension CitiesTVManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let city = viewModel.getCity(indexPath.row) else { return }
        delegate?.citySelected(city)
    }
}

//MARK: - Tableview Data source
extension CitiesTVManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCitiesCount()
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        makeCityCell(tableView, cellForRowAt: indexPath)
    }

    private func makeCityCell(_ tableView: UITableView,
                              cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(CityCell.self,
                                                                  indexPath: indexPath)
        (cell as? CityCell)?.setCity(viewModel.getCity(indexPath.row))
        return cell
    }

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

    func makeFooterView(_ tableView: UITableView) -> UITableViewHeaderFooterView? {
        .init(frame: .zero)
    }
}
