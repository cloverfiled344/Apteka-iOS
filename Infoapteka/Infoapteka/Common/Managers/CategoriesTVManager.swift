//
//  CategoriesTVManager.swift
//  Infoapteka
//
//

import UIKit

protocol CategoriesTVManagerDelegate {
    func categoryCellSelected(_ category: Category)
    func seeAllCellSelected(_ category: Category)
    func superParentCellSelected()
}

class CategoriesTVManager: NSObject {

    private var viewModel: CategoriesVM
    var delegate: CategoriesTVManagerDelegate?

    init(_ viewModel: CategoriesVM) {
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(completion: @escaping () -> ()) {
        self.viewModel.fetchCategories {
            completion()
        }
    }
}

extension CategoriesTVManager: UITableViewDelegate {

    //MARK: - Tableview Delegate
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let category = viewModel.getCategory(indexPath.row) else { return }
        switch category.type {
        case .parent: break
        case .seeAll:
            tableView.cellForRow(at: indexPath)?.pulsate()
            delegate?.seeAllCellSelected(category)
        case .category:
            tableView.cellForRow(at: indexPath)?.pulsate()
            delegate?.categoryCellSelected(category)
        case .superParent:
            delegate?.superParentCellSelected()
        }
    }
}

extension CategoriesTVManager: UITableViewDataSource {

    //MARK: - Tableview Data source
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        makeCell(tableView, cellForRowAt: indexPath)
    }

    private func makeCell(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let category = viewModel.getCategory(indexPath.row) else { return .init() }
        var cell: UITableViewCell = UITableViewCell()
        switch category.type {
        case .parent:
            let parentCategoryTVCell = tableView.dequeueReusableCell(ParentCategoryTVCell.self,
                                                     indexPath: indexPath)
            parentCategoryTVCell.setTitle(category.title)
            cell = parentCategoryTVCell
            cell.alpha = 0
        case .seeAll:
            let seeAllTVCell = tableView.dequeueReusableCell(SeeAllTVCell.self,
                                                     indexPath: indexPath)
            cell = seeAllTVCell
            cell.alpha = 0
        case .category:
            let categoryTVCell = tableView.dequeueReusableCell(CategoryTVCell.self,
                                                     indexPath: indexPath)
            categoryTVCell.setCategory(category)
            cell = categoryTVCell
            cell.alpha = 0
        case .superParent:
            let superParentCategoryTVCell = tableView.dequeueReusableCell(SuperParentCategoryTVCell.self,
                                                     indexPath: indexPath)
            superParentCategoryTVCell.setTitle(category.title)
            cell = superParentCategoryTVCell
            cell.alpha = 0
        }
        UIView.animate(withDuration: 0.2, delay: 0.02 * Double(indexPath.row), animations: {
            cell.alpha = 1
        })
        return cell
    }

    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        .init()
    }
}

