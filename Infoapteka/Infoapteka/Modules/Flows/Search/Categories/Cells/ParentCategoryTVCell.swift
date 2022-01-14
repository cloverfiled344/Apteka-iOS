//
//  ParentCategoryTVCell.swift
//  Infoapteka
//
//

import UIKit

extension ParentCategoryTVCell {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color
        let accessoryType: UITableViewCell.AccessoryType = .none
        let selectionStyle: UITableViewCell.SelectionStyle = .none

        let centerViewBackgroundColor: UIColor = Asset.mainWhite.color
        let centerViewCornerRadius: CGFloat = 12.0
        let centerViewMasksToBounds: Bool = true
        let centerViewHeight: CGFloat = 44.0
        let centerViewTopBottomMargin: CGFloat = 4.0
        let centerViewLeftRightMargin: CGFloat = 8.0

        let titleLblLeftRightMargin: CGFloat = 24.0
        let titleLblTopMargin: CGFloat = 20.0
        let titleLblBottomMargin: CGFloat = 8.0
        let titleLblColor: UIColor = Asset.mainBlack.color
        let titleLblFont: UIFont = FontFamily.Inter.semiBold.font(size: 16)
    }
}

class ParentCategoryTVCell: UITableViewCell {

    private lazy var titleLbl: UILabel = {
        let view = UILabel()
        view.textColor = appearance.titleLblColor
        view.font = appearance.titleLblFont
        view.numberOfLines = 2
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
            make.top.equalTo(contentView.snp.top).offset(appearance.titleLblTopMargin)
            make.bottom.equalTo(contentView.snp.bottom).offset(-appearance.titleLblBottomMargin)
        }
    }

    func setTitle(_ title: String) {
        self.titleLbl.text = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
