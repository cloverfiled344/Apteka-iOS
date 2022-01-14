//
//  SeeAllTVCell.swift
//  Infoapteka
//
//

import UIKit

extension SeeAllTVCell {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color
        let accessoryType            : UITableViewCell.AccessoryType = .none
        let selectionStyle           : UITableViewCell.SelectionStyle = .none

        let titleLblText            : String = L10n.seeAll
        let titleLblLeftRightMargin : CGFloat = 24.0
        let titleLblColor           : UIColor = Asset.secondaryGray3.color
        let titleLblFont            : UIFont = FontFamily.Inter.regular.font(size: 14)
        let titleLblTopBottomMargin : CGFloat = 4.0
        let titleLblHeigth          : CGFloat = 36.0
    }
}

class SeeAllTVCell: UITableViewCell {

    private lazy var titleLbl: UILabel = {
        let view = UILabel()
        view.textColor = appearance.titleLblColor
        view.font = appearance.titleLblFont
        view.text = appearance.titleLblText
        return view
    }()

    private let appearance = Appearance()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = appearance.backgroundColor
        selectionStyle  = appearance.selectionStyle
        accessoryType   = appearance.accessoryType

        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(appearance.titleLblLeftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.titleLblLeftRightMargin)
            make.top.equalTo(contentView.snp.top).offset(appearance.titleLblTopBottomMargin)
            make.bottom.equalTo(contentView.snp.bottom).offset(-appearance.titleLblTopBottomMargin)
            make.height.equalTo(appearance.titleLblHeigth)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
