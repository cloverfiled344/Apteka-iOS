//
//  FilterTVC.swift
//  Infoapteka
//
//

import UIKit

protocol FilterTVCDelegate {
    func selected(_ searchFilter: SearchFilter?)
}

// MARK: Appearance
extension FilterTVC {
    struct Appearance {
        let tableViewBackgroundColor: UIColor = Asset.mainWhite.color
        let tableViewSeparatorStyle: UITableViewCell.SeparatorStyle = .singleLine
        let title: String = L10n.selectCity
    }
}

class FilterTVC: BaseTVC {

    private let appearance       = Appearance()
    private var viewModel        : FilterVM
    private var tableViewManager : FilterTVManager
    var _delegate                 : FilterTVCDelegate?

    init(_ viewModel: FilterVM) {
        self.viewModel = viewModel
        self.tableViewManager = .init(viewModel)
        super.init(nibName: nil, bundle: nil)
        self.tableViewManager.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTV()
        tableViewManager.setup { [weak self] in
            self?.reloadData()
        }
    }

    //MARK: -- public methods
    func setFilter(_ searchFilter: SearchFilter) {
        viewModel.selectFilter(searchFilter)
        self.reloadData()
    }

    private func setupTV() {

        tableView.delegate   = self.tableViewManager
        tableView.dataSource = self.tableViewManager

        tableView.backgroundColor = appearance.tableViewBackgroundColor
        tableView.separatorStyle  = appearance.tableViewSeparatorStyle
        tableView.registerdequeueReusableHeaderFooter(CitiesTVHeader.self)
        tableView.registerdequeueReusableCell(FilterCell.self)

        tableView.tableHeaderView = self.tableViewManager.makeHeaderView(self.tableView,
                                                                              appearance.title)
        tableView.tableFooterView = self.tableViewManager.makeFooterView(self.tableView)
    }
}

extension FilterTVC: FilterTVManagerDelegate {
    func selected(_ searchFilter: SearchFilter?) {
        _delegate?.selected(searchFilter)
    }
}
