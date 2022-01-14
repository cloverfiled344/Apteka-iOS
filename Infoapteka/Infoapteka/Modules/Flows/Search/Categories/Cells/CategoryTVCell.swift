//
//  CategoryTVCell.swift
//  Infoapteka
//
//

import UIKit

extension CategoryTVCell {
    struct Appearance {
        let backgroundColor : UIColor = Asset.mainWhite.color
        let accessoryType   :  UITableViewCell.AccessoryType = .none
        let selectionStyle  : UITableViewCell.SelectionStyle = .none

        let centerViewBackgroundColor   : UIColor = Asset.mainWhite.color
        let centerViewCornerRadius      : CGFloat = 12.0
        let centerViewMasksToBounds     : Bool = true
        let centerViewHeight            : CGFloat = 44.0
        let centerViewTopBottomMargin   : CGFloat = 4.0
        let centerViewLeftRightMargin   : CGFloat = 8.0

        let icArrowRightImage           : UIImage = Asset.icArrowRight.image
        let icArrowRightIVContentMode   : UIImageView.ContentMode = .scaleAspectFit
        let icArrowRightIVClipsToBounds : Bool = true
        let icArrowRightIVRightMargin   : CGFloat = 12.0
        let icArrowRightIVWidth         : CGFloat = 24.0

        let logoIVContentMode       : UIImageView.ContentMode = .scaleAspectFit
        let logoIVClipsToBounds     : Bool = true
        let logoIVWidth             : CGFloat = 24.0
        let logoIVLeftMargin        : CGFloat = 16.0
        let logoIVBackgroundColor   : UIColor = Asset.mainWhite.color

        let titleLblLeftRightMargin : CGFloat = 16.0
        let titleLblColor           : UIColor = Asset.mainBlack.color
        let titleLblFont            : UIFont = FontFamily.Inter.regular.font(size: 14)
    }
}

class CategoryTVCell: UITableViewCell {

    private lazy var centerView: UIView = {
        let view = UIView()
        view.backgroundColor     = appearance.centerViewBackgroundColor
        view.layer.masksToBounds = appearance.centerViewMasksToBounds
        view.layer.cornerRadius  = appearance.centerViewCornerRadius
        return view
    }()

    private lazy var icArrowRightIV: UIImageView = {
        let view = UIImageView()
        view.image          = appearance.icArrowRightImage
        view.clipsToBounds  = appearance.icArrowRightIVClipsToBounds
        view.contentMode    = appearance.icArrowRightIVContentMode
        return view
    }()

    private lazy var titleLbl: UILabel = {
        let view = UILabel()
        view.textColor  = appearance.titleLblColor
        view.font       = appearance.titleLblFont
        view.numberOfLines = 2
        return view
    }()

    private lazy var logoIV: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = appearance.logoIVBackgroundColor
        view.clipsToBounds  = appearance.logoIVClipsToBounds
        view.contentMode    = appearance.logoIVContentMode
        return view
    }()

    private let appearance = Appearance()

    var category: Category? {
        didSet {
            guard let category = category else { return }
            titleLbl.text        = category.title
            icArrowRightIV.alpha = category.children.isEmpty ? 0 : 1
            configureLogoIV(category)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = appearance.backgroundColor
        selectionStyle  = appearance.selectionStyle
        accessoryType   = appearance.accessoryType

        contentView.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(appearance.centerViewLeftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.centerViewLeftRightMargin)
            make.top.equalTo(contentView.snp.top).offset(appearance.centerViewTopBottomMargin)
            make.bottom.equalTo(contentView.snp.bottom).offset(-appearance.centerViewTopBottomMargin)
            make.height.equalTo(appearance.centerViewHeight)
        }

        centerView.addSubview(icArrowRightIV)
        icArrowRightIV.snp.makeConstraints { make in
            make.right.equalTo(centerView.snp.right).offset(-appearance.icArrowRightIVRightMargin)
            make.height.width.equalTo(appearance.icArrowRightIVWidth)
            make.centerY.equalTo(centerView.snp.centerY)
        }

        centerView.addSubview(logoIV)
        centerView.addSubview(titleLbl)
    }

    private func configureLogoIV(_ category: Category) {
        guard let logoUrlStr = category.logo, !logoUrlStr.isEmpty else {
            configureTitleLbl()
            return
        }
        logoIV.load(logoUrlStr, .init())
        logoIV.snp.remakeConstraints { make in
            make.left.equalTo(centerView.snp.left).offset(appearance.logoIVLeftMargin)
            make.height.width.equalTo(appearance.logoIVWidth)
            make.centerY.equalTo(centerView.snp.centerY)
        }
        configureTitleLbl(true)
    }

    private func configureTitleLbl(_ isHaveLogo: Bool = false) {
        titleLbl.snp.remakeConstraints { make in
            make.left.equalTo(isHaveLogo ? logoIV.snp.right : centerView.snp.left).offset(appearance.titleLblLeftRightMargin)
            make.right.equalTo(icArrowRightIV.snp.left).offset(-appearance.titleLblLeftRightMargin)
            make.centerY.equalTo(centerView.snp.centerY)
        }
    }

    func setCategory(_ category: Category) {
        self.category = category
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        centerView.backgroundColor = highlighted ? Asset.backgroundGray.color : appearance.centerViewBackgroundColor
        logoIV.backgroundColor = highlighted ? Asset.backgroundGray.color : appearance.centerViewBackgroundColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
