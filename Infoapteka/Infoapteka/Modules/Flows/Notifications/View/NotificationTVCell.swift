//
//  NotificationTVCell.swift
//  Infoapteka
//
//

import UIKit

extension NotificationTVCell {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color
        let separatorInset : UIEdgeInsets = .init(top: 0, left: 20.0, bottom: 0, right: 20.0)

        let titleFont : UIFont = FontFamily.Inter.semiBold.font(size: 14.0)
        let titleColor: UIColor = Asset.gray.color

        let subtitleFont : UIFont = FontFamily.Inter.medium.font(size: 12.0)
        let subtitleColor: UIColor = Asset.grayLight.color
    }
}

class NotificationTVCell: UITableViewCell {

    private let iconIV: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    private let titleLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 3
        return view
    }()

    private var notif: Notif? {
        didSet {
            guard let notif = notif else { return }

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6

            if let title = notif.body?.title {
                let titleLblAttributedText = NSMutableAttributedString(
                    string: title,
                    attributes: [.font: appearance.titleFont,
                                 .foregroundColor: appearance.titleColor,
                                 .paragraphStyle: paragraphStyle])

                if let subtitle = notif.createdAt {
                    titleLblAttributedText.append(.init(string: "\n\(subtitle)",
                                                        attributes: [.font: appearance.subtitleFont,
                                                                     .foregroundColor: appearance.subtitleColor,
                                                                     .paragraphStyle: paragraphStyle]))
                }
                self.titleLbl.attributedText = titleLblAttributedText
            }

            iconIV.image = notif.icon ?? .init()
            backgroundColor = notif.statusColor ?? Asset.notifIsViewed.color
        }
    }

    private let appearance = Appearance()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = appearance.backgroundColor
        separatorInset = appearance.separatorInset

        contentView.addSubview(iconIV)
        iconIV.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView.snp.left).offset(20.0)
            maker.top.equalTo(contentView.snp.top).offset(16.0)
            maker.height.width.equalTo(20.0)
        }

        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (maker) in
            maker.top.equalTo(iconIV.snp.top)
            maker.left.equalTo(iconIV.snp.right).offset(20.0)
            maker.right.equalTo(contentView.snp.right).offset(-20.0)
            maker.bottom.lessThanOrEqualTo(contentView.snp.bottom).offset(-16.0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setNotif(_ notif: Notif?) {
        self.notif = notif
    }
}
