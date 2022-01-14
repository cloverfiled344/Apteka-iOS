//
//  DrugStoreСVC.swift
//  Infoapteka
//
//  
//

import UIKit
import CoreLocation

extension DrugStoreСVC {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color
        let segmentControlCornerRadius: CGFloat = 12.0
        let segmentViewHeight: CGFloat = Constants.screenWidth * 0.1

        let titleOfStore: String = "Адрес на карте"
        let titleOfMap: String = "Адреса аптек"
    }
}

class DrugStoreСVC: BaseVC {
    
    // MARK: UI Components
    private lazy var segmentView = DrugStoreCVHeader().then {
        $0.delegate = self
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    // MARK: Properties
    private let appearance = Appearance()
    private var viewModel: DrugStoreVM
    private var collectionViewManager: DrugStoreCVManager
    
    // MARK: Initialize
    init(_ viewModel: DrugStoreVM) {
        self.viewModel = viewModel
        self.collectionViewManager = .init(self.viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lify Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        view.backgroundColor = appearance.backgroundColor
        view.addSubview(segmentView)
        view.addSubview(collectionView)
        setupSegmentView()
        setupCV()
    }
    
    private func setupSegmentView() {
        segmentView.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(16.0)
            make.right.left.equalToSuperview()
            make.height.equalTo(appearance.segmentViewHeight)
        }
    }
    
    private func setupCV() {
        title = appearance.titleOfStore
        
        collectionView.backgroundColor = appearance.backgroundColor
        collectionView.isScrollEnabled = false
        
        collectionView.registerdequeueReusableCell(DrugStoreMapListCVCell.self)
        collectionView.registerdequeueReusableCell(DrugStoreMapCVCell.self)
        
        collectionViewManager.delegate = self
        collectionView.backgroundColor = Asset.mainWhite.color
        collectionView.dataSource = collectionViewManager
        collectionView.delegate = collectionViewManager
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }

    @objc private func fetchData() {
        collectionViewManager.setup { [weak self] in
            guard let self = self else { return }
            self.reloadData()
        }
    }

    private func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }

    deinit {
        print("deinit DrugStoreСVC")
    }
}

// MARK: Manager Delegate
extension DrugStoreСVC: DrugStoreCVManagerDelegate {
    
    func tappedDrugAnnotation(_ drugStore: DrugStore) {
        let sheetInstance = MapPointSheetView.instance
        sheetInstance.setupData(drugStore)
        sheetInstance.show()
    }
  
    func updateView() {
        reloadData()
    }

    func pushToStoreDetail(_ id: Int?) {
        guard let id = id else {
            BannerTop.showToast(message: "Идентификатор данного объекта не найден", and: .systemRed)
            return
        }
        let vc = DrugStoreDetailTVC(id, .init())
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DrugStoreСVC: DrugStoreCVHeaderDelegate {
    func switchSelectionIndex(_ index: Int) {
        title = index == 1 ? appearance.titleOfStore : appearance.titleOfMap
        collectionView.isScrollEnabled = true
//        index == 1 ? collectionView.reloadData() : nil
        collectionView.scrollToItem(at: .init(row: index, section: .zero),
                                    at: .centeredHorizontally, animated: true)
        collectionView.isScrollEnabled = false
    }
}
