//
//  MyProductsCVC.swift
//  Infoapteka
//
//  
//

import UIKit
import PinterestLayout

extension MyDrugsCVC {
    struct Appearance {
        let backgroundColor             : UIColor = Asset.backgroundGray.color
        let viewBackgroundColor         : UIColor = Asset.mainWhite.color
        let collectionBackgroundColor   : UIColor = Asset.backgroundGray.color
        
        let numberOfColumns: Int = 2
        let cellPadding: CGFloat = 4.0
        let placeAnOrderViewHeight: CGFloat = 82.0 + Constants.distanceBetweenSuperSafeViews
        let addProductText: String = "Добавить товар"
    }
}

// MARK: UICollectionViewController
class MyDrugsCVC: BaseCVC {
    
    // MARK: UI Components
    private lazy var placeAnOrderView = PlaceAnOrderView().then {
        $0.setupSubmitBtnStyle(appearance.addProductText, Asset.icPlus.image)
        $0.delegate = self
    }
    
    // MARK: Properties
    private var viewModel: MyDrugsVM
    private var collectionViewManager: MyDrugsCVManager
    private let appearance = Appearance()
    
    // MARK: Initialize
    init(_ viewModel: MyDrugsVM) {
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
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor                = appearance.viewBackgroundColor

        collectionView.backgroundColor      = appearance.collectionBackgroundColor
        collectionView.alwaysBounceVertical = true
        
        collectionView.registerdequeueReusableCell(MyDrugCVCell.self)
        collectionView.registerdequeueReusableCell(IndicatorCell.self)
        collectionView.contentInset = .init(top: 20, left: 20, bottom: 0, right: 20)
        
        collectionView.delegate   = collectionViewManager
        collectionView.dataSource = collectionViewManager
        collectionViewManager.delegate = self
        setupPullRefreshControl(#selector(fetchData))
        fetchData()
        setupPlaceAnOrderView()
    }

    @objc private func fetchData() {
        collectionViewManager.setup { [weak self] in
            guard let self = self else { return }
            self.reloadData { }
        }
    }
    
    private func setupPlaceAnOrderView() {
        collectionView.contentInset = .init(top: 20, left: 20,
                                            bottom: appearance.placeAnOrderViewHeight, right: 20)
        view.addSubview(placeAnOrderView)
        placeAnOrderView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.bottom.equalTo(view.snp.bottom)
            maker.height.equalTo(appearance.placeAnOrderViewHeight)
            maker.width.equalTo(Constants.screenWidth)
        }
    }
}

extension MyDrugsCVC: MyDrugsCVManagerDelegate {
    func didSelectItemAt(_ drug: Drug?) {
        guard let drug = drug else {
            BannerTop.showToast(message: "Данный объект не найден", and: .systemRed)
            return
        }
        let vc = DrugDetailTVC(.init(.my), id: drug.id)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    func paginateDrugs() {
        viewModel.paginateDrugs { [weak self] in
            guard let self = self else { return }
            self.reloadData {
                self.viewModel.isLoading = false
            }
        }
    }
    
    func didTappedOnEdit(_ drug: Drug?) {
        guard let drug = drug, let id = drug.id else {
            BannerTop.showToast(message: "Данный объект не найден", and: .systemRed)
            return
        }
        
        let sheetInstance = EditDrugBottomSheet.instance
        sheetInstance.deleteDrug = { [weak self] in
            guard let self = self else { return }
            self.viewModel.removeDrug(id) { [weak self] success in
                guard let self = self else { return }
                sheetInstance.hide()
                self.fetchData()
            }
        }
        
        sheetInstance.editDrug = { [weak self] in
            guard let self = self, let drugID = drug.id else {
                BannerTop.showToast(message: "Данный объект не найден", and: .systemRed)
                return
            }
            self.viewModel.getDrug(drugID) {
                guard let drug = self.viewModel.drug else {
                    BannerTop.showToast(message: "Данный объект не найден", and: .systemRed)
                    return
                }
                let vc = CreateDrugTVC(.init(drug))
                vc.isSuccessEdited = { [weak self] in
                    vc.dismiss(animated: true) {
                        guard let self = self else { return }
                        self.fetchData()
                    }
                }
                let nav = InfoaptekaNavController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
        sheetInstance.show()
    }
}

extension MyDrugsCVC: PlaceAnOrderViewDelegate {
    func didTappedSubmitBtn() {
        let nav = InfoaptekaNavController(rootViewController: CreateDrugTVC(.init()))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}
