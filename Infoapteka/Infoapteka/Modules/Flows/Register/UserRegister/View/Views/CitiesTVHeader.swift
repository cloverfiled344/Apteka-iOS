//
//  CitiesTVHeader.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK: Appearance
extension CitiesTVHeader {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color

        let titleLabelTextColor: UIColor = Asset.mainBlack.color
        let titleLabelTextFont: UIFont = FontFamily.Inter.bold.font(size: 15)

        let offset: CGFloat = 20.0
    }
}

class CitiesTVHeader: UITableViewHeaderFooterView {

    // MARK: UI Components
    private lazy var titleLbl: UILabel = {
        let view = UILabel()
        view.textColor = appearance.titleLabelTextColor
        view.font = appearance.titleLabelTextFont
        return view
    }()
    
    // MARK: Properties
    private let appearance = Appearance()
    
    // MARK: Initialize
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = appearance.backgroundColor
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (maker) in
            maker.top.left.equalToSuperview().offset(appearance.offset)
            maker.bottom.right.equalToSuperview().offset(-appearance.offset)
        }
    }

    // MARK: -- public methods
    func setTitle(_ title: String) {
        self.titleLbl.text = title
    }
}
