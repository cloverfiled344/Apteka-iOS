//
//  DrugStorePhoneTVCell.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK: Appearance
extension DrugStorePhoneTVCell {
    struct Appearance {
        let cellSelectionStyle: UITableViewCell.SelectionStyle = .none
        let phoneTextColor: UIColor = Asset.mainBlack.color
        let phoneTextFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let phoneIcon: UIImage = Asset.icWithBackgroundCall.image
        let phoneIVContentMode: UIImageView.ContentMode = .scaleAspectFill
        let leftRightMargin: CGFloat = 20.0
    }
}

class DrugStorePhoneTVCell: UITableViewCell {

    // MARK: UI Components
    private lazy var phoneTitle = UILabel().then {
        $0.font = appearance.phoneTextFont
        $0.textColor = appearance.phoneTextColor
    }
    
    private lazy var phoneIV = UIImageView().then {
        $0.contentMode = appearance.phoneIVContentMode
    }
    
    // MARK: Properties
    private let appearance = Appearance()
    private var phone: String? {
        didSet {
            phoneTitle.text = phone
            phoneIV.image = appearance.phoneIcon
        }
    }
    
    // MARK: Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = appearance.cellSelectionStyle
        contentView.addSubview(phoneTitle)
        contentView.addSubview(phoneIV)
        setConstaints()
    }
    
    private func setConstaints() {
        phoneTitle.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left).offset(appearance.leftRightMargin)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8.0)
        }
        
        phoneIV.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(phoneTitle.snp.right).offset(8)
            make.right.equalTo(contentView.snp.right).offset(-appearance.leftRightMargin)
            make.height.width.equalTo(32.0)
            make.centerY.equalTo(phoneTitle.snp.centerY)
        }
    }
    
    func setupCell(_ phone: String?) {
        self.phone = phone
    }
}
