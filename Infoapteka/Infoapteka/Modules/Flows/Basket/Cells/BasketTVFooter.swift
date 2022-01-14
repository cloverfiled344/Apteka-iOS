 //
 //  BasketTVFooter.swift
 //  Infoapteka
 //
 //

 import UIKit

 // MARK: -- Appearance
 extension BasketTVFooter {
    struct Appearance {
        let backgroundColor          : UIColor = Asset.backgroundGray.color
        let centerViewBackgroundColor: UIColor = Asset.mainWhite.color

        let centerViewCornerRadius: CGFloat = 16.0
        let centerViewBorderWidth : CGFloat = 1.0
        let centerViewBorderColor : CGColor = Asset.secondaryLight.color.cgColor
        let centerViewTopBottomMargin: CGFloat = 4.0
        let centerViewLeftRightMargin: CGFloat = 20.0

        let lineHeightMultiple: CGFloat = 1.5
    }
 }

 class BasketTVFooter: UITableViewHeaderFooterView {

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

    private var appearance = Appearance()
    private var basket: Basket? {
        didSet {
            guard let basket = basket else { return }
            setValueLblValue(basket)
        }
    }

    private func setValueLblValue(_ basket: Basket) {
        let generalParagraphStyle = NSMutableParagraphStyle()
        generalParagraphStyle.lineHeightMultiple = 1.6
        generalParagraphStyle.alignment = .right

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = appearance.lineHeightMultiple
        paragraphStyle.alignment = .right
        let valueLblAttributedText = NSMutableAttributedString(string: "Условия доставки",
                                                               attributes: [.font: FontFamily.Inter.regular.font(size: 13),
                                                                            .foregroundColor: Asset.mainBlue.color,
                                                                            .paragraphStyle: generalParagraphStyle])
        valueLblAttributedText.append(.init(string:  "\n\(basket.totalCartItems ?? 0)",
                                            attributes: [.font: FontFamily.Inter.regular.font(size: 14),
                                                         .foregroundColor: Asset.mainBlack.color,
                                                         .paragraphStyle: paragraphStyle]))
        valueLblAttributedText.append(.init(string: "\n\(basket.totalCart ?? 0) сом",
                                            attributes: [.font: FontFamily.Inter.regular.font(size: 14),
                                                         .foregroundColor: Asset.mainBlack.color,
                                                         .paragraphStyle: paragraphStyle]))
        valueLbl.attributedText = valueLblAttributedText
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = appearance.backgroundColor

        contentView.addSubview(centerView)
        centerView.addSubview(infoLbl)
        centerView.addSubview(valueLbl)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        centerView.snp.remakeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(appearance.centerViewTopBottomMargin)
            make.bottom.equalTo(contentView.snp.bottom).offset(-appearance.centerViewTopBottomMargin)
            make.left.equalTo(contentView.snp.left).offset(appearance.centerViewLeftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.centerViewLeftRightMargin)
        }

        infoLbl.snp.remakeConstraints { make in
            make.left.equalTo(centerView.snp.left).offset(16.0)
            make.top.equalTo(centerView.snp.top).offset(20.0)
            make.bottom.lessThanOrEqualTo(centerView.snp.bottom).offset(-20.0)
            make.right.equalTo(centerView.snp.centerX).offset(-8.0)
        }

        valueLbl.snp.remakeConstraints { make in
            make.right.equalTo(centerView.snp.right).offset(-16.0)
            make.top.equalTo(centerView.snp.top).offset(20.0)
            make.bottom.equalTo(infoLbl.snp.bottom)
            make.left.equalTo(centerView.snp.centerX).offset(8.0)
        }
    }

    func setup(_ basket: Basket?) {
        self.basket = basket
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 }
