//
//  SearchHintTVCManager.swift
//  Infoapteka
//
//

import UIKit

protocol SearchHintTVCManagerDelegate {
    func hintSelected(_ hint: String?)
    func footerSelected()
}

class SearchHintTVManager: NSObject {

    // MARK: UI Components
    private lazy var backView : InfoAptekaBackgroundView = {
        let view = InfoAptekaBackgroundView()
        view.setupView(Asset.icSearchResult.image, "Результатов не найдено")
        return view
    }()
    
    private var viewModel: SearchHintVM
    var delegate: SearchHintTVCManagerDelegate?

    init(_ viewModel: SearchHintVM) {
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(_ search: String?, completion: @escaping () -> ()) {
        viewModel.fetchHints(search) {
            completion()
        }
    }
}

extension SearchHintTVManager: UITableViewDelegate {

    //MARK: - Tableview Delegate
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.hintSelected(viewModel.getHint(indexPath.row))
    }
}

extension SearchHintTVManager: UITableViewDataSource {

    //MARK: - Tableview Data source
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        switch viewModel.numberOfRowsInSection() {
        case .zero:
            backView.frame = tableView.bounds
            tableView.backgroundView = backView
            return .zero
        default:
            tableView.removeNoDataPlaceholder()
            return viewModel.numberOfRowsInSection()
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        makeHintCell(tableView, cellForRowAt: indexPath)
    }

    private func makeHintCell(_ tableView: UITableView,
                              cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(SearchHintTVCell.self,
                                                 indexPath: indexPath)
        cell.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0.02 * Double(indexPath.row), animations: {
            cell.alpha = 1
        })
        cell.setHint(viewModel.getHint(indexPath.row))
        return cell
    }

    // MARK: Footer View
    func makeFooterView(_ tableView: UITableView) -> UITableViewHeaderFooterView? {
//        let footer = tableView.dequeueReusableHeaderFooter(SearchHintFooter.self)
//        footer.setTitle("Не нашли то, что искали?")
//        footer.delegate = self
//        footer.frame = .init(x: 0, y: 0, width: tableView.bounds.width, height: 44.0)
//        footer.alpha = 0
//        UIView.animate(withDuration: 0.2, delay: 0.2, animations: {
//            footer.alpha = 1
//        })
        return .init(frame: .zero)
    }
}

extension SearchHintTVManager: SearchHintFooterDelegate {
    func selectedOnTitle() {
        delegate?.footerSelected()
    }
}
