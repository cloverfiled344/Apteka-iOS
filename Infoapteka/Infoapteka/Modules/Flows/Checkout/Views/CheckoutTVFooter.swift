//
//  CheckoutTVHeader.swift
//  Infoapteka
//
//

import UIKit

protocol CheckoutTVFooterDelegate {
    func didTappedOrderBtn()
    func didTappedOnPrivacyPolicyBtn()
}

// MARK: -- Appearance
extension CheckoutTVFooter {
    struct Appearance {
        let backgroundColor          : UIColor = Asset.mainWhite.color
        let centerViewBackgroundColor: UIColor = Asset.mainWhite.color

        let centerViewCornerRadius: CGFloat = 16.0
        let centerViewBorderWidth : CGFloat = 1.0
        let centerViewBorderColor : CGColor = Asset.secondaryLight.color.cgColor
        let centerViewTopBottomMargin: CGFloat = 4.0
        let centerViewLeftRightMargin: CGFloat = 20.0

        let lineHeightMultiple: CGFloat = 2.0
    }
}

class CheckoutTVFooter: UITableViewHeaderFooterView {

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
        infoLblAttributedText.append(.init(string: "\nТоваров в корзине:",
                                           attributes: [.font: FontFamily.Inter.regular.font(size: 14),
                                                        .foregroundColor: Asset.secondaryGray.color,
                                                        .paragraphStyle: paragraphStyle]))
        infoLblAttributedText.append(.init(string: "\nСтоимость доставки:",
                                           attributes: [.font: FontFamily.Inter.regular.font(size: 14),
                                                        .foregroundColor: Asset.secondaryGray.color,
                                                        .paragraphStyle: paragraphStyle]))
        infoLblAttributedText.append(.init(string: "\nОбщая сумма:",
                                           attributes: [.font: FontFamily.Inter.regular.font(size: 14),
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

    lazy private var orderBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = Asset.mainGreen.color
        view.layer.cornerRadius = 12.0
        view.titleLabel?.font = FontFamily.Inter.regular.font(size: 14)
        view.setTitleColor(Asset.mainWhite.color, for: .normal)
        view.setTitle("Заказать", for: .normal)
        view.addTarget(self, action: #selector(didTappedOrderBtn), for: .touchUpInside)
        return view
    }()

    lazy private var delivaryRulesBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = Asset.mainWhite.color
        view.layer.cornerRadius = 12.0
        view.titleLabel?.font = FontFamily.Inter.regular.font(size: 14)
        view.setTitleColor(Asset.mainBlue.color, for: .normal)
        view.setTitle("Условия доставки", for: .normal)
        view.addTarget(self, action: #selector(didTappedDelivaryRulesBtn), for: .touchUpInside)
        return view
    }()

    private var appearance = Appearance()
    private var basket: Basket? {
        didSet {
            guard let basket = basket else { return }
            setValueLblValue(basket)
        }
    }
    private var orderHistory: OrderHistory? {
        didSet {
            guard let orderHistory = orderHistory else { return }
            var basket = Basket(JSON: [:])
            basket?.totalCart = orderHistory.ordersPrice ?? 0
            basket?.totalCartItems = orderHistory.ordersCount ?? 0
            guard let basket = basket else { return }
            setValueLblValue(basket)
        }
    }
    var delegate: CheckoutTVFooterDelegate?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        backgroundColor = appearance.backgroundColor
        contentView.backgroundColor = appearance.backgroundColor

        contentView.addSubview(centerView)
        centerView.addSubview(infoLbl)
        centerView.addSubview(valueLbl)
        centerView.addSubview(orderBtn)
        centerView.addSubview(delivaryRulesBtn)

        centerView.snp.remakeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(appearance.centerViewTopBottomMargin)
            make.bottom.equalTo(contentView.snp.bottom).offset(-appearance.centerViewTopBottomMargin)
            make.left.equalTo(contentView.snp.left).offset(appearance.centerViewLeftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.centerViewLeftRightMargin)
        }

        infoLbl.snp.remakeConstraints { make in
            make.left.equalTo(centerView.snp.left).offset(16.0)
            make.top.equalTo(centerView.snp.top).offset(20.0)
            make.right.equalTo(centerView.snp.centerX).offset(-8.0)
        }

        valueLbl.snp.remakeConstraints { make in
            make.right.equalTo(centerView.snp.right).offset(-16.0)
            make.top.equalTo(centerView.snp.top).offset(20.0)
            make.bottom.equalTo(infoLbl.snp.bottom)
            make.left.equalTo(centerView.snp.centerX).offset(8.0)
        }

        orderBtn.snp.makeConstraints { make in
            make.top.equalTo(infoLbl.snp.bottom).offset(16.0)
            make.left.equalTo(centerView.snp.left).offset(16.0)
            make.right.equalTo(centerView.snp.right).offset(-16.0)
            make.height.equalTo(46.0)
        }

        delivaryRulesBtn.snp.makeConstraints { make in
            make.top.equalTo(orderBtn.snp.bottom).offset(8.0)
            make.left.equalTo(centerView.snp.left).offset(16.0)
            make.right.equalTo(centerView.snp.right).offset(-16.0)
            make.height.equalTo(46.0)
            make.bottom.lessThanOrEqualTo(centerView.snp.bottom).offset(-20.0)
        }
    }

    func setup(_ basket: Basket?) {
        self.basket = basket
    }

    func setup(_ orderHistory: OrderHistory?) {
        self.orderHistory = orderHistory
    }

    private func setValueLblValue(_ basket: Basket) {
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
        valueLblAttributedText.append(.init(string:  "\n\(basket.totalCartItems ?? 0)",
                                            attributes: [.font: FontFamily.Inter.regular.font(size: 14),
                                                         .foregroundColor: Asset.mainBlack.color,
                                                         .paragraphStyle: paragraphStyle]))
        valueLblAttributedText.append(.init(string:  "\n40 с",
                                            attributes: [.font: FontFamily.Inter.regular.font(size: 14),
                                                         .foregroundColor: Asset.mainBlack.color,
                                                         .paragraphStyle: paragraphStyle]))
        valueLblAttributedText.append(.init(string: "\n\(basket.totalCart ?? 0) сом",
                                            attributes: [.font: FontFamily.Inter.regular.font(size: 14),
                                                         .foregroundColor: Asset.mainBlack.color,
                                                         .paragraphStyle: paragraphStyle]))
        valueLbl.attributedText = valueLblAttributedText
    }

    @objc private func didTappedOrderBtn() {
        orderBtn.pulsate()
        endEditing(true)
        delegate?.didTappedOrderBtn()
    }

    @objc private func didTappedDelivaryRulesBtn() {
        delivaryRulesBtn.pulsate()
        delegate?.didTappedOnPrivacyPolicyBtn()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
