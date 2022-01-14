//
//  FavouritesCVC.swift
//  Infoapteka
//
//  
//

import UIKit
import PinterestLayout

// MARK: -- Appearance
extension FavouritesCVC {
    struct Appearance {
        let viewBackgroundColor      : UIColor = Asset.mainWhite.color
        let collectionBackgroundColor: UIColor = Asset.backgroundGray.color
        let numberOfColumns: Int = 2
        let cellPadding    : CGFloat = 5.0

        let title    : String = L10n.favourite
        let titleFont: UIFont = FontFamily.Inter.bold.font(size: 18)
        let titleColor   : UIColor = Asset.mainBlack.color
        let subtitleColor: UIColor = Asset.secondaryGray3.color
    }
}

class FavouritesCVC: BaseCVC {
    
    // MARK: Properties
    private var viewModel               : FavouritesVM
    private var collectionViewManager   : FavouritesCVManager

    lazy private var titleLbl: UILabel = {
        let view = UILabel(frame: .init(x: 0, y: 0, width: Constants.screenWidth, height: 44))
        view.textAlignment = .center
        return view
    }()

    init(_ viewModel: FavouritesVM) {
        self.viewModel             = viewModel
        self.collectionViewManager = .init(viewModel)
        
        let layout = PinterestLayout()
        layout.numberOfColumns = appearance.numberOfColumns
        layout.cellPadding     = appearance.cellPadding
        super.init(collectionViewLayout: layout)
        layout.delegate = collectionViewManager
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    private let appearance = Appearance()
    
    // MARK: Lify Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = appearance.viewBackgroundColor

        collectionView.alwaysBounceVertical = true
        collectionView.contentInset    = .init(top: 20, left: 20, bottom: 20, right: 20)
        collectionView.backgroundColor = appearance.collectionBackgroundColor
        collectionView.registerdequeueReusableCell(DrugGridCVCell.self)
        collectionView.registerdequeueReusableCell(IndicatorCell.self)

        collectionView.dataSource = collectionViewManager
        collectionView.delegate = collectionViewManager
        collectionViewManager.delegate = self

        setupPullRefreshControl(#selector(fetchFavourites))

        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide.snp.top)
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }

        fetchFavourites()
    }

    @objc private func fetchFavourites() {
        collectionViewManager.setup { [weak self] in
            guard let self = self else { return }
            self.reloadData{}
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarBackColor(title: "",
                           statusBarBackColor: .white,
                           navBarBackColor: .white,
                           navBarTintColor: .white,
                           prefersLargeTitles: false)

        view.backgroundColor = appearance.viewBackgroundColor
        updateTitleLbl()
        setTabBarBackColor(tabBarBackColor: .white,
                           tabBarTintColor: .white)
    }

    fileprivate func updateTitleLbl() {
        let attributedText = NSMutableAttributedString(string: appearance.title,
                                                       attributes: [.font: appearance.titleFont,
                                                                    .foregroundColor: appearance.titleColor])
        titleLbl.attributedText = attributedText
        navigationItem.titleView = titleLbl
    }
}

extension FavouritesCVC: FavouritesCVManagerDelegate {
    func pushToFavouriteDetailPage(_ drug: Drug?) {
        guard let drug = drug else {
            BannerTop.showToast(message: "Данный объект не найден", and: .systemRed)
            return
        }
        let vc = DrugDetailTVC(.init(), id: drug.id)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeInBasket(_ drug: Drug,
                        _ sender: UIButton,
                        _ animateViewTo: AnimateViewTo,
                        _ isAdded: Bool) {
        getSenderFromSuperView(sender, animateViewTo, collectionView, isAdded)
    }

    func paginateDrugs() {
        reloadData {
            self.viewModel.isLoading = false
        }
    }

    func changeIsFavorite(_ drug: Drug) {
        self.viewModel.isLoading = true
        viewModel.removeDrug(drug) { [weak self] in
            guard let self = self else { return }
            self.getSenderFromSuperView(.init(), .toFavorite, .init(frame: .zero, collectionViewLayout: .init()), false)
            self.reloadData{
                self.viewModel.isLoading = false
            }
        }
    }
}
