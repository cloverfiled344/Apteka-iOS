//
//  DrugDetailInstructTVCell.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK: Appearance
extension DrugDetailInstructTVHeader {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color
        let titleLabelNumberOfLines: Int = .zero
        let titleTextColor: UIColor = Asset.mainBlack.color
        let titleTextFont: UIFont = FontFamily.Inter.semiBold.font(size: 15)
        let titleText: String = L10n.instruction
        let subtitleTextFont: UIFont = FontFamily.Inter.regular.font(size: 13)
        let instructionText: String = L10n.instruction
    }
}

// MARK: UITableViewCell
class DrugDetailInstructTVHeader: UITableViewHeaderFooterView {
    
    // MARK: UI Components
    private lazy var instructionLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = appearance.titleLabelNumberOfLines
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
    
    // MARK: Setup Data
    func setupCell(_ title: String?, _ instruction: String?) {
        setAttr(title ,instruction)
    }
    
    private func setupUI() {
        contentView.backgroundColor = appearance.backgroundColor
        addSubview(instructionLbl)
        instructionLbl.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top).offset(12)
            maker.left.equalTo(snp.left).offset(20)
            maker.right.equalTo(snp.right).offset(-20)
            maker.bottom.equalTo(snp.bottom).offset(-8)
        }
    }
    
    private func setAttr(_ title: String?, _ string: String?) {
        let attr = NSMutableAttributedString(string: title ?? "",
                                             attributes:[.foregroundColor: appearance.titleTextColor,
                                                         .font: appearance.titleTextFont])
        if let text = string, !text.isEmpty {
            attr.append(.init(string: "\n\n\(text)",
                              attributes: [.foregroundColor: appearance.titleTextColor,
                                           .font: appearance.subtitleTextFont]))
        }
        instructionLbl.attributedText = attr
    }
}
