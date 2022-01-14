//
//  CabinetTVCell.swift
//  Infoapteka
//
//

import UIKit

extension CabinetTVCell {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color

        let iconIVContentMode: UIView.ContentMode = .scaleAspectFit
        let iconIVClipsToBounds: Bool = true
        let iconIVWidth: CGFloat = 20.0
        let iconIVLeftMargin: CGFloat = 20.0
        let iconIVTopBottomMargin: CGFloat = 12.0

        let titleLblColor: UIColor = Asset.mainBlack.color
        let titleLblFont: UIFont = FontFamily.Inter.regular.font(size: 15)
        let titleLblLeftRightMargin: CGFloat = 16.0

        let moderationNotPassColor: UIColor = Asset.mainRed.color
        let moderationColor: UIColor = Asset.orange.color
        let moderationPassColor: UIColor = Asset.mainGreen.color

        let signOutColor: UIColor = Asset.mainRed.color
    }
}

class CabinetTVCell: UITableViewCell {

    //MARK: -- UI Properties
    lazy private var iconIV: UIImageView = {
        let view = UIImageView()
        view.contentMode = appearance.iconIVContentMode
        view.clipsToBounds = appearance.iconIVClipsToBounds
        return view
    }()

    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.sizeToFit()
        return view
    }()

    //MARK: -- properties
    private var appearance = Appearance()

    //MARK: -- init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .gray

        self.contentView.addSubview(self.iconIV)
        self.contentView.addSubview(self.titleLbl)
    }

    //MARK: -- making constraints
    override func layoutSubviews() {
        super.layoutSubviews()

        self.iconIV.snp.remakeConstraints { make in
            make.left.equalTo(appearance.iconIVLeftMargin)
            make.top.equalTo(appearance.iconIVTopBottomMargin)
            make.bottom.equalTo(-appearance.iconIVTopBottomMargin)
            make.width.height.equalTo(appearance.iconIVWidth)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }

        self.titleLbl.snp.remakeConstraints { make in
            make.left.equalTo(self.iconIV.snp.right).offset(appearance.titleLblLeftRightMargin)
            make.right.equalTo(self.contentView.snp.right).offset(-appearance.titleLblLeftRightMargin)
            make.centerY.equalTo(self.iconIV.snp.centerY)
        }
    }

    //MARK: -- public methods
    func setMenuItem(_ menuItem: MenuItem?) {
        self.iconIV.image = menuItem?.icon ?? .init()
        guard let type = menuItem?.type else { return }
        switch type {
        case .profile, .myGoods,
             .historyOfOrders, .aboutCompany,
             .help, .programRules, .signIn:
            self.makeTitleLblAttributedText(menuItem)
        case .signOut:
            self.titleLbl.text = menuItem?.type.rawValue
            self.titleLbl.textColor = appearance.signOutColor
            self.titleLbl.font = appearance.titleLblFont
        }
    }

    fileprivate func makeTitleLblAttributedText(_ menuItem: MenuItem?) {
        let attributedText = NSMutableAttributedString(string: menuItem?.type.rawValue ?? "",
                                                       attributes: [.font: appearance.titleLblFont,
                                                                    .foregroundColor : appearance.titleLblColor])
        if let moderationStatus = menuItem?.moderationStatus {
            attributedText.append(.init(string: " - ",
                                        attributes: [.font: appearance.titleLblFont,
                                                     .foregroundColor : appearance.titleLblColor]))

            let foregroundColor: UIColor = self.getModerationStatusColor(moderationStatus)
            attributedText.append(.init(string: menuItem?.moderationStatus?.title ?? "",
                                        attributes: [.font: appearance.titleLblFont,
                                                     .foregroundColor : foregroundColor]))
        }
        self.titleLbl.attributedText = attributedText
        if menuItem?.type == .signOut {
            self.titleLbl.textColor = appearance.signOutColor
        }
    }

    fileprivate func getModerationStatusColor(_ moderationStatus: ModerationStatus) -> UIColor {
        switch moderationStatus {
        case .rejected:
            return appearance.moderationNotPassColor
        case .waiting:
            return appearance.moderationColor
        case .activated:
            return appearance.moderationPassColor
        }
    }

    //MARK: -- deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
