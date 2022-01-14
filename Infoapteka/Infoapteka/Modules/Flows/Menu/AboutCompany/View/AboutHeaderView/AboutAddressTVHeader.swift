//
//  AboutAddressTVHeader.swift
//  Infoapteka
//
//  
//

import UIKit

protocol AboutAddressTVHeaderDelegate {
    func didTappedOnEmail(_ link: String?)
}

// MARK: Appearance
extension AboutAddressTVHeader {
    struct Appearance {
        let backViewColor: UIColor = Asset.mainWhite.color
        let backViewLayerRadius: CGFloat = 16.0
        let backViewLayerMaskToBounds: Bool = true
        let backViewLeftRightMargin: CGFloat = 20.0
        let backViewBottomMargin: CGFloat = 8.0
        
        let titleTextColor: UIColor = Asset.mainBlack.color
        let descTextFont: UIFont = FontFamily.Inter.medium.font(size: 15)
        let titleTextFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let titleNumberOfLines: Int = 0
        let selectionStyle: UITableViewCell.SelectionStyle = .none
        let contentImageMode: UIImageView.ContentMode = .scaleAspectFill
        let emailIcon: UIImage = Asset.icEmail.image
        let addresIcon: UIImage = Asset.icAddress.image
        
        let emailText: String = "Email:"
        let addressText: String = "Наш адрес:"
    }
}

class AboutAddressTVHeader: UITableViewHeaderFooterView {
    
    // MARK: UI Components
    private lazy var backView = UIView().then {
        $0.backgroundColor = appearance.backViewColor
        $0.layer.cornerRadius = appearance.backViewLayerRadius
        $0.layer.masksToBounds = appearance.backViewLayerMaskToBounds
    }
    
    private lazy var emailBtn = UIButton().then {
        $0.setTitleColor(appearance.titleTextColor, for: .normal)
        $0.titleLabel?.font = appearance.titleTextFont
        $0.contentHorizontalAlignment = .left
        $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 8)
        $0.titleEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
        $0.addTarget(self, action: #selector(didTappedOnBtn), for: .touchUpInside)
    }
    
    private lazy var emailTopLbl = UILabel().then {
        $0.font = appearance.descTextFont
        $0.font = appearance.titleTextFont
    }
    
    private lazy var addressTopLbl = UILabel().then {
        $0.font = appearance.descTextFont
        $0.font = appearance.titleTextFont
    }
    
    private lazy var addressIcon = UIImageView().then {
        $0.contentMode = appearance.contentImageMode
    }
    
    private lazy var addressLbl = UILabel().then {
        $0.textColor = appearance.titleTextColor
        $0.font = appearance.titleTextFont
        $0.numberOfLines = .zero
    }
    
    // MARK: Properties
    var delegate: AboutAddressTVHeaderDelegate?
    private let appearance = Appearance()
    
    // MARK: Set Data
    private var companyResult: AboutCompanyResult? {
        didSet {
            guard let companyResult = companyResult else { return }
            emailTopLbl.text = appearance.emailText
            emailBtn.setImage(appearance.emailIcon, for: .normal)
            emailBtn.setTitle(companyResult.email, for: .normal)
            addressTopLbl.text = appearance.addressText
            addressIcon.image = appearance.addresIcon
            addressLbl.text = companyResult.address
            makeConstraints()
        }
    }
    
    // MARK: Initialize
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.addSubview(backView)
        backView.addSubviews([emailTopLbl, emailBtn])
        backView.addSubviews([addressTopLbl, addressIcon, addressLbl])
    }
    
    private func makeConstraints() {
        backView.snp.remakeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(8)
            make.left.right.equalTo(contentView).inset(appearance.backViewLeftRightMargin)
        }
        
        emailTopLbl.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview().inset(20)
        }
        
        emailBtn.snp.remakeConstraints { make in
            make.top.equalTo(emailTopLbl.snp.bottom).offset(8)
            make.height.equalTo(24)
            make.right.equalTo(emailTopLbl.snp.right)
            make.left.equalTo(emailTopLbl.snp.left)
        }
        
        addressTopLbl.snp.remakeConstraints { make in
            make.top.equalTo(emailBtn.snp.bottom).offset(24)
            make.left.right.equalTo(emailTopLbl)
        }
        
        addressIcon.snp.remakeConstraints { make in
            make.top.equalTo(addressTopLbl.snp.bottom).offset(8)
            make.width.height.equalTo(20.0)
            make.left.equalTo(emailTopLbl.snp.left)
            make.bottom.equalToSuperview().offset(-24)
        }
        
        addressLbl.snp.remakeConstraints { make in
            make.centerY.equalTo(addressIcon.snp.centerY)
            make.left.equalTo(addressIcon.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
        }
    }
    
    @objc private func didTappedOnBtn() {
        emailBtn.pulsate()
        delegate?.didTappedOnEmail(companyResult?.email)
    }
    
    func setupCell(_ companyResult: AboutCompanyResult?) {
        self.companyResult = companyResult
    }
}
