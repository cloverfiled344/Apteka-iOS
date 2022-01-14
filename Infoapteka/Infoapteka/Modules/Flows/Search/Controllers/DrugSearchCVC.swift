//
//  DrugSearchCVC.swift
//  Infoapteka
//
//  Created by Avazbek Kodiraliev on 25/8/21.
//

import UIKit
import PinterestLayout

extension DrugSearchCVC {
    struct Appearance {
        let backgroundColor = Asset.secondaryWhite.color

        let numberOfColumns : Int = 1
        let cellPadding     : CGFloat = 4.0
    }
}

class DrugSearchCVC: BaseCVC {

    private var viewModel: DrugSearchVM
    private var appearance = Appearance()
    private var collectionViewManager: DrugSearchCVManager

    init(_ viewModel: DrugSearchVM) {
        self.viewModel              = viewModel
        self.collectionViewManager  = .init(self.viewModel)

        let layout = PinterestLayout()
        layout.numberOfColumns = appearance.numberOfColumns
        layout.cellPadding = appearance.cellPadding
        super.init(collectionViewLayout: layout)
        layout.delegate = self.collectionViewManager
        self.collectionViewManager.delegate = self
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
        checkTitleView([.logoIV, .searchHintTF, .notificationBtn], self)
        
        collectionView.backgroundColor = appearance.backgroundColor

        collectionView.delegate   = collectionViewManager
        collectionView.dataSource = collectionViewManager
        
        collectionView.registerdequeueReusableHeader(DrugSearchCVHeader.self)
        collectionView.registerdequeueReusableCell(DrugGridCVCell.self)
        collectionView.registerdequeueReusableCell(DrugListCVCell.self)
        collectionView.contentInset = .init(top: .zero, left: 20, bottom: .zero, right: 20)
        collectionViewManager.setup { [weak self] in
            guard let self = self else { return }
            self.reloadData()
        }
    }
}


extension DrugSearchCVC: DrugSearchCVManagerDelegate {
    func didSelectFilterView() {

    }

    func changeCollectionType(_ collectionType: CollectionType) {
        viewModel.collectionType = collectionType
        reloadData()
    }
}
