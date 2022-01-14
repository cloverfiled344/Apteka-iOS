//
//  DistrictsTVC.swift
//  Infoapteka
//
//

import UIKit

// MARK: Appearance
extension SearchCitiesTVC {
    struct Appearance {
        let tableViewBackgroundColor: UIColor = Asset.mainWhite.color
        let tableViewSeparatorStyle: UITableViewCell.SeparatorStyle = .singleLine
    }
}

class SearchCitiesTVC: BaseTVC {

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
        checkTitleView([.searchTF], self)
    }
    
    private func setupTV() {
        tableViewManager.delegate = self
        tableView.delegate = tableViewManager
        tableView.dataSource = tableViewManager

        tableView.backgroundColor = appearance.tableViewBackgroundColor
        tableView.separatorStyle = appearance.tableViewSeparatorStyle
        tableView.registerdequeueReusableHeaderFooter(CitiesTVHeader.self)
        tableView.registerdequeueReusableCell(CityCell.self)

        tableView.tableHeaderView = .init(frame: .zero)
        tableView.tableFooterView = .init(frame: .zero)
    }
}

extension SearchCitiesTVC: InfoaptekaNavBarSearchViewDelegate {
    func searchTextFieldValueChanged(_ text: String) {
        viewModel.filterCities(text, reloadData)
    }
}

extension SearchCitiesTVC: CitiesTVManagerDelegate {
    func citySelected(_ city: City?) {
        guard let city = city else { return }
        selectedCity?(city)
    }
}
