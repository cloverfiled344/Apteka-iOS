//
//  CategoriesTVC.swift
//  Infoapteka
//
//

import UIKit

extension CategoriesTVC {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color

        let tableViewContentInset: UIEdgeInsets = .init(top: 12, left: 0, bottom: 0, right: 0)
    }
}

class CategoriesTVC: BaseTVC {

    private var appearance = Appearance()
    private var viewModel: CategoriesVM
    private var tableViewManager: CategoriesTVManager
    var categorySelected: ((Category) -> ())?

    init(_ viewModel: CategoriesVM) {
        self.viewModel        = viewModel
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
        fetchData()
    }

    fileprivate func setupTV() {
        tableView.delegate   = tableViewManager
        tableView.dataSource = tableViewManager
        tableView.separatorStyle = .none
        tableView.backgroundColor = appearance.backgroundColor
        tableView.contentInset = appearance.tableViewContentInset

        tableView.registerdequeueReusableCell(SuperParentCategoryTVCell.self)
        tableView.registerdequeueReusableCell(ParentCategoryTVCell.self)
        tableView.registerdequeueReusableCell(SeeAllTVCell.self)
        tableView.registerdequeueReusableCell(CategoryTVCell.self)
        tableView.registerdequeueReusableCell(UITableViewCell.self)
    }

    private func fetchData() {
        tableViewManager.setup { [weak self] in
            guard let self = self else { return }
            self.reloadData()
            if self.viewModel.isNeedRefresh {
                self.setupPullRefreshControl(#selector(self.refreshData))
            }
        }
    }

    @objc private func refreshData() {
        guard viewModel.isNeedRefresh else { return }
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
        switch viewModel.selectType {
        case .search:
            navigationItem.hidesBackButton = true
            checkTitleView([.logoIV, .searchHintTF, .notificationBtn], self)
        case .simple:
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension CategoriesTVC: CategoriesTVManagerDelegate {
    func categoryCellSelected(_ category: Category) {
        if category.children.isEmpty {
            switch viewModel.selectType {
            case .search:
                let drugSearchCVC = DrugSearchVC(.init(category), "")
                drugSearchCVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(drugSearchCVC, animated: true)
            case .simple:
                self.categorySelected?(category)
            }
        } else {
            let categoriesTVC = CategoriesTVC(.init(category,
                                                    viewModel.getParentCategory(),
                                                    viewModel.selectType))
            categoriesTVC.categorySelected = categorySelected
            navigationController?.pushViewController(categoriesTVC, animated: true)
        }
    }

    func seeAllCellSelected(_ category: Category) {
        let drugSearchCVC = DrugSearchVC(.init(category), "")
        drugSearchCVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(drugSearchCVC, animated: true)
    }

    func superParentCellSelected() {
        navigationController?.popViewController(animated: true)
    }
}

extension CategoriesTVC: InfoaptekaNavBarSearchViewDelegate {
    func searchTextFieldEditingDidBegin() {
        let vc = SearchHintTVC(.init(viewModel.getParentCategory()))
        navigationController?.pushViewController(vc, animated: false)
    }
}


