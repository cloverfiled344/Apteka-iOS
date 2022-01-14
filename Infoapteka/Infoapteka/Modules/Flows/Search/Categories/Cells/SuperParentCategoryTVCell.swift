//
//  SuperParentCategoryCell.swift
//  Infoapteka
//
//

import UIKit

extension SuperParentCategoryTVCell {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color
        let accessoryType: UITableViewCell.AccessoryType = .none
        let selectionStyle: UITableViewCell.SelectionStyle = .none

        let icArrowLeftImage: UIImage = Asset.icArrowLeft.image
        let icArrowLeftIVContentMode: UIImageView.ContentMode = .scaleAspectFit
        let icArrowLeftIVClipsToBounds: Bool = true
        let icArrowLeftIVLeftMargin: CGFloat = 16.0
        let icArrowLeftIVWidth: CGFloat = 24.0

        let titleLblLeftRightMargin: CGFloat = 10.0
        let titleLblColor: UIColor = Asset.gray2.color
        let titleLblFont: UIFont = FontFamily.Inter.regular.font(size: 15)
        let titleLblTopMargin: CGFloat = 8.0
        let titleLblTopHeigth: CGFloat = 23.0
        let titleLblBottomMargin: CGFloat = 13.0

        let bottomLineViewLeftMargin: CGFloat = 8.0
        let bottomLineViewRightMargin: CGFloat = 62.0
        let bottomLineViewHeight: CGFloat = 1.0
        let bottomLineViewBackgroundColor: UIColor = Asset.backgroundGray.color
    }
}

class SuperParentCategoryTVCell: UITableViewCell {

    private lazy var titleLbl: UILabel = {
        let view = UILabel()
        view.textColor = appearance.titleLblColor
        view.font = appearance.titleLblFont
        view.numberOfLines = 2
        return view
    }()

    private lazy var icArrowLeftIV: UIImageView = {
        let view = UIImageView()
        view.image = appearance.icArrowLeftImage
        view.clipsToBounds = appearance.icArrowLeftIVClipsToBounds
        view.contentMode = appearance.icArrowLeftIVContentMode
        return view
    }()

    private lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.bottomLineViewBackgroundColor
        return view
    }()

    private let appearance = Appearance()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = appearance.backgroundColor
        contentView.backgroundColor = appearance.backgroundColor

        contentView.addSubview(icArrowLeftIV)
        icArrowLeftIV.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(appearance.icArrowLeftIVLeftMargin)
            make.height.width.equalTo(appearance.icArrowLeftIVWidth)
            make.centerY.equalTo(contentView.snp.centerY)
        }

        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(appearance.titleLblTopMargin)
            make.bottom.equalTo(contentView.snp.bottom).offset(-appearance.titleLblBottomMargin)
            make.left.equalTo(icArrowLeftIV.snp.right).offset(appearance.titleLblLeftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.titleLblLeftRightMargin)
            make.height.equalTo(appearance.titleLblTopHeigth)
        }

        contentView.addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(appearance.bottomLineViewLeftMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.bottomLineViewRightMargin)
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(appearance.bottomLineViewHeight)
        }
    }

    func setTitle(_ title: String) {
        titleLbl.text = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
