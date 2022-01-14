//
//  CitiesTVC.swift
//  Infoapteka
//
//  
//

import UIKit

protocol CitiesTVCDelegate {
    func selected(_ city: City?)
}

// MARK: Appearance
extension CitiesTVC {
    struct Appearance {
        let tableViewBackgroundColor: UIColor = Asset.mainWhite.color
        let tableViewSeparatorStyle: UITableViewCell.SeparatorStyle = .singleLine
    }
}

class CitiesTVC: BaseTVC {

    private let appearance = Appearance()
    private var viewModel: CitiesVM
    private var tableViewManager: CitiesTVManager
    var selectedCity: ((City) -> ())?

    init(_ viewModel: CitiesVM) {
        self.viewModel = viewModel
        self.tableViewManager = .init(viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTV()
        tableViewManager.setup { [weak self] in
            guard let self = self else { return }
            self.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setNavBarBackColor(statusBarBackColor: .white,
                           navBarBackColor: .white,
                           navBarTintColor: .white,
                           prefersLargeTitles: false)
        checkTitleView([.searchHintTF], self)
    }

    private func setupTV() {
        tableViewManager.delegate = self
        tableView.delegate = tableViewManager
        tableView.dataSource = tableViewManager

        tableView.backgroundColor = appearance.tableViewBackgroundColor
        tableView.separatorStyle = appearance.tableViewSeparatorStyle
        tableView.registerdequeueReusableHeaderFooter(CitiesTVHeader.self)
        tableView.registerdequeueReusableCell(CityCell.self)

        tableView.tableHeaderView = tableViewManager.makeHeaderView(tableView, viewModel.getTitle())
        tableView.tableFooterView = tableViewManager.makeFooterView(tableView)
    }
}

extension CitiesTVC: InfoaptekaNavBarSearchViewDelegate {
    func searchTextFieldEditingDidBegin() {
        let searchCitiesTVC = SearchCitiesTVC(.init(.search))
        searchCitiesTVC.selectedCity = { [weak self] city in
            guard let self = self else { return }
            self.selectedCity?(city)
        }
        navigationController?.pushViewController(searchCitiesTVC, animated: true)
    }
}

extension CitiesTVC: CitiesTVManagerDelegate {
    func citySelected(_ city: City?) {
        guard let city = city else { return }
        if city.districts.isEmpty {
           selectedCity?(city)
        } else {
            let categoriesTVC = CitiesTVC(.init(.cities, city))
            categoriesTVC.selectedCity = selectedCity
            navigationController?.pushViewController(categoriesTVC, animated: true)
        }
    }
}
