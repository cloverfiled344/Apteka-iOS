//
//  SearchHint.swift
//  Infoapteka
//
//

import UIKit

extension SearchHintTVC {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color
        let separatorColor: UIColor = Asset.light.color
        
    }
}

class SearchHintTVC: BaseTVC {

    private var appearance = Appearance()
    private var viewModel: SearchHintVM
    private var tableViewManager: SearchHintTVManager
    var hintSelected: ((String?) -> ())?

    init(_ viewModel: SearchHintVM) {
        self.viewModel = viewModel
        self.tableViewManager = .init(viewModel)
        super.init(nibName: nil, bundle: nil)
        self.tableViewManager.delegate = self
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
        checkTitleView([.searchTF, .notificationBtn], self)

        tableView.delegate   = tableViewManager
        tableView.dataSource = tableViewManager

        tableView.separatorColor = appearance.separatorColor
        
        tableView.registerdequeueReusableCell(SearchHintTVCell.self)
        tableView.registerdequeueReusableHeaderFooter(SearchHintFooter.self)

        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableHeaderView = UIView(frame: .zero)

        fetchHints(nil)
    }

    fileprivate func fetchHints(_ search: String?) {
        tableViewManager.setup(search) { [weak self] in
            guard let self = self else { return }
            self.reloadData()
            self.tableView.tableFooterView = self.tableViewManager.makeFooterView(self.tableView)
        }
    }
}

extension SearchHintTVC: SearchHintTVCManagerDelegate {
    func hintSelected(_ hint: String?) {
        processSwitchVC(hint)
    }

    func footerSelected() {
        BannerTop.showToast(message: "Это часть в разработке еще", and: .lightGray)
        print("Footer")
    }
}

extension SearchHintTVC: InfoaptekaNavBarSearchViewDelegate {
    func didTapLogo() {
        guard let selectedIndex = tabBarController?.selectedIndex, selectedIndex > 0 else {
            return
        }
        tabBarController?.selectedIndex = 0
    }

    func textFieldShouldReturn(_ text: String) {
        processSwitchVC(text)
    }

    func searchTextFieldValueChanged(_ text: String) {
        fetchHints(text)
    }

    fileprivate func processSwitchVC(_ hint: String?) {
        if let hintSelected = hintSelected {
            hintSelected(hint)
        } else {
            view.endEditing(true)
            let drugSearchCV = DrugSearchVC(.init(viewModel.category), hint ?? "")
            drugSearchCV.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(drugSearchCV, animated: true)
        }
    }
}
