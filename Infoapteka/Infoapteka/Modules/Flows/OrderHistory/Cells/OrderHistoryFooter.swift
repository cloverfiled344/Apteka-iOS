//
//  OrderHistoryFooter.swift
//  Infoapteka
//
//

import UIKit

protocol OrderHistoryFooterDelegate {
    func didTappedMoreDetailsBtn(_ orderHistoryID: Int)
}

// MARK: -- Appearance
extension OrderHistoryFooter {
    struct Appearance {
        let backgroundColor          : UIColor = Asset.secondaryWhite.color
        let centerViewBackgroundColor: UIColor = Asset.mainWhite.color

        let centerViewCornerRadius: CGFloat = 16.0
        let centerViewBorderWidth : CGFloat = 1.0
        let centerViewBorderColor : CGColor = Asset.secondaryLight.color.cgColor
        let centerViewTopBottomMargin: CGFloat = 16.0
        let centerViewLeftRightMargin: CGFloat = 20.0

        let lineHeightMultiple: CGFloat = 2.0
    }
}

class OrderHistoryFooter: UITableViewHeaderFooterView {

    private let cornerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy private var centerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius  = appearance.centerViewCornerRadius
        view.layer.borderWidth   = appearance.centerViewBorderWidth
        view.layer.borderColor   = appearance.centerViewBorderColor
        view.backgroundColor     = appearance.centerViewBackgroundColor
        return view
    }()

    lazy private var infoLbl: UILabel = {
        let view = UILabel()
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = appearance.lineHeightMultiple
        let infoLblAttributedText = NSMutableAttributedString(string: "Итого",
                                                              attributes: [.font: FontFamily.Inter.bold.font(size: 20),
                                                                           .foregroundColor: Asset.mainBlack.color])
        infoLblAttributedText.append(.init(string: "\nСтатус заказа:",
                                           attributes: [.font: FontFamily.Inter.regular.font(size: 13.0),
                                                        .foregroundColor: Asset.secondaryGray.color,
                                                        .paragraphStyle: paragraphStyle]))
        infoLblAttributedText.append(.init(string: "\nОбщее количество товаров:",
                                           attributes: [.font: FontFamily.Inter.regular.font(size: 13.0),
                                                        .foregroundColor: Asset.secondaryGray.color,
                                                        .paragraphStyle: paragraphStyle]))
        infoLblAttributedText.append(.init(string: "\nОбщая сумма:",
                                           attributes: [.font: FontFamily.Inter.regular.font(size: 13.0),
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

    lazy private var moreDetailsBtn: UIButton = {
        let view = UIButton()
        view.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 13.0)
        view.layer.cornerRadius = 12.0
        view.titleLabel?.font = FontFamily.Inter.regular.font(size: 14.0)
        view.addTarget(self, action: #selector(didTappedOrderBtn), for: .touchUpInside)
        return view
    }()

    private var appearance = Appearance()
    private var orderHistory: OrderHistory? {
        didSet {
            guard let orderHistory = orderHistory else { return }
            setValueLblValue(orderHistory)

            moreDetailsBtn.setTitleColor(
                orderHistory.isExpanded ? Asset.darkBlue.color : Asset.mainWhite.color,for: .normal)
            moreDetailsBtn.setTitle(
                orderHistory.isExpanded ? "Свернуть" : "Подробнее", for: .normal)
            moreDetailsBtn.backgroundColor = orderHistory.isExpanded ? Asset.mainWhite.color : Asset.mainGreen.color
            moreDetailsBtn.layer.borderColor = orderHistory.isExpanded ? Asset.darkBlue.color.cgColor : Asset.mainGreen.color.cgColor
            moreDetailsBtn.layer.borderWidth = 1
            moreDetailsBtn.setImage(orderHistory.isExpanded ? Asset.icExpanded.image : Asset.icShorten.image, for: .normal)

            remakeConstraints()
        }
    }
    var delegate: OrderHistoryFooterDelegate?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        backgroundColor = appearance.backgroundColor

        contentView.addSubview(cornerView)
        cornerView.layer.cornerRadius = 16.0
        cornerView.layer.masksToBounds = true
        cornerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        contentView.addSubview(centerView)
        contentView.addSubview(infoLbl)
        contentView.addSubview(valueLbl)
        contentView.addSubview(moreDetailsBtn)
    }

    fileprivate func remakeConstraints() {
        cornerView.snp.remakeConstraints { make in
            make.top.left.right.equalTo(contentView)
            make.bottom.equalTo(contentView.snp.bottom).offset(-4.0)
        }

        centerView.snp.remakeConstraints { make in
            make.top.equalTo(cornerView.snp.top).offset(appearance.centerViewTopBottomMargin)
            make.bottom.equalTo(cornerView.snp.bottom).offset(-appearance.centerViewTopBottomMargin)
            make.left.equalTo(cornerView.snp.left).offset(appearance.centerViewLeftRightMargin)
            make.right.equalTo(cornerView.snp.right).offset(-appearance.centerViewLeftRightMargin)
        }

        infoLbl.snp.remakeConstraints { make in
            make.left.equalTo(centerView.snp.left).offset(16.0)
            make.top.equalTo(centerView.snp.top).offset(20.0)
            make.right.equalTo(centerView.snp.right).offset(-108.0)
        }

        valueLbl.snp.remakeConstraints { make in
            make.right.equalTo(centerView.snp.right).offset(-16.0)
            make.top.equalTo(centerView.snp.top).offset(20.0)
            make.bottom.equalTo(infoLbl.snp.bottom)
            make.width.equalTo(76.0)
        }

        moreDetailsBtn.snp.remakeConstraints { make in
            make.top.equalTo(infoLbl.snp.bottom).offset(16.0)
            make.left.equalTo(centerView.snp.left).offset(16.0)
            make.right.equalTo(centerView.snp.right).offset(-16.0)
            make.height.equalTo(46.0)
            make.bottom.equalTo(centerView.snp.bottom).offset(-20.0)
        }
    }

    func setup(_ orderHistory: OrderHistory?) {
        self.orderHistory = orderHistory
    }

    private func setValueLblValue(_ orderHistory: OrderHistory) {
        let generalParagraphStyle = NSMutableParagraphStyle()
        generalParagraphStyle.lineHeightMultiple = 1.6
        generalParagraphStyle.alignment = .right

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = appearance.lineHeightMultiple
        paragraphStyle.alignment = .right
        let valueLblAttributedText = NSMutableAttributedString(string: " ",
                                                               attributes: [.font: FontFamily.Inter.regular.font(size: 13),
                                                                            .foregroundColor: Asset.mainBlue.color,
                                                                            .paragraphStyle: generalParagraphStyle])
        valueLblAttributedText.append(.init(string:  "\n\(orderHistory.status?.title ?? "")",
                                            attributes: [.font: FontFamily.Inter.regular.font(size: 13.0),
                                                         .foregroundColor: orderHistory.status?.color ?? .clear,
                                                         .paragraphStyle: paragraphStyle]))
        valueLblAttributedText.append(.init(string:  "\n\(orderHistory.ordersCount ?? 0)",
                                            attributes: [.font: FontFamily.Inter.regular.font(size: 13.0),
                                                         .foregroundColor: Asset.mainBlack.color,
                                                         .paragraphStyle: paragraphStyle]))
        valueLblAttributedText.append(.init(string: "\n\(orderHistory.ordersPrice ?? 0) сом",
                                            attributes: [.font: FontFamily.Inter.regular.font(size: 13.0),
                                                         .foregroundColor: Asset.mainBlack.color,
                                                         .paragraphStyle: paragraphStyle]))
        valueLbl.attributedText = valueLblAttributedText
    }

    @objc private func didTappedOrderBtn() {
        moreDetailsBtn.pulsate()
        guard let orderHistoryID = orderHistory?.id else { return }
        delegate?.didTappedMoreDetailsBtn(orderHistoryID)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
