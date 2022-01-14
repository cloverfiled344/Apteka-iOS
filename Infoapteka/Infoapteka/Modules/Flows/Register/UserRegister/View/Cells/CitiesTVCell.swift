//
//  CitiesTVCell.swift
//  Infoapteka
//
//  
//

import UIKit

extension CitiesTVCell {
    struct Appearance {
        let cellSelectioStyle: UITableViewCell.SelectionStyle = .none
        let lineViewColor: UIColor = Asset.light.color
        let cityTextFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let cityTextColor: UIColor = Asset.mainBlack.color
        let lineViewHeight: CGFloat = 1.07
        let unselectedButton: UIImage = Asset.icUnselectedRadioButton.image
        let selectedButton: UIImage = Asset.icSelectedRadioButton.image
    }
}

class CitiesTVCell: UITableViewCell {
    
    // MARK: UI Components
    private lazy var cityContentLabel: UILabel = {
        let view = UILabel()
        view.font = appearance.cityTextFont
        view.textColor = appearance.cityTextColor
        return view
    }()
    
    private lazy var radioButton: UIButton = {
        let view = UIButton()
        view.setImage(appearance.unselectedButton, for: .normal)
        return view
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.lineViewColor
        return view
    }()
    
    // MARK: Properties
    private let appearance = Appearance()
    
    // MARK: Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        self.selectionStyle = appearance.cellSelectioStyle
        self.contentView.addSubview(cityContentLabel)
        self.contentView.addSubview(radioButton)
        self.contentView.addSubview(lineView)
        self.setConstraints()
    }
    
    private func setConstraints() {
        self.radioButton.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(self.contentView.snp.trailing).offset(-20)
            maker.top.equalTo(self.contentView.snp.top).offset(12)
        }
        
        self.cityContentLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.radioButton.snp.top)
            maker.leading.equalTo(self.contentView.snp.leading).offset(20)
            maker.trailing.equalTo(self.radioButton.snp.leading).offset(20)
        }
        
        self.lineView.snp.makeConstraints { (maker) in
            maker.height.equalTo(appearance.lineViewHeight)
            maker.top.equalTo(self.cityContentLabel.snp.bottom).offset(12)
            maker.leading.equalTo(self.cityContentLabel.snp.leading)
            maker.trailing.equalTo(self.radioButton.snp.trailing)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-12)
        }
    }
}

