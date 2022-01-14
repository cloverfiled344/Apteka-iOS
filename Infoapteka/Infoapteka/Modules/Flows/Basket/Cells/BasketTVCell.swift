//
//  BasketTVCell.swift
//  Infoapteka
//
//

import UIKit

protocol BasketTVCellDelegate {
    func deleteCart(_ cart: Cart)
    func changeQuantity(_ cart: Cart, _ count: Int)
    func changeFavorite(_ cart: Cart, _ isFavorite: Bool)
}

// MARK: -- Appearance
extension BasketTVCell {
    struct Appearance {
        let backgroundColor          : UIColor = Asset.backgroundGray.color
        let centerViewBackgroundColor: UIColor = Asset.mainWhite.color

        let centerViewCornerRadius: CGFloat = 12.0
        let centerViewBorderWidth : CGFloat = 1.0
        let centerViewBorderColor : CGColor = Asset.secondaryLight.color.cgColor
        let centerViewTopBottomMargin: CGFloat = 4.0
        let centerViewLeftRightMargin: CGFloat = 20.0

        let iconIVContentMode: UIImageView.ContentMode = .scaleAspectFit
        let iconIVWidth: CGFloat = 124.0

        let descLblMargin: CGFloat = 12.0
        let descTitleFont     : UIFont = FontFamily.Inter.regular.font(size: 13)
        let descTitleTextColor: UIColor = Asset.mainBlack.color
        let descSubtitleFont     : UIFont = FontFamily.Inter.regular.font(size: 13)
        let descSubtitleTextColor: UIColor = Asset.secondaryGray3.color

        let priceLblLeftRightMargin: CGFloat = 12.0
        let priceLblFont     : UIFont = FontFamily.Inter.bold.font(size: 12)
        let priceLblTextColor: UIColor = Asset.mainBlack.color

        let bottomViewBottomMargin: CGFloat = 12.0
        let bottomViewHeight   : CGFloat = 34.0
        let bottomViewTopMargin: CGFloat = 6.0
    }
}

class BasketTVCell: UITableViewCell {

    lazy private var centerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius  = appearance.centerViewCornerRadius
        view.layer.borderWidth   = appearance.centerViewBorderWidth
        view.layer.borderColor   = appearance.centerViewBorderColor
        view.backgroundColor     = appearance.centerViewBackgroundColor
        return view
    }()

    lazy private var iconIV: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.contentMode = appearance.iconIVContentMode
        return view
    }()

    lazy private var descLbl: UILabel = {
        let view = UILabel()
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        return view
    }()

    lazy private var priceLbl: UILabel = {
        let view = UILabel()
        view.font = appearance.priceLblFont
        view.textColor = appearance.priceLblTextColor
        return view
    }()

    lazy private var bottomView: BasketTVCellBottomView = {
        let view = BasketTVCellBottomView()
        view.delegate = self
        return view
    }()

    // MARK: Properties
    private let appearance = Appearance()
    var delegate: BasketTVCellDelegate?

    var cart: Cart? {
        didSet {
            guard let cart = cart else { return }
            iconIV.load(cart.drug?.image ?? "", Asset.icDefaultDrug.image)
            setDescLblValue(cart)
            priceLbl.text = "\(cart.drug?.price ?? 0) с"
            bottomView.setup(cart)
        }
    }

    private func setDescLblValue(_ cart: Cart) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        let attributedText = NSMutableAttributedString(string: cart.drug?.name ?? "",
                                                       attributes: [.font: appearance.descTitleFont,
                                                                    .foregroundColor: appearance.descTitleTextColor])
        if let ownerName = cart.drug?.owner?.firstName {
            attributedText.append(.init(string: "\n\(ownerName)",
                                        attributes: [.font: appearance.descSubtitleFont,
                                                     .foregroundColor: appearance.descSubtitleTextColor,
                                                     .paragraphStyle : paragraphStyle]))
        }
        descLbl.attributedText = attributedText
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = appearance.backgroundColor

        contentView.addSubview(centerView)
        centerView.addSubview(iconIV)
        centerView.addSubview(priceLbl)
        centerView.addSubview(descLbl)
        centerView.addSubview(bottomView)

        centerView.snp.remakeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(appearance.centerViewTopBottomMargin)
            make.bottom.equalTo(contentView.snp.bottom).offset(-appearance.centerViewTopBottomMargin)
            make.left.equalTo(contentView.snp.left).offset(appearance.centerViewLeftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.centerViewLeftRightMargin)
        }

        iconIV.snp.remakeConstraints { make in
            make.left.top.equalTo(centerView)
            make.width.height.equalTo(appearance.iconIVWidth)
        }

        descLbl.snp.remakeConstraints { make in
            make.left.equalTo(iconIV.snp.right).offset(appearance.descLblMargin)
            make.top.equalTo(iconIV.snp.top).offset(appearance.descLblMargin)
            make.right.equalTo(centerView.snp.right).offset(-appearance.descLblMargin)
            make.bottom.lessThanOrEqualTo(priceLbl.snp.top).offset(-appearance.descLblMargin)
        }

        priceLbl.snp.remakeConstraints { make in
            make.left.equalTo(iconIV.snp.right).offset(appearance.priceLblLeftRightMargin)
            make.right.equalTo(centerView.snp.right).offset(-appearance.priceLblLeftRightMargin)
            make.centerY.equalTo(iconIV.snp.bottom)
        }

        bottomView.snp.remakeConstraints { make in
            make.top.equalTo(priceLbl.snp.bottom).offset(appearance.bottomViewTopMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(appearance.bottomViewHeight)
            make.bottom.equalTo(centerView.snp.bottom).offset(-appearance.bottomViewBottomMargin)
        }
    }

    func setup(_ cart: Cart?) {
        self.cart = cart
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BasketTVCell: BasketTVCellBottomViewDelegate {
    func deleteCart(_ cart: Cart) {
        delegate?.deleteCart(cart)
    }

    func changeQuantity(_ cart: Cart, _ count: Int) {
        count > 0 ? delegate?.changeQuantity(cart, count) : delegate?.deleteCart(cart)
    }

    func changeFavorite(_ cart: Cart, _ isFavorite: Bool) {
        delegate?.changeFavorite(cart, isFavorite)
    }
}

protocol BasketTVCellBottomViewDelegate {
    func deleteCart(_ cart: Cart)
    func changeQuantity(_ cart: Cart, _ count: Int)
    func changeFavorite(_ cart: Cart, _ isFavorite: Bool)
}

// MARK: -- Appearance
extension BasketTVCellBottomView {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color

        let removeBtnTitleFont: UIFont = FontFamily.Inter.regular.font(size: 13)
        let removeBtnTitle: String = L10n.remove

        let unselectedFavourite: UIImage = Asset.icUnselectedHeart.image
        let selectedFavourite  : UIImage = Asset.icSelectedHeart.image
        let favouriteBtnBorderWidth  : CGFloat = 1.0
        let favouriteBtnCornerRadius : CGFloat = 8.0
        let favouriteBtnBorderColor  : CGColor = Asset.favouriteBtnBorder.color.cgColor

        let minusBtnImage: UIImage = Asset.icMinus.image
        let minusBtnBorderWidth  : CGFloat = 1.0
        let minusBtnCornerRadius : CGFloat = 8.0
        let minusBtnBorderColor  : CGColor = Asset.secondaryLight.color.cgColor

        let plusBtnImage: UIImage = Asset.icPlus.image
        let plusBtnBorderWidth  : CGFloat = 1.0
        let plusBtnCornerRadius : CGFloat = 8.0
        let plusBtnBorderColor  : CGColor = Asset.mainGreen.color.cgColor
        let plusBtnbackgrounndColor: UIColor = Asset.mainGreen.color

        let inCartTFBorderWidth  : CGFloat = 1.0
        let inCartTFCornerRadius : CGFloat = 8.0
        let inCartTFBorderColor  : CGColor = Asset.secondaryLight.color.cgColor
        let inCartTFFont     : UIFont = FontFamily.Inter.bold.font(size: 13)
        let inCartTFTextColor: UIColor = Asset.mainBlack.color
    }
}

class BasketTVCellBottomView: UIView {

    lazy private var removeBtn: UIButton = {
        let view = UIButton()
        view.setImage(Asset.icDelete.image, for: .normal)
        view.setImage(Asset.icDelete.image.withTintColor(Asset.mainRed.color), for: .highlighted)
        view.setTitle(appearance.removeBtnTitle, for: .normal)
        view.titleLabel?.font = appearance.removeBtnTitleFont
        view.titleEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
        view.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 8)
        view.setTitleColor(Asset.secondaryGray3.color, for: .normal)
        view.setTitleColor(Asset.mainRed.color, for: .highlighted)
        view.addTarget(self, action: #selector(deleteCart), for: .touchUpInside)
        return view
    }()

    private lazy var favouriteBtn: UIButton = {
        let view = UIButton()
        view.setImage(appearance.unselectedFavourite, for: .normal)
        view.layer.borderWidth = appearance.favouriteBtnBorderWidth
        view.layer.borderColor = appearance.favouriteBtnBorderColor
        view.layer.cornerRadius = appearance.favouriteBtnCornerRadius
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(changeFavourite), for: .touchUpInside)
        return view
    }()

    private lazy var minesBtn: UIButton = {
        let view = UIButton()
        view.setImage(appearance.minusBtnImage, for: .normal)
        view.layer.borderWidth = appearance.minusBtnBorderWidth
        view.layer.borderColor = appearance.minusBtnBorderColor
        view.layer.cornerRadius = appearance.minusBtnCornerRadius
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(didTappedMinusBtn), for: .touchUpInside)
        return view
    }()

    private lazy var inCartTF: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.layer.masksToBounds = true
        view.keyboardType = .numberPad
        view.layer.cornerRadius = appearance.inCartTFCornerRadius
        view.layer.borderWidth = appearance.inCartTFBorderWidth
        view.layer.borderColor = appearance.inCartTFBorderColor
        view.font = appearance.inCartTFFont
        view.textColor = appearance.inCartTFTextColor
        view.textAlignment = .center
        return view
    }()

    private lazy var plusBtn: UIButton = {
        let view = UIButton()
        view.setImage(appearance.plusBtnImage, for: .normal)
        view.layer.borderWidth = appearance.plusBtnBorderWidth
        view.layer.borderColor = appearance.plusBtnBorderColor
        view.layer.cornerRadius = appearance.plusBtnCornerRadius
        view.backgroundColor = appearance.plusBtnbackgrounndColor
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(didTappedPlusBtn), for: .touchUpInside)
        return view
    }()

    // MARK: Properties
    private let appearance = Appearance()
    private var cart: Cart? {
        didSet {
            guard let cart = cart else { return }
            favouriteBtn.setImage((cart.drug?.isFavorites ?? false) ? appearance.selectedFavourite : appearance.unselectedFavourite, for: .normal)
            inCartTF.text = "\(cart.quantity ?? 0)"
        }
    }
    var delegate: BasketTVCellBottomViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = appearance.backgroundColor

        addSubview(removeBtn)
        addSubview(favouriteBtn)
        addSubview(minesBtn)
        addSubview(inCartTF)
        addSubview(plusBtn)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        removeBtn.snp.remakeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(124.0)
            make.height.equalTo(34.0)
        }

        favouriteBtn.snp.remakeConstraints { make in
            make.left.equalTo(removeBtn.snp.right).offset(12.0)
            make.centerY.equalTo(removeBtn.snp.centerY)
            make.height.width.equalTo(34.0)
        }

        minesBtn.snp.remakeConstraints { make in
            make.left.equalTo(favouriteBtn.snp.right).offset(4.0)
            make.centerY.equalTo(favouriteBtn.snp.centerY)
            make.height.width.equalTo(34.0)
        }

        plusBtn.snp.remakeConstraints { make in
            make.right.equalTo(snp.right).offset(-12.0)
            make.centerY.equalTo(favouriteBtn.snp.centerY)
            make.height.width.equalTo(34.0)
        }

        inCartTF.snp.remakeConstraints { make in
            make.left.equalTo(minesBtn.snp.right).offset(4.0)
            make.centerY.equalTo(minesBtn.snp.centerY)
            make.height.equalTo(34)
            make.right.equalTo(plusBtn.snp.left).offset(-4.0)
        }
    }

    func setup(_ cart: Cart?) {
        self.cart = cart
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BasketTVCellBottomView {
    @objc func deleteCart() {
        guard let cart = cart else { return }
        removeBtn.pulsate()
        delegate?.deleteCart(cart)
    }

    @objc func changeFavourite() {
        guard let cart = cart else { return }
        favouriteBtn.pulsate()
        delegate?.changeFavorite(cart, !(cart.drug?.isFavorites ?? false))
    }

    @objc func didTappedMinusBtn() {
        guard let cart = cart else { return }
        minesBtn.pulsate()
        let quantity = (cart.quantity ?? 0) - 1
        delegate?.changeQuantity(cart, quantity)
    }

    @objc func didTappedPlusBtn() {
        guard let cart = cart else { return }
        plusBtn.pulsate()
        let quantity = (cart.quantity ?? 0 ) + 1
        delegate?.changeQuantity(cart, quantity)
    }
}

extension BasketTVCellBottomView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty, Int(text.digits) ?? 0 >= 0 else {
            guard let cart = cart else { return }
            textField.text = "\(cart.quantity ?? 0)"
            return
        }
        guard let cart = cart else { return }
        delegate?.changeQuantity(cart, Int(textField.text ?? "") ?? (cart.quantity ?? 0))
    }
}

// MARK: -- Appearance
extension LeftAlignedIconButton {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color

        let imageVTopBottomMargin: CGFloat = 8.0
        let imageVLeftMargin : CGFloat = 18.0
        let iconIVContentMode: UIImageView.ContentMode = .scaleAspectFit

        let titleVTopBottomMargin: CGFloat = 8.0
        let titleVLeftMargin  : CGFloat = 8.0
        let titleVRightMargin : CGFloat = 18.0
    }
}

class LeftAlignedIconButton: UIButton {

    lazy private var imageV: UIImageView = {
        let view = UIImageView()
        view.image = imageView?.image
        view.contentMode = appearance.iconIVContentMode
        return view
    }()

    lazy private var titleV: UILabel = {
        let view = UILabel()
        view.text = titleLabel?.text
        view.font = titleLabel?.font
        view.textAlignment = .center
        return view
    }()

    private let appearance = Appearance()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = appearance.backgroundColor
        imageView?.isHidden = true
        titleLabel?.isHidden = true

        addSubview(imageV)
        addSubview(titleV)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let imageVWidth: CGFloat = bounds.height - (appearance.imageVTopBottomMargin * 2)
        imageV.snp.remakeConstraints { make in
            make.left.equalTo(appearance.imageVLeftMargin)
            make.top.equalTo(appearance.imageVTopBottomMargin)
            make.bottom.equalTo(-appearance.imageVTopBottomMargin)
            make.width.equalTo(imageVWidth)
        }

        titleV.snp.remakeConstraints { make in
            make.left.equalTo(imageV.snp.right).offset(appearance.titleVLeftMargin)
            make.top.equalTo(appearance.titleVTopBottomMargin)
            make.bottom.equalTo(-appearance.titleVTopBottomMargin)
            make.right.equalTo(snp.right).offset(-appearance.titleVRightMargin)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
