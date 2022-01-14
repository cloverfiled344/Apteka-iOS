//
//  HomeCVC.swift
//  Infoapteka
//
//

import UIKit
import PinterestLayout

// MARK: Appearance
extension HomeCVC {
    struct Appearance {
        let viewBackgroundColor         : UIColor = Asset.mainWhite.color
        let collectionBackgroundColor   : UIColor = Asset.backgroundGray.color
        
        let numberOfColumns: Int = 2
        let cellPadding: CGFloat = 4.0
    }
}

class HomeCVC: BaseCVC {
    
    // MARK: Properties
    private var viewModel               : HomeVM
    private var collectionViewManager   : HomeCVManager
    
    init(_ viewModel: HomeVM) {
        self.viewModel = viewModel
        self.collectionViewManager = .init(viewModel)
        
        let layout = PinterestLayout()
        layout.numberOfColumns  = appearance.numberOfColumns
        layout.cellPadding      = appearance.cellPadding
        super.init(collectionViewLayout: layout)
        layout.delegate = collectionViewManager
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Appearance
    private let appearance = Appearance()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor                = appearance.viewBackgroundColor

        collectionView.backgroundColor      = appearance.collectionBackgroundColor
        collectionView.alwaysBounceVertical = true
        
        collectionView.registerdequeueReusableHeader(HomeCVHeader.self)
        collectionView.registerdequeueReusableCell(DrugGridCVCell.self)
        collectionView.registerdequeueReusableCell(IndicatorCell.self)
        collectionView.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionView.delegate   = collectionViewManager
        collectionView.dataSource = collectionViewManager
        collectionViewManager.delegate = self
        setupPullRefreshControl(#selector(fetchData))

        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide.snp.top)
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }

        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarBackColor(statusBarBackColor:  .white,
                           navBarBackColor:     .white,
                           navBarTintColor:     .white,
                           prefersLargeTitles:  false)
        checkTitleView([.logoIV, .searchHintTF, .notificationBtn], self)
    }
    
    @objc private func fetchData() {
        collectionViewManager.setup { [weak self] in
            guard let self = self else { return }
            self.reloadData {}
        }
    }
}

extension HomeCVC: HomeCVManagerDelegate {
    
    func addedToBasket(_ sender: UIButton, _ animateViewTo: AnimateViewTo, _ isAdded: Bool) {
        getSenderFromSuperView(sender, animateViewTo, collectionView, isAdded)
    }

    func addedToFavourite(_ sender: UIButton, _ animateViewTo: AnimateViewTo, _ isAdded: Bool) {
        getSenderFromSuperView(sender, animateViewTo, collectionView, isAdded)
    }

    func paginateDrugs() {
        viewModel.paginateDrugs { [weak self] in
            guard let self = self else { return }
            self.reloadData {
                self.viewModel.isLoading = false
            }
        }
    }
    
    func pushToDrugDetail(_ drug: Drug?) {
        guard let drug = drug else {
            BannerTop.showToast(message: "Данный объект не найден", and: .systemRed)
            return
        }
        let vc = DrugDetailTVC(.init(), id: drug.id)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushToMapPage() {
        let vc = DrugStoreСVC(.init())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushToDeliveryPage(_ programPolicy: PrivacyPolicy?) {
        let vc = PrivacyPolicyVC()
        vc.setupPDF(programPolicy)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushToInstructionPage(_ programPolicy: PrivacyPolicy?) {
        let vc = PrivacyPolicyVC()
        vc.setupPDF(programPolicy)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openBannerByLink(_ link: String) {
        openLinkInApp(link)
    }

    func didTapNotificationBtn() {
        let vc = NotificationsTVC(.init())
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeCVC: InfoaptekaNavBarSearchViewDelegate {}
