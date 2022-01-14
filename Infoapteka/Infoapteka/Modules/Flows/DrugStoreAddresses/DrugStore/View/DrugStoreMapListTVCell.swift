//
//  DrugStoreMapListTVCell.swift
//  Infoapteka
//
//  
//

import UIKit

extension DrugStoreMapListTVCell {
    
    struct Appearance {
        let iconIVLayerCornerRadius: CGFloat = 12.0
        let iconPlaceholder: UIImage = Asset.icImagePlaceholder.image
        let iconContentMode: UIImageView.ContentMode = .scaleAspectFill
        let closeText: String = "Закрыто"
        let openText: String = "Сейчас открыто"
        let closeTextColor: UIColor = Asset.secondaryRed.color
        let openTextColor: UIColor = Asset.orange.color
        let titleTextColor: UIColor = Asset.mainBlack.color
        let titleTextFont: UIFont = FontFamily.Inter.semiBold.font(size: 13)
        let subtitleTextFont: UIFont = FontFamily.Inter.regular.font(size: 13)
        let distanceTextColor: UIColor = Asset.secondaryGray.color
        let distacneTextFont: UIFont = FontFamily.Inter.medium.font(size: 11)
        let bottomLineColor: UIColor = Asset.secondaryLight.color
        let iconHeightWidht: CGFloat = Constants.screenHeight / (Constants.screenHeight / 120.0)
    }
}

class DrugStoreMapListTVCell: UITableViewCell {

    // MARK: UI Components
    private lazy var iconIV = UIImageView().then {
        $0.contentMode = appearance.iconContentMode
        $0.layer.cornerRadius = appearance.iconIVLayerCornerRadius
        $0.layer.masksToBounds = true
    }
    
    private lazy var statusLbl = UILabel().then {
        $0.font = appearance.distacneTextFont
        $0.numberOfLines = 1
    }
    
    private lazy var distanceLbl = UILabel().then {
        $0.numberOfLines = 1
        $0.textColor = appearance.distanceTextColor
        $0.font = appearance.distacneTextFont
        $0.textAlignment = .right
    }
    
    private lazy var titleLbl = UILabel().then {
        $0.font = appearance.titleTextFont
        $0.numberOfLines = 2
        $0.textColor = appearance.titleTextColor
    }
    
    private lazy var subtitleLbl = UILabel().then {
        $0.font = appearance.subtitleTextFont
        $0.numberOfLines = 2
        $0.textColor = appearance.titleTextColor
    }
    
    private lazy var topLine = UIView().then {
        $0.backgroundColor = appearance.bottomLineColor
    }
    
    private lazy var bottomLine = UIView().then {
        $0.backgroundColor = appearance.bottomLineColor
    }
    
    // MARK: Properties
    private let appearance = Appearance()
    private var drugStore: DrugStore? {
        didSet {
            guard let drugStore = drugStore else { return }
            iconIV.load(drugStore.image ?? "", appearance.iconPlaceholder)
            setupStyleOfStatusLbl(drugStore.isOpen)
            distanceLbl.text = drugStore.distance
            titleLbl.text = drugStore.name
            subtitleLbl.text = drugStore.address
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
        selectionStyle = .none
        contentView.addSubview(topLine)
        contentView.addSubview(iconIV)
        contentView.addSubview(statusLbl)
        contentView.addSubview(distanceLbl)
        contentView.addSubview(titleLbl)
        contentView.addSubview(subtitleLbl)
        contentView.addSubview(bottomLine)
        setConstaints()
    }
    
    private func setConstaints() {
        topLine.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView)
            maker.height.equalTo(1.0)
            maker.left.equalTo(contentView.snp.left).offset(20.0)
            maker.right.equalTo(contentView.snp.right).offset(-20.0)
        }
        
        iconIV.snp.makeConstraints { (maker) in
            maker.top.equalTo(topLine.snp.bottom).offset(12)
            maker.left.equalTo(contentView.snp.left).offset(20.0)
            maker.width.height.equalTo(appearance.iconHeightWidht)
        }
        
        statusLbl.snp.makeConstraints { (maker) in
            maker.top.equalTo(iconIV)
            maker.left.equalTo(iconIV.snp.right).offset(12)
        }
        
        distanceLbl.snp.makeConstraints { (maker) in
            maker.top.equalTo(statusLbl.snp.top)
            maker.right.equalTo(contentView.snp.right).offset(-20.0)
            maker.left.equalTo(statusLbl.snp.right).offset(20)
            maker.centerY.equalTo(statusLbl.snp.centerY)
        }
        
        titleLbl.snp.makeConstraints { (maker) in
            maker.top.equalTo(statusLbl.snp.bottom).offset(8)
            maker.left.equalTo(statusLbl.snp.left)
            maker.right.equalTo(distanceLbl.snp.right)
        }
        
        subtitleLbl.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLbl.snp.bottom).offset(12)
            maker.right.left.equalTo(statusLbl)
        }
        
        bottomLine.snp.makeConstraints { (maker) in
            maker.height.equalTo(1.0)
            maker.top.equalTo(iconIV.snp.bottom).offset(12)
            maker.left.equalTo(contentView.snp.left).offset(20.0)
            maker.right.equalTo(contentView.snp.right).offset(-20.0)
            maker.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    private func setupStyleOfStatusLbl(_ isOpen: Bool) {
        statusLbl.text = isOpen ? appearance.openText : appearance.closeText
        statusLbl.textColor = isOpen ? appearance.openTextColor : appearance.closeTextColor
    }
    
    func setupCell(_ drugStore: DrugStore?) {
        self.drugStore = drugStore
    }
}
