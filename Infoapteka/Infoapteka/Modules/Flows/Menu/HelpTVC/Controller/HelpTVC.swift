//
//  HelpTVC.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK: Appearance
extension HelpTVC {
    struct Appearance {
        let tableViewBackgroundColor: UIColor = Asset.backgroundGray.color
        let tableViewSeparatorStyle: UITableViewCell.SeparatorStyle = .none
    }
}

class HelpTVC: BaseTVC {
    
    // MARK: Properties
    private let appearance = Appearance()
    private var viewModel: HelpResultVM
    private var tableViewManager: HelpTVManager
    
    init(_ viewModel: HelpResultVM) {
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
        self.setupTV()
        self.tableViewManager.setup { [weak self] in
            self?.reloadData()
        }
    }
    
    private func setupTV() {
        self.tableView.separatorStyle = appearance.tableViewSeparatorStyle
        self.tableView.backgroundColor = appearance.tableViewBackgroundColor
        self.tableView.delegate = self.tableViewManager
        self.tableView.dataSource = self.tableViewManager
        self.tableView.registerdequeueReusableCell(HelpTVCell.self)
    }
}
