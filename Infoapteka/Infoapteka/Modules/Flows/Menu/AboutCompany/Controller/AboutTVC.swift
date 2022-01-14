//
//  AboutTVC.swift
//  Infoapteka
//
//  
//

import UIKit

extension AboutTVC {
    struct Appearance {
        
    }
}

class AboutTVC: BaseTVC {
    
    // MARK: Properties
    private var viewModel: AboutCompanyResultVM
    private var tableViewManager: AboutCompanyTVManager
    
    // MARK: Initialize
    init(_ viewModel: AboutCompanyResultVM) {
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
        tableView.backgroundColor = Asset.backgroundGray.color
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
        
        tableView.registerdequeueReusableHeaderFooter(AboutDescTVHeader.self)
        tableView.registerdequeueReusableHeaderFooter(AboutAddressTVHeader.self)
        tableView.registerdequeueReusableHeaderFooter(AboutCompanyMapTVHeader.self)
        
        tableView.registerdequeueReusableCell(AboutSocialsTVCell.self)
        tableView.registerdequeueReusableCell(AboutPhoneTVCell.self)
        
        tableView.dataSource = tableViewManager
        tableView.delegate = tableViewManager
        
        tableViewManager.delegate = self
        
        setupPullRefreshControl(#selector(fetchData))
    }
    
    @objc private func fetchData() {
        tableViewManager.setup { [weak self] in
            guard let `self` = self else { return }
            self.reloadData()
        }
    }
}

extension AboutTVC: AboutCompanyTVManagerDelegate {
    func didTappedOnSocialMedia(_ link: String?) {
        guard let link = link else {
            BannerTop.showToast(message: "Неправильная ссылка!", and: .systemRed)
            return
        }
        openLink(link)
    }
    
    func didTappedOnPhone(_ phone: String?) {
        guard let phone = phone else {
            BannerTop.showToast(message: "Неправильная ссылка!", and: .systemRed)
            return
        }
        makeACall(phone)
    }
    
    func didTappedOnEmail(_ link: String?) {
        guard let link = link else {
            BannerTop.showToast(message: "Неправильная ссылка!", and: .systemRed)
            return
        }
        openLink(link)
    }
}
