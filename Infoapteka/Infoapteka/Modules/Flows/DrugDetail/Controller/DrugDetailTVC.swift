//
//  DrugDetailTVC.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK: Appearance
extension DrugDetailTVC {
    struct Appearance {
        let viewBackgroundColor      : UIColor = Asset.mainWhite.color
        let tableViewBackgroundColor : UIColor = Asset.backgroundGray.color
        let separatorStyle: UITableViewCell.SeparatorStyle = .none
    }
}

// MARK: TableViewController
class DrugDetailTVC: BaseVC {
    
    // MARK: UI Components
    private lazy var tableView = UITableView().then {
        $0.backgroundColor = appearance.viewBackgroundColor
    }
    
    private lazy var placeBuyView = PlaceBuyView().then {
        $0.delegate = self
        $0.alpha = .zero
    }
    
    // MARK: Properties
    private let appearance = Appearance()
    private var viewModel:          DrugDetailVM
    private var tableViewManager:   DrugDetailTVManager
    private var drugId:             Int?
    
    // MARK: Initialize
    init(_ viewModel: DrugDetailVM, id: Int?) {
        self.viewModel = viewModel
        self.drugId = id
        self.tableViewManager = .init(viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appearance.viewBackgroundColor
        
        tableView.backgroundColor = appearance.viewBackgroundColor
        tableView.separatorStyle = appearance.separatorStyle
        tableView.alwaysBounceVertical = true

        tableView.registerdequeueReusableHeaderFooter(DrugDetailSlideTVHeader.self)
        tableView.registerdequeueReusableHeaderFooter(DrugDetailDescTVHeader.self)
        tableView.registerdequeueReusableHeaderFooter(DrugDetailInstructTVHeader.self)
        tableView.registerdequeueReusableHeaderFooter(DrugDetailFreqDrugTVHeader.self)
        tableView.registerdequeueReusableCell(DrugDetailExpandableTVCell.self)
        tableView.registerdequeueReusableCell(DrugDetailFreqProdTVCell.self)
        
        tableView.dataSource = tableViewManager
        tableView.delegate = tableViewManager
        tableViewManager.delegate = self
        setupPullToTVRefreshControl(#selector(fetchData), tableView)
        
        fetchData()
    }
    
    @objc private func fetchData() {
        tableViewManager.setup(drugId) { [weak self] failedCount in
            guard let self = self else { return }
            if failedCount >= 3 { self.navigationController?.popViewController(animated: true) }
            self.setupPlaceBuyView()
            self.placeBuyView.alpha = 1
            self.placeBuyView.setupView(self.viewModel.getDrugDetail())
            self.reloadData()
        }
    }
    
    private func setupView() {
        setNavBarBackColor(title: "",
                           statusBarBackColor: .white,
                           navBarBackColor: .white,
                           navBarTintColor: .white,
                           prefersLargeTitles: false)
        setTabBarBackColor(tabBarBackColor: .white,
                           tabBarTintColor: .white)
    }
    
    private func setupPlaceBuyView() {
        let placeBuyViewHeight: Int = Int(view.frame.width * 0.2) + Int(Constants.distanceBetweenSuperSafeViews)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(viewModel.getType() == .my ? 0 : -placeBuyViewHeight)
        }

        guard viewModel.getType() == .other else { return }
        view.addSubview(placeBuyView)
        placeBuyView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(placeBuyViewHeight)
            make.width.equalTo(Constants.screenWidth)
        }
    }

    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
}

extension DrugDetailTVC: DrugDetailTVDelegate {
    func pushToCompanyPage(_ ownerID: Int) {
        let vc = DrugSearchVC(.init(ownerID), "")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    func addedToBasket(_ sender: UIButton, _ animateViewTo: AnimateViewTo, _ collectionView: UICollectionView, _ isAdded: Bool) {
        getSenderFromSuperView(sender, animateViewTo, collectionView, isAdded)
    }
    
    func addedToFavourite(_ sender: UIButton, _ animateViewTo: AnimateViewTo, _ collectionView: UICollectionView, _ isAdded: Bool) {
        getSenderFromSuperView(sender, animateViewTo, collectionView, isAdded)
    }
    
    func getVCForImageSlideShow() -> UIViewController? {
        return self
    }
    
    func pushToDetailFromSimilar(_ drug: Drug) {
        let vc = DrugDetailTVC(.init(), id: drug.id)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DrugDetailTVC: PlaceBuyViewDelegate {
    func didTappedOnFavouriteBtn(_ drug: Drug?) {
        viewModel.changeFavourite(drug) { [weak self] success in
            guard let self = self else { return }
            self.fetchData()
        }
    }
    
    func didTappedOnPurchaseBtn(_ drug: Drug?, _ type: DrugDetailBasketPushType) {
        guard let drug = drug else { return }
        if drug.isAvailable {
            viewModel.addToBasket(drug) { [weak self] success in
                guard let self = self else { return }
                self.fetchData()
            }
        } else {
            let sheet = PreOrderPreviewBottomSheet.instance
            sheet.call = { [weak self] phone in
                guard let self = self else { return }
                self.makeACall(phone)
            }
            sheet.show(drug.owner)
        }
    }
}
