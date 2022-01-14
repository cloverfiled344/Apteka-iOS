//
//  OrderHistoryTVC.swift
//  Infoapteka
//
//

import UIKit

extension OrderHistoryTVC {
    struct Appearance {
        let backgroundColor = Asset.secondaryWhite.color

        let title    : String = "История заказов"
        let titleFont: UIFont = FontFamily.Inter.semiBold.font(size: 18.0)
        let titleColor   : UIColor = Asset.mainBlack.color

        let tableViewContentInset: UIEdgeInsets = .init(top: -21, left: 0, bottom: 0, right: 0)
    }
}

class OrderHistoryTVC: BaseTVC {

    // MARK: -- UI Properties
    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        return view
    }()

    private var appearance = Appearance()
    private var viewModel: OrderHistoryVM
    private var tableViewManager: OrderHistoryTVManager

    init(_ viewModel: OrderHistoryVM) {
        self.viewModel        = viewModel
        self.tableViewManager = .init(viewModel)
        super.init(style: .grouped)
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
        tableView.separatorColor = .white
        tableView.backgroundColor = appearance.backgroundColor
        tableView.contentInset = appearance.tableViewContentInset

        tableView.registerdequeueReusableCell(OrderHistoryTVCell.self)
        tableView.registerdequeueReusableHeaderFooter(OrderHistoryHeader.self)
        tableView.registerdequeueReusableHeaderFooter(OrderHistoryFooter.self)

        tableView.tableHeaderView = .init(frame: .zero)
        tableView.tableFooterView = .init(frame: .zero)
    }

    private func fetchData() {
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
    }
}

extension OrderHistoryTVC: OrderHistoryTVManagerDelegate {
    func didTappedPayBtn(_ orderHistory: OrderHistory) {
        guard let id = orderHistory.id else { return }
        viewModel.fetchOrderHistory(id) { [weak self] _orderHistory in
            guard let self = self, var newOrderHistory = _orderHistory else { return }
            newOrderHistory.ordersCount = orderHistory.ordersCount ?? 0
            newOrderHistory.ordersPrice = orderHistory.ordersPrice ?? 0
            let vc = CheckoutTVC(.init(newOrderHistory))
            vc.checkoutOrderCalback = { [weak self]  status, link in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
                self.changeBasketBadgeValue(false, (AppSession.basketCount ?? 0) + 1)
                guard let link = link else {
                    self.showStatusBottomSheet(status)
                    return
                }
                self.openLinkInApp(link) { [ weak self] in
                    guard let self = self else { return }
                    self.showStatusBottomSheet(status)
                }
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    fileprivate func showStatusBottomSheet(_ status: Bool) {
        CheckoutStatusBottomSheet.instance.show(status)
    }

    func reloadSection(_ section: Int) {
        DispatchQueue.main.async {
            UIView.setAnimationsEnabled(false)
            self.tableView.beginUpdates()
            self.tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .none)
            self.tableView.endUpdates()

            UIView.animate(withDuration: 0.3) {
                UIView.setAnimationsEnabled(true)
                self.tableView.scrollToRow(at: .init(row: 0,
                                                     section: section),
                                           at: .none, animated: false)
            }
        }
    }
}
