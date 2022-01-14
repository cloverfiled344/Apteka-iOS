//
//  CabinetTVC.swift
//  Infoapteka
//
//

import UIKit

extension CabinetTVC {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color

        let title: String = L10n.menuTitle
    }
}

class CabinetTVC: BaseTVC {

    private var viewModel           : CabinetVM
    private var tableViewManager    : CabinetTVManager
    private var appearance          = Appearance()

    init(_ viewModel: CabinetVM) {
        self.viewModel = viewModel
        self.tableViewManager = .init(viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupTVManager() {
        tableViewManager.delegate = self
        fetchData()
    }

    @objc private func fetchData() {
        tableViewManager.fetchData {
            self.refreshControl?.endRefreshing()
            self.reloadData()
        }
        stopIndicatorAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CabinetTVC {
    func setupUI() {
        self.setupView()
        self.setupTV()
        self.setupTVManager()
    }

    func setupView() {
        self.setNavBarBackColor(title: appearance.title,
                                statusBarBackColor: .white,
                                navBarBackColor: .white,
                                navBarTintColor: .white,
                                prefersLargeTitles: false)

        self.view.backgroundColor = appearance.backgroundColor
    }

    func setupTV() {
        tableView.separatorStyle  = .none
        tableView.delegate        = tableViewManager
        tableView.dataSource      = tableViewManager
        tableView.tableFooterView = .init()
        tableView.registerdequeueReusableCell(CabinetTVCell.self)
        setupPullRefreshControl(#selector(fetchData))
    }
}

extension CabinetTVC: CabinetTVManagerDelegate {
    func selectedItem(_ item: MenuItem) {
        switch item.type {
        case .profile         : checkProfile()
        case .myGoods         : pushMyProducts()
        case .historyOfOrders : pushOrderHistory()
        case .aboutCompany    : pushAboutCompany()
        case .help            : pushHelp()
        case .programRules    : pushProgram()
        case .signIn          : pushAuthSignIn()
        case .signOut         :
            let sheet = SignOutBottomSheet.instance
            sheet.signOut = { [weak self] in
                guard let self = self else { return }
                self.changeBasketBadgeValue(false, AppSession.basketCount ?? 0 + 1)
                self.changeFavouritesbadgeValue(false, AppSession.favouritesCount ?? 0 + 1)
            }
            sheet.show()
        }
    }
}

private extension CabinetTVC {
    private func checkProfile() {
        guard let profile = viewModel.getProfile() else {
            BannerTop.showToast(message: "Пользователь не найден! Попробуйте перезайти или обновить страницу", and: .systemRed)
            return
        }
        pushRegister(profile)
    }

    private func pushRegister(_ profile: Profile) {
        let vc = RegisterVC(.init(profile))
        vc.hidesBottomBarWhenPushed = true
        vc.isSuccess = { [ weak self] in
            guard let self = self else { return }
            self.viewModel.fetchProfile {
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
            self.navigationController?.popViewController(animated: true)
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    private func pushMyProducts() {
        let vc = MyDrugsCVC(.init())
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    private func pushOrderHistory() {
        let vc = OrderHistoryTVC(.init())
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    private func pushAboutCompany() {
        let vc = AboutTVC(.init())
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    private func pushHelp() {
        let vc = HelpTVC(.init())
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    private func pushProgram() {
        viewModel.getProgramRules { [weak self] result in
            guard let self = self else { return }
            let vc = PrivacyPolicyVC()
            vc.setupPDF(result)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }


    private func pushAuthSignIn() {
        let vc = AuthSignInVC(.init())
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
