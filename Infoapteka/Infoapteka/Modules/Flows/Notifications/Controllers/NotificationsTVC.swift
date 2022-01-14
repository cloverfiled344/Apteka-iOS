//
//  NotificationsTVC.swift
//  Infoapteka
//
//

import UIKit

extension NotificationsTVC {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color

        let title    : String = L10n.notifications
        let titleFont: UIFont = FontFamily.Inter.semiBold.font(size: 18.0)
        let titleColor   : UIColor = Asset.mainBlack.color

        let tableViewContentInset: UIEdgeInsets = .init(top: 12, left: 0, bottom: 0, right: 0)
    }
}

class NotificationsTVC: BaseTVC {

    // MARK: -- UI Properties
    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        return view
    }()

    private var appearance = Appearance()
    private var viewModel: NotificationsVM
    private var tableViewManager: NotificationsTVManager

    init(_ viewModel: NotificationsVM) {
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
        setupView()
        setupTV()
        fetchData()
    }

    private func setupView() {
        view.backgroundColor = appearance.backgroundColor
        setNavBarBackColor(title: "",
                           statusBarBackColor: .white,
                           navBarBackColor: .white,
                           navBarTintColor: .white,
                           prefersLargeTitles: false)
        setTabBarBackColor(tabBarBackColor: .white,
                           tabBarTintColor: .white)
        updateTitleLbl()
    }

    fileprivate func updateTitleLbl() {
        let attributedText = NSMutableAttributedString(string: appearance.title,
                                                       attributes: [.font: appearance.titleFont,
                                                                    .foregroundColor: appearance.titleColor])
        titleLbl.attributedText = attributedText
        navigationItem.titleView = titleLbl
    }

    fileprivate func setupTV() {
        tableView.delegate   = tableViewManager
        tableView.dataSource = tableViewManager
        tableView.separatorStyle = .none
        tableView.backgroundColor = appearance.backgroundColor
        tableView.contentInset = appearance.tableViewContentInset

        tableView.registerdequeueReusableCell(NotificationTVCell.self)

        setupPullRefreshControl(#selector(self.refreshData))
    }

    private func fetchData() {
        tableViewManager.setup { [weak self] in
            guard let self = self else { return }
            self.reloadData()
            self.viewModel.isLoading = false
        }
    }

    @objc private func refreshData() {
        tableViewManager.setup { [weak self] in
            guard let self = self else { return }
            self.reloadData()
            self.viewModel.isLoading = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarBackColor(statusBarBackColor: .white,
                           navBarBackColor: .white,
                           navBarTintColor: .white,
                           prefersLargeTitles: false)
    }
}

extension NotificationsTVC: NotificationsTVManagerDelegate {
    func paginateDrugs() {
        self.reloadData()
        self.viewModel.isLoading = false
    }
}
