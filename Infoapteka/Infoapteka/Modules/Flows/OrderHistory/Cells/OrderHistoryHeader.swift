//
//  OrderHistoryHeader.swift
//  Infoapteka
//
//

import UIKit

protocol OrderHistoryHeaderDelegate {
    func didTappedPayBtn(_ orderHistory: OrderHistory)
}

extension OrderHistoryHeader {
    struct Appearance {
        let backgroundColor: UIColor = Asset.secondaryWhite.color
    }
}

class OrderHistoryHeader: UITableViewHeaderFooterView {

    private let cornerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let titleLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        return view
    }()

    private let payBtn: UIButton = {
        let view = UIButton()
        view.setTitle("Оплатить", for: .normal)
        view.setTitleColor(Asset.mainWhite.color, for: .normal)
        view.backgroundColor = Asset.mainGreen.color
        view.titleLabel?.font = FontFamily.Inter.medium.font(size: 14.0)
        view.contentEdgeInsets = .init(top: 8.0, left: 21.0, bottom: 8.0, right: 21.0)
        view.layer.cornerRadius = 12.0
        view.layer.masksToBounds = true
        view.titleLabel?.sizeToFit()
        view.sizeToFit()
        view.addTarget(self, action: #selector(didTappedPayBtn), for: .touchUpInside)
        return view
    }()

    private var appearance = Appearance()
    var delegate: OrderHistoryHeaderDelegate?
    private var orderHistory: OrderHistory? {
        didSet {
            guard let orderHistory = orderHistory else { return }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4

            let titleLblAttributedText = NSMutableAttributedString(
                string: "Номер заказа: \(orderHistory.orderID ?? "0")",
                attributes: [.font: FontFamily.Inter.regular.font(size: 13.0),
                             .foregroundColor: Asset.secondaryGray.color,
                             .paragraphStyle: paragraphStyle])

            let date = Date(dateString: orderHistory.createdAt ?? "")
            let dateStr = (orderHistory.createdAt ?? "").getISODateAsStr("dd MMMM yyyy", date)
            let timeStr = (orderHistory.createdAt ?? "").getISODateAsStr("HH:mm", date)

            titleLblAttributedText.append(.init(string: "\n\(dateStr)",
                                                attributes: [.font: FontFamily.Inter.bold.font(size: 15.0),
                                                             .foregroundColor: Asset.orange.color]))
            titleLblAttributedText.append(.init(string: " \(timeStr)",
                                                attributes: [.font: FontFamily.Inter.bold.font(size: 15.0),
                                                             .foregroundColor: Asset.mainBlack.color]))
            titleLbl.attributedText = titleLblAttributedText
            payBtn.isHidden = orderHistory.status != .not_paid_payment_allowed
            remakeConstraints()
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        backgroundColor = appearance.backgroundColor
        contentView.backgroundColor = appearance.backgroundColor

        addSubview(cornerView)
        cornerView.layer.cornerRadius = 16.0
        cornerView.layer.masksToBounds = true
        cornerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        cornerView.addSubview(titleLbl)
        cornerView.addSubview(payBtn)

        remakeConstraints()
    }

    fileprivate func remakeConstraints() {
        cornerView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(4.0)
            make.left.right.bottom.equalToSuperview()
        }

        payBtn.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(20.0)
            make.right.equalTo(cornerView.snp.right).offset(-20.0)
            make.bottom.equalToSuperview().offset(-20.0)
        }

        titleLbl.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(20.0)
            make.right.equalToSuperview().offset(-20.0)
            make.top.equalToSuperview().offset(14.0)
            make.bottom.equalToSuperview().offset(-14.0)
        }
    }

    func setup(_ orderHistory: OrderHistory?) {
        self.orderHistory = orderHistory
    }

    @objc private func didTappedPayBtn() {
        payBtn.pulsate()
        guard let orderHistory = orderHistory else { return }
        delegate?.didTappedPayBtn(orderHistory)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
