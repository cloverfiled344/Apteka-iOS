//
//  BasketTVC.swift
//  Infoapteka
//
//

import UIKit

// MARK: -- Appearance
extension BasketVC {
    struct Appearance {
        let backgroundColor          : UIColor = Asset.backgroundGray.color
        let tableViewBackgroundColor : UIColor = Asset.backgroundGray.color
        let tableViewSeparatorStyle  : UITableViewCell.SeparatorStyle = .none

        let title    : String = L10n.basket
        let titleFont: UIFont = FontFamily.Inter.bold.font(size: 18)
        let titleColor   : UIColor = Asset.mainBlack.color
        let subtitleColor: UIColor = Asset.secondaryGray3.color

        let placeAnOrderViewHeight: CGFloat = 83.0
    }
}

class BasketVC: BaseVC {

    // MARK: -- Properties
    private let appearance      = Appearance()
    private var viewModel       : BasketVM
    private var tableViewManager: BasketTVManager

    // MARK: -- UI Properties
    lazy private var tableView: UITableView = {
        let view = UITableView()
        return view
    }()

    lazy private var titleLbl: UILabel = {
        let view = UILabel(frame: .init(x: 0, y: 0, width: Constants.screenWidth, height: 44))
        view.textAlignment = .center
        return view
    }()

    lazy private var placeAnOrderView: PlaceAnOrderView = {
        let view = PlaceAnOrderView()
        view.delegate = self
        return view
    }()

    // MARK: -- init
    init(_ viewModel: BasketVM) {
        self.viewModel        = viewModel
        self.tableViewManager = .init(viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -- vc lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTV()

        tableViewManager.delegate = self
        fetchBasket()
    }

    @objc private func fetchBasket() {
        tableViewManager.setup { [weak self] in
            guard let self = self else { return }
            self.updateView()
            self.setupPlaceAnOrderView()
        }
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
        let numberOfRowsInSection = viewModel.numberOfRowsInSection
        if numberOfRowsInSection > 0 {
            attributedText.append(.init(string: " (\(numberOfRowsInSection) товаров)",
                                        attributes: [.font:  appearance.titleFont,
                                                     .foregroundColor: appearance.subtitleColor]))
        }
        titleLbl.attributedText = attributedText
        navigationItem.titleView = titleLbl
    }

    fileprivate func setupTV() {
        view.addSubview(tableView)
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide.snp.top)
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }

        tableView.delegate   = tableViewManager
        tableView.dataSource = tableViewManager
        
        tableView.separatorInset = .init(top: 0, left: 1000, bottom: 0, right: 0)
        tableView.backgroundColor = appearance.tableViewBackgroundColor
        tableView.separatorStyle = appearance.tableViewSeparatorStyle
        tableView.alwaysBounceVertical = true

        tableView.registerdequeueReusableCell(BasketTVCell.self)
        tableView.registerdequeueReusableHeaderFooter(BasketTVFooter.self)
        setupPullRefreshControl(#selector(fetchBasket))

        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.tableFooterView = UIView(frame: .zero)
    }

    fileprivate func updateView() {
        updateTitleLbl()
        tableView.tableFooterView = tableViewManager.makeTableViewFooter(tableView)
        reloadData()
    }

    func setupPullRefreshControl(_ selector: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.bounds = .init(x: 0, y: 0, width: 12, height: 12)
        refreshControl.addTarget(self, action: selector, for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }

    fileprivate func setupPlaceAnOrderView() {
        guard let basket = viewModel.basket, !basket.carts.isEmpty else {
            placeAnOrderView.removeFromSuperview()
            tableView.contentInset = .init(top: 12, left: 0, bottom: 0, right: 0)
            return
        }
        tableView.contentInset = .init(top: 12,
                                       left: 0,
                                       bottom: appearance.placeAnOrderViewHeight,
                                       right: 0)
        view.addSubview(placeAnOrderView)
        placeAnOrderView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
            make.height.equalTo(appearance.placeAnOrderViewHeight)
            make.width.equalTo(Constants.screenWidth)
        }
        placeAnOrderView.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0.02 * Double(viewModel.numberOfRowsInSection), animations: {
            self.placeAnOrderView.alpha = 1
        })
    }
}

extension BasketVC: BasketTVManagerDelegate {
    func pushToBasketDetail(_ drug: Drug?) {
        guard let drug = drug else {
            BannerTop.showToast(message: "Данный объект не найден", and: .systemRed)
            return
        }
        let vc = DrugDetailTVC(.init(), id: drug.id)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeFavourite(_ cart: Cart,
                         _ isFavorite: Bool) {
        viewModel.changeFavourite(cart, isFavorite) { [weak self] _ in
            guard let self = self else { return }
            self.changeFavouritesbadgeValue(isFavorite, 1)
            self.updateView()
        }
    }

    func deleteCart(_ cart: Cart) {
        viewModel.deleteCart(cart) { [weak self] in
            guard let self = self else { return }
            self.updateView()
        }
    }

    func changeQuantity(_ cart: Cart, _ quantity: Int) {
        viewModel.changeQuantity(cart, quantity) { [weak self] in
            guard let self = self else { return }
            self.updateView()
        }
    }
}

extension BasketVC: PlaceAnOrderViewDelegate {
    func didTappedSubmitBtn() {
        guard let basket = viewModel.basket else { return }
        let vc = CheckoutTVC(.init(basket))
        vc.checkoutOrderCalback = { [weak self]  status, link in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
            self.changeBasketBadgeValue(false, (AppSession.basketCount ?? 0) + 1)
            self.fetchBasket()
            guard let link = link else {
                self.showStatusBottomSheet(self, status)
                return
            }
            self.openLinkInApp(link) { [ weak self] in
                guard let self = self else { return }
                self.showStatusBottomSheet(self, status)
            }
        }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    fileprivate func showStatusBottomSheet(_ self: BasketVC, _ status: Bool) {
        let sheet = CheckoutStatusBottomSheet.instance
        sheet.tappedSubmitBtn = { [weak self] status in
            guard let self = self else { return }
            self.selectTabBar()
        }
        sheet.show(status)
    }

    fileprivate func selectTabBar() {
        guard let currentVC = UIApplication.topViewController(),
              let selectedIndex = currentVC.tabBarController?.selectedIndex, selectedIndex > 0 else {
            return
        }
        currentVC.tabBarController?.selectedIndex = 0
    }
}
