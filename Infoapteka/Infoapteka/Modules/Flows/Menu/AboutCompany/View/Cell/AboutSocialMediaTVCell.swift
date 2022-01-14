//
//  AboutSocialMediaTVCell.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK: Appearance
extension AboutSocialMediaTVCell {
    struct Appearance {
        let iconContentMode: UIImageView.ContentMode = .scaleAspectFill
        let titleFont: UIFont = FontFamily.Inter.regular.font(size: 15)
        let titleTextColor: UIColor = Asset.mainBlack.color
        
        let phoneImage: UIImage = Asset.icPhone.image
    }
}

class AboutSocialMediaTVCell: UITableViewCell {
    
    // MARK: UI Components
    private lazy var iconIV = UIImageView().then {
        $0.contentMode = appearance.iconContentMode
        $0.clipsToBounds = true
    }
    
    private lazy var titleLbl = UILabel().then {
        $0.font = appearance.titleFont
        $0.textColor = appearance.titleTextColor
    }
    
    // MARK: Properties
    private let appearance = Appearance()
    
    // MARK: Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        selectionStyle = .none
        contentView.addSubview(iconIV)
        contentView.addSubview(titleLbl)
        makeConstraints()
    }
    
    private func makeConstraints() {
        iconIV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.left.equalTo(iconIV.snp.right).offset(8)
            make.centerY.equalTo(iconIV.snp.centerY)
            make.right.equalToSuperview().offset(-8)
        }
    }
    
    func setupCell(_ title: String?, _ type: AboutCompanyType, _ socialIcon: String?) {
        titleLbl.text = title
        switch type {
        case .phones:
            iconIV.image = appearance.phoneImage
        case .socialMedia:
            iconIV.load(socialIcon ?? "")
        default:
            break
        }
    }
}
