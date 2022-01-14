//
//  DrugStoreDetailTVC.swift
//  Infoapteka
//
//  
//

import UIKit

extension DrugStoreDetailTVC {
    struct Appearance {
        let tableViewBackColor: UIColor = Asset.mainWhite.color
    }
}

class DrugStoreDetailTVC: BaseTVC {
    
    // MARK: Properties
    private let appearance = Appearance()
    private var viewModel: DrugStoreDetailVM
    private var tableViewManager: DrugStoreDetailTVManager
    private var storeId: Int?
    
    // MARK: Initialize
    init(_ id: Int?, _ viewModel: DrugStoreDetailVM) {
        self.storeId = id
        self.viewModel = viewModel
        self.tableViewManager = .init(viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTV()
        fetchData()
    }
    
    private func setupTV() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = appearance.tableViewBackColor
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
        tableView.registerdequeueReusableHeaderFooter(DrugStoreDetailTVHeader.self)
        tableView.registerdequeueReusableHeaderFooter(DrugStoreTVFooter.self)
        tableView.registerdequeueReusableCell(DrugStorePhoneTVCell.self)
        
        tableViewManager.delegate = self
        tableView.dataSource = tableViewManager
        tableView.delegate = tableViewManager
    }
    
    private func fetchData() {
        tableViewManager.setup(storeId) {
            self.reloadData()
        }
    }
}

extension DrugStoreDetailTVC: DrugStoreDetailTVManagerDelegate {
   
    func makeCall(_ phone: String?) {
        guard let phone = phone else {
            BannerTop.showToast(message: "Данная ссылка не активна!", and: .systemRed)
            return
        }
        makeACall(phone)
    }
}
