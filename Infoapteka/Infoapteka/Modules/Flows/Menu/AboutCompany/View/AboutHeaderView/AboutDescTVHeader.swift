//
//  AboutDescTVHeader.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK: Appearance
extension AboutDescTVHeader {
    struct Appearance {
        let backViewColor: UIColor = Asset.mainWhite.color
        let backViewLayerRadius: CGFloat = 16.0
        let backViewLayerMaskToBounds: Bool = true
        let backViewTopMargin: CGFloat = 16.0
        let backViewBottomMargin: CGFloat = 8.0
        let backViewRightLeftMargin: CGFloat = 20.0
        let titleLblMargin: CGFloat = 12.0
        
        let textNumberOfLines: Int = .zero
        let blackTextColor: UIColor = Asset.mainBlack.color
        let titleFont: UIFont = FontFamily.Inter.bold.font(size: 15)
        let descFont: UIFont = FontFamily.Inter.regular.font(size: 14)
    }
}

class AboutDescTVHeader: UITableViewHeaderFooterView {

    // MARK: UI Components
    private lazy var backView = UIView().then {
        $0.backgroundColor = appearance.backViewColor
        $0.layer.cornerRadius = appearance.backViewLayerRadius
        $0.layer.masksToBounds = appearance.backViewLayerMaskToBounds
        $0.isHidden = true
    }
    
    private lazy var titleLbl = UILabel().then {
        $0.numberOfLines = appearance.textNumberOfLines
    }
    
    // MARK: Properties
    private var aboutResult: AboutCompanyResult? {
        didSet {
            guard let aboutResult = aboutResult else { return }
            setAttr(aboutResult.title ?? "", aboutResult.desc ?? "")
            makeConstraints()
            backView.isHidden = false
        }
    }
    private let appearance = Appearance()

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
        backView.addSubview(titleLbl)
    }
    
    private func makeConstraints() {
        backView.snp.remakeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(appearance.backViewTopMargin)
            make.left.right.equalToSuperview().inset(appearance.backViewRightLeftMargin)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
        
        titleLbl.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(appearance.titleLblMargin)
            make.right.left.equalToSuperview().inset(appearance.titleLblMargin)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    // MARK: Set Title Attributes
    private func setAttr(_ title: String, _ desc: String) {
        let attr = NSMutableAttributedString(string: title,
                                             attributes: [.foregroundColor: appearance.blackTextColor,
                                                          .font: appearance.titleFont])
        attr.append(.init(string: "\n\n\(desc)",
                          attributes: [.foregroundColor: appearance.blackTextColor,
                                       .font: appearance.descFont]))
        titleLbl.attributedText = attr
    }
    
    func setupHeader(_ aboutResult: AboutCompanyResult?) {
        self.aboutResult = aboutResult
    }
}
