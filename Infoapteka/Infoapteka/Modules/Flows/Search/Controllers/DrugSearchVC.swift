//
//  DrugSearchCVC.swift
//  Infoapteka
//
//

import UIKit
import PinterestLayout
import FloatingPanel

extension DrugSearchVC {
    struct Appearance {
        let backgroundColor = Asset.secondaryWhite.color

        let numberOfColumns : Int = 2
        let cellPadding     : CGFloat = 4.0

        let citiesTVCMaskedCorners: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        let citiesTVCCornerRadius: CGFloat = 8.0

        let fpcBackgorundColor: UIColor = Asset.mainBlack.color.withAlphaComponent(0.3)
    }
}

class DrugSearchVC: BaseVC {

    private var viewModel: DrugSearchVM
    private var appearance = Appearance()
    private var collectionViewManager: DrugSearchCVManager

    private lazy var collectionView: UICollectionView = {
        let layout = PinterestLayout()
        layout.numberOfColumns = viewModel.collectionType == .grid ? 2 : 1
        layout.cellPadding = appearance.cellPadding
        layout.delegate = collectionViewManager
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.alwaysBounceVertical = true
        return view
    }()

    lazy private var fpc: FloatingPanelController = {
        let fpc = FloatingPanelController()
        fpc.view.backgroundColor = appearance.fpcBackgorundColor
        (fpc.view.subviews.first)?.isUserInteractionEnabled = false
        return fpc
    }()

    private lazy var filterTVC: FilterTVC = {
        let vc = FilterTVC(.init())
        vc.view.layer.maskedCorners = appearance.citiesTVCMaskedCorners
        vc.view.layer.cornerRadius  = appearance.citiesTVCCornerRadius
        vc._delegate = self
        return vc
    }()
    
    init(_ viewModel: DrugSearchVM, _ search: String) {
        self.viewModel              = viewModel
        self.viewModel.searchStr    = search
        self.collectionViewManager  = .init(self.viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBarBackColor(statusBarBackColor: .white,
                           navBarBackColor: .white,
                           navBarTintColor: .white,
                           prefersLargeTitles: false)

        switch viewModel.showType {
        case .search:
            checkTitleView([.logoIV, .searchHintTF, .notificationBtn], self)
            (self.navigationItem.titleView?.subviews.first as? InfoaptekaNavBarSearchView)?.setSearchText(self.viewModel.searchStr ?? "")
        case .ownerProfile: break
        }

        view.backgroundColor = Asset.mainWhite.color
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        collectionView.backgroundColor = appearance.backgroundColor
        collectionView.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionViewManager.delegate = self
        collectionView.delegate   = collectionViewManager
        collectionView.dataSource = collectionViewManager
        
        collectionView.registerdequeueReusableHeader(DrugSearchCVHeader.self)
        collectionView.registerdequeueReusableCell(DrugGridCVCell.self)
        collectionView.registerdequeueReusableCell(DrugListCVCell.self)
        collectionView.registerdequeueReusableCell(IndicatorCell.self)
        collectionViewManager.setup { [weak self] in
            guard let self = self else { return }
            self.reloadData {
                self.viewModel.isLoading = false
            }
        }
    }

    func reloadData(_ complation: @escaping (() -> ())) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.performBatchUpdates(nil,
                                                    completion: {
                                                        (result) in
                                                        complation()
                                                    })
        }
    }
    
    private func setupFPC() {
        removePanelFromParent()
        fpc.delegate = self
        let searchFilter = viewModel.searchFilter
        searchFilter != nil ? filterTVC.setFilter(searchFilter!) : nil
        fpc.set(contentViewController: filterTVC)
        fpc.track(scrollView: filterTVC.tableView)
        fpc.addPanel(toParent: self, animated: true)
        fpc.move(to: .half, animated: true)
    }
}

extension DrugSearchVC: DrugSearchCVManagerDelegate {
    
    func pushToDrugSearchDetail(_ drug: Drug?) {
        guard let drug = drug else {
            BannerTop.showToast(message: "Данный объект не найден", and: .systemRed)
            return
        }
        let vc = DrugDetailTVC(.init(), id: drug.id)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addedToBasket(_ sender: UIButton, _ animateViewTo: AnimateViewTo, _ isAdded: Bool) {
        getSenderFromSuperView(sender, animateViewTo, collectionView, isAdded)
    }

    func addedToFavourite(_ sender: UIButton, _ animateViewTo: AnimateViewTo, _ isAdded: Bool) {
        getSenderFromSuperView(sender, animateViewTo, collectionView, isAdded)
    }

    func paginateDrugs() {
        self.reloadData { [weak self] in
            guard let self = self else { return }
            self.reloadData {
                self.viewModel.isLoading = false
            }
        }
    }

    func changeIsFavorite(_ drug: Drug) {
        self.reloadData {
            self.viewModel.isLoading = false
        }
    }

    func changeInBasket(_ drug: Drug) {
        self.reloadData {
            self.viewModel.isLoading = false
        }
    }

    func didSelectFilterView() {
        setupFPC()
    }

    func changeCollectionType(_ collectionType: CollectionType) {
        if viewModel.collectionType != collectionType {
            viewModel.collectionType = collectionType
            (collectionView.collectionViewLayout as? PinterestLayout)?.numberOfColumns = viewModel.collectionType == .grid ? 2 : 1
            self.reloadData {
                self.viewModel.isLoading = false
            }
        }
    }
}

extension DrugSearchVC: FloatingPanelControllerDelegate {
    fileprivate func removePanelFromParent() {
        fpc.delegate = nil
        fpc.removePanelFromParent(animated: true)
    }

    func floatingPanelDidChangePosition(_ vc: FloatingPanelController) {
        if vc.position == FloatingPanelPosition.tip {
            removePanelFromParent()
        }
    }
}

extension DrugSearchVC: FilterTVCDelegate {
    func selected(_ searchFilter: SearchFilter?) {
        viewModel.searchFilter = searchFilter
        fpc.move(to: .tip, animated: true)
        fpc.delegate = nil
        fpc.removePanelFromParent(animated: true)
        collectionViewManager.setup {
            self.reloadData {
                self.viewModel.isLoading = false
            }
        }
    }
}

extension DrugSearchVC: InfoaptekaNavBarSearchViewDelegate {
    func searchTextFieldEditingDidBegin() {
        let vc = SearchHintTVC(.init(nil))
        vc.hintSelected = { [weak self] hint in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
            self.viewModel.searchStr = hint
            (self.navigationItem.titleView?.subviews.first as? InfoaptekaNavBarSearchView)?.setSearchText(self.viewModel.searchStr ?? "")
            self.collectionViewManager.setup {
                self.reloadData {
                    self.viewModel.isLoading = false
                }
            }
        }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: false)
    }
}
