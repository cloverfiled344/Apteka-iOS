//
//  NotificationsTVManager.swift
//  Infoapteka
//
//

import UIKit

protocol NotificationsTVManagerDelegate {
    func paginateDrugs()
}

class NotificationsTVManager: NSObject {

    // MARK: UI Components
    private lazy var backView : InfoAptekaBackgroundView = {
        let view = InfoAptekaBackgroundView()
        view.setupView(Asset.icEmptyNotifications.image, L10n.emptyNotifications)
        return view
    }()

    private var viewModel: NotificationsVM
    var delegate: NotificationsTVManagerDelegate?

    init(_ viewModel: NotificationsVM) {
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(completion: @escaping () -> ()) {
        viewModel.fetchNotifications(completion)
    }
}

extension NotificationsTVManager: UITableViewDelegate {

    //MARK: - Tableview Delegate
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NotificationsTVManager: UITableViewDataSource {

    //MARK: - Tableview Data source
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = viewModel.numberOfRowsInSection
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
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if viewModel.isPaginationNeeded(indexPath) {
            viewModel.isLoading = true
            viewModel.fetchNotifications { self.delegate?.paginateDrugs() }
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        makeCell(tableView, cellForRowAt: indexPath)
    }

    private func makeCell(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(NotificationTVCell.self,
                                                 indexPath: indexPath)
        cell.setNotif(viewModel.getNotif(indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        .init()
    }
}
