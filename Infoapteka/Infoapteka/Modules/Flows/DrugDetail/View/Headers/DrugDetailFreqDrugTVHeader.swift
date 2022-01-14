//
//  DrugDetailFreqProductTVHeader.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK: Appearance
extension DrugDetailFreqDrugTVHeader {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color
        let titleTextFont: UIFont = FontFamily.Inter.bold.font(size: 20)
        let titleTextColor: UIColor = Asset.mainBlack.color
        let titleText: String = L10n.frequentlyProducts
    }
}

class DrugDetailFreqDrugTVHeader: UITableViewHeaderFooterView {
    
    // MARK: UI Components
    private lazy var titleLbl: UILabel = {
        let view = UILabel()
        view.textColor = appearance.titleTextColor
        view.font      = appearance.titleTextFont
        return view
    }()
    
    // MARK: Properties
    private let appearance = Appearance()
    
    // MARK: Initialize
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = appearance.backgroundColor
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (maker) in
            maker.top.left.equalToSuperview().offset(20.0)
            maker.right.equalToSuperview().offset(-20.0)
            maker.bottom.equalToSuperview().offset(-12.0)
        }
    }
    
    func setupHeader(_ text: String?, _ isSimilar: Bool) {
        if !isSimilar {
            titleLbl.text = text
        }
    }
}
