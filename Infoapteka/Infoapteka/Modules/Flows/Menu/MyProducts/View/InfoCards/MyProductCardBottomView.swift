//
//  MyProductCardBottomView.swift
//  Infoapteka
//
//  
//

import UIKit

protocol MyProductBottomViewDelegate {
    func didTappedOnEditBtn()
}

// MARK: Appearance
extension MyProductCardBottomView {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color
        let priceTextColor: UIColor = Asset.mainBlack.color
        let priceTextFont: UIFont = FontFamily.Inter.bold.font(size: 12)
        let editButtonImage: UIImage = Asset.icProductEditButton.image
        let iconHeightWidht: CGFloat = 28.0
    }
}

class MyProductCardBottomView: UIView {
    
    // MARK: UI Components
    private lazy var priceLabel: UILabel = {
        let view = UILabel()
        view.font = appearance.priceTextFont
        view.textColor = appearance.priceTextColor
        return view
    }()
    
    private lazy var editButton: UIButton = {
        let view = UIButton()
        view.setImage(appearance.editButtonImage, for: .normal)
        view.addTarget(self, action: #selector(didTappedOnEditButton), for: .touchUpInside)
        return view
    }()
    
    // MARK: Properties
    public var delegate: MyProductBottomViewDelegate?
    private let appearance = Appearance()
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = appearance.backgroundColor
        self.addSubview(editButton)
        self.addSubview(priceLabel)
        self.setConstraints()
    }
    
    private func setConstraints() {
        self.editButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.snp.top).offset(6)
            maker.width.height.equalTo(appearance.iconHeightWidht)
            maker.right.equalTo(self.snp.right).offset(-8)
            maker.bottom.equalTo(self.snp.bottom).offset(-8)
        }
        
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.editButton.snp.top)
            maker.left.equalTo(self.snp.left).offset(8)
            maker.right.equalTo(self.editButton.snp.left).offset(-8)
            maker.bottom.equalTo(self.editButton.snp.bottom)
        }
    }
    
    func setPriceText(_ price: Int?) {
        self.priceLabel.text = "\(price ?? .zero)"
    }
    
    @objc private func didTappedOnEditButton() {
        editButton.pulsate()
        delegate?.didTappedOnEditBtn()
    }
}
