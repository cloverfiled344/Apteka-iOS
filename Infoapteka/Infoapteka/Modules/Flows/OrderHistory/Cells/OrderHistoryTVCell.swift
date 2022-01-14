//
//  OrderHistoryTVCell.swift
//  Infoapteka
//
//

import UIKit

extension OrderHistoryTVCell {
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

class OrderHistoryTVCell: UITableViewCell {

    lazy private var iconIV: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds  = appearance.icArrowIVClipsToBounds
        view.contentMode    = appearance.icArrowIVContentMode
        return view
    }()

    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.font = FontFamily.Inter.regular.font(size: 13.0)
        view.textColor = Asset.mainBlack.color
        return view
    }()

    lazy private var infoLbl: UILabel = {
        let view = UILabel()
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8.0

        let infoLblAttributedText = NSMutableAttributedString(string: "Цена:",
                                                              attributes: [.font: FontFamily.Inter.regular.font(size: 13.0),
                                                                           .foregroundColor: Asset.secondaryGray.color,
                                                                           .paragraphStyle: paragraphStyle])
        infoLblAttributedText.append(.init(string: "\nКоличество:",
                                           attributes: [.font: FontFamily.Inter.medium.font(size: 13.0),
                                                        .foregroundColor: Asset.secondaryGray.color,
                                                        .paragraphStyle: paragraphStyle]))
        view.attributedText = infoLblAttributedText
        return view
    }()

    lazy private var valueLbl: UILabel = {
        let view = UILabel()
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        view.textAlignment = .right
        return view
    }()

    private var appearance = Appearance()
    private var order: Order? {
        didSet {
            guard let order = order else { return }

            iconIV.load(order.drug?.image ?? "", Asset.icDefaultDrug.image)
            titleLbl.text = order.drug?.name ?? ""

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 8.0
            paragraphStyle.alignment = .right

            let titleLblAttributedText = NSMutableAttributedString(string: "\(order.drug?.price ?? 0)  c",
                                                                   attributes: [.font: FontFamily.Inter.medium.font(size: 13.0),
                                                                                .foregroundColor: Asset.mainBlack.color,
                                                                                .paragraphStyle: paragraphStyle])
            titleLblAttributedText.append(.init(string: "\n\(order.quantity ?? 0)",
                                                attributes: [.font: FontFamily.Inter.medium.font(size: 13.0),
                                                             .foregroundColor: Asset.secondaryGray3.color,
                                                             .paragraphStyle: paragraphStyle]))
            valueLbl.attributedText = titleLblAttributedText
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .white
        separatorInset = .init(top: 0, left: 1000, bottom: 0, right: 0)

        addSubview(iconIV)
        iconIV.snp.makeConstraints { make in
            make.left.equalTo(20.0)
            make.top.equalTo(14.0)
            make.width.height.equalTo(100.0)
            make.bottom.lessThanOrEqualTo(-16.0)
        }

        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalTo(iconIV.snp.right).offset(12.0)
            make.right.equalTo(snp.right).offset(-12.0)
            make.top.equalTo(iconIV.snp.top)
        }

        addSubview(infoLbl)
        infoLbl.snp.remakeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(16.0)
            make.left.equalTo(iconIV.snp.right).offset(12.0)
            make.right.equalTo(titleLbl.snp.centerX).offset(-4.0)
            make.bottom.lessThanOrEqualTo(-16.0)
        }

        addSubview(valueLbl)
        valueLbl.snp.remakeConstraints { make in
            make.left.equalTo(titleLbl.snp.centerX).offset(4.0)
            make.right.equalTo(snp.right).offset(-12.0)
            make.top.equalTo(infoLbl.snp.top)
            make.bottom.equalTo(infoLbl.snp.bottom)
        }
    }

    func setup(_ order: Order?) {
        self.order = order
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
