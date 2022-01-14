//
//  OwnerProfileInfoView.swift
//  Infoapteka
//
//

import UIKit

extension OwnerProfileInfoView {
    struct Appearance {
        let backgroundColor : UIColor = Asset.mainWhite.color
        let cornerRadius    : CGFloat = 12.0

        let titleLblFont    : UIFont = FontFamily.Inter.regular.font(size: 13)
        let titleLblColor   : UIColor = Asset.secondaryGray.color
        let titleLblLeftRightMargin : CGFloat = 16.0
        let titleLblTopMargin       : CGFloat = 12.0

        let icArrowIVContentMode    : UIImageView.ContentMode = .scaleAspectFit
        let icArrowIVClipsToBounds  : Bool = true
        let icActiveGridImage   : UIImage = Asset.icActiveGrid.image
        let icNotActiveGridImage: UIImage = Asset.icActiveGrid.image.withTintColor(Asset.secondaryGray.color)
    }
}

class OwnerProfileInfoView: UITableViewCell {

    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()

    lazy private var iconIV: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds  = appearance.icArrowIVClipsToBounds
        view.contentMode    = appearance.icArrowIVContentMode
        return view
    }()

    private var appearance = Appearance()
    private var profile: Profile? {
        didSet {
            guard let profile = profile else { return }
            iconIV.load(profile.avatar ?? "", Asset.icAvatarPlaceholder.image)

            let titleParagraphStyle = NSMutableParagraphStyle()
            titleParagraphStyle.lineSpacing = 8.0

            let subtitleParagraphStyle = NSMutableParagraphStyle()
            subtitleParagraphStyle.lineSpacing = 4.0

            let titleLblAttributedText = NSMutableAttributedString(string: profile.firstName ?? "",
                                                                   attributes: [.font: FontFamily.Inter.bold.font(size: 15.0),
                                                                                .foregroundColor: Asset.mainBlack.color,
                                                                                .paragraphStyle: titleParagraphStyle])
            titleLblAttributedText.append(.init(string: "\nТелефон",
                                                attributes: [.font: FontFamily.Inter.semiBold.font(size: 11.0),
                                                             .foregroundColor: Asset.secondaryGray3.color,
                                                             .paragraphStyle: subtitleParagraphStyle]))
            titleLblAttributedText.append(.init(string: "\n\(profile.phoneNumber ?? "")",
                                                attributes: [.font: FontFamily.Inter.regular.font(size: 13.0),
                                                             .foregroundColor: Asset.mainBlack.color,
                                                             .paragraphStyle: titleParagraphStyle]))
            titleLblAttributedText.append(.init(string: "\nАдрес",
                                                attributes: [.font: FontFamily.Inter.semiBold.font(size: 11.0),
                                                             .foregroundColor: Asset.secondaryGray.color,
                                                             .paragraphStyle: subtitleParagraphStyle]))
            titleLblAttributedText.append(.init(string: "\n\(profile.address ?? "")",
                                                attributes: [.font: FontFamily.Inter.regular.font(size: 13.0),
                                                             .foregroundColor: Asset.mainBlack.color]))
            titleLbl.attributedText = titleLblAttributedText
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .white
        layer.cornerRadius = 16.0
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        addSubview(iconIV)
        iconIV.snp.makeConstraints { make in
            make.left.top.equalTo(20.0)
            make.width.height.equalTo(92.0)
        }

        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalTo(iconIV.snp.right).offset(16.0)
            make.right.equalTo(snp.right).offset(-16.0)
            make.top.equalTo(iconIV.snp.top)
            make.bottom.lessThanOrEqualTo(snp.bottom).offset(20.0)
        }
    }

    func setup(_ profile: Profile?) {
        self.profile = profile
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
