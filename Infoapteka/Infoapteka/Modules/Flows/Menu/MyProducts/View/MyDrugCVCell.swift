//
//  MyProductsCVCell.swift
//  Infoapteka
//
//  
//

import UIKit

protocol MyDrugCVCellDelegate {
    func didTappedOnEditBtn(_ drug: Drug?)
}

// MARK: Appearance
extension MyDrugCVCell {
    struct Appearance {
        let cellCornerRadius: CGFloat = 16.0
        let cellBackgroundColor: UIColor = Asset.mainWhite.color
        let cellLayerMaskToBounds: Bool = true

        let moreBtnImage: UIImage = Asset.icProductEditButton.image
        let moreBtnHeightWidht: CGFloat = 28.0

        let ivMaskToBounds: Bool = true
        let productPlaceholder: UIImage = Asset.icDefaultDrug.image
        let productIVContentMode: UIImageView.ContentMode = .scaleAspectFit

        let priceTextColor: UIColor = Asset.mainBlack.color
        let priceTextFont: UIFont = FontFamily.Inter.bold.font(size: 12)
    }
}

class MyDrugCVCell: UICollectionViewCell {

    // MARK: UI Components
    private lazy var blurView: MyDrugCVCellBlurView = {
        let view = MyDrugCVCellBlurView()
        view.delegate = self
        return view
    }()

    private lazy var productIV: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Asset.mainWhite.color
        view.contentMode = appearance.productIVContentMode
        view.layer.masksToBounds = appearance.ivMaskToBounds
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()

    private lazy var priceLabel: UILabel = {
        let view = UILabel()
        view.font = appearance.priceTextFont
        view.textColor = appearance.priceTextColor
        return view
    }()

    private lazy var moreButton: UIButton = {
        let view = UIButton()
        view.setImage(appearance.moreBtnImage, for: .normal)
        view.addTarget(self, action: #selector(tappedOnMoreBtn), for: .touchUpInside)
        return view
    }()
    
    // MARK: Properties
    public var delegate: MyDrugCVCellDelegate?
    private let appearance = Appearance()
    private var drug: Drug? {
        didSet {
            guard let drug = drug else { return }
            productIV.load(drug.image ?? "", appearance.productPlaceholder)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            let titleLblAttributedText = NSMutableAttributedString(string: drug.name ?? "",
                                                                   attributes: [.font: FontFamily.Inter.regular.font(size: 13.0),
                                                                                .foregroundColor: Asset.mainBlack.color,
                                                                                .paragraphStyle: paragraphStyle])
            titleLblAttributedText.append(.init(string: "\n\(drug.ownerName ?? "")",
                                                attributes: [.font: FontFamily.Inter.regular.font(size: 13.0),
                                                             .foregroundColor: Asset.secondaryGray3.color]))
            titleLabel.attributedText = titleLblAttributedText

            priceLabel.text = "\(drug.price ?? 0) с"

            blurView.setDrug(drug)
            blurView.isHidden = drug.status == .approved
        }
    }
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = appearance.cellBackgroundColor
        contentView.layer.cornerRadius = appearance.cellCornerRadius
        contentView.layer.masksToBounds = appearance.cellLayerMaskToBounds

        contentView.addSubview(productIV)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(moreButton)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        productIV.snp.remakeConstraints { (maker) in
            maker.top.equalTo(contentView.snp.top).offset(8.0)
            maker.left.equalTo(contentView.snp.left).offset(8.0)
            maker.right.equalTo(contentView.snp.right).offset(-8.0)
            maker.height.equalTo(frame.size.width)
        }

        titleLabel.snp.remakeConstraints { (maker) in
            maker.top.equalTo(productIV.snp.bottom).offset(6.0)
            maker.left.equalTo(contentView.snp.left).offset(8.0)
            maker.right.equalTo(contentView.snp.right).offset(-8.0)
        }

        moreButton.snp.remakeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(12.0)
            maker.right.equalTo(contentView.snp.right).offset(-8.0)
            maker.bottom.equalTo(contentView.snp.bottom).offset(-8.0)
            maker.height.width.equalTo(appearance.moreBtnHeightWidht)
        }

        priceLabel.snp.remakeConstraints { (maker) in
            maker.right.equalTo(moreButton.snp.left).offset(-8.0)
            maker.left.equalTo(contentView.snp.left).offset(8.0)
            maker.centerY.equalTo(moreButton.snp.centerY)
        }

        contentView.addSubview(blurView)
        blurView.snp.remakeConstraints { make in
            make.left.right.equalTo(contentView)
            make.top.equalTo(productIV.snp.top).offset(-8.0)
            make.bottom.equalTo(moreButton.snp.bottom).offset(8.0)
        }
    }
    
    @objc private func didTappedEditBtn() {
        moreButton.pulsate()
        delegate?.didTappedOnEditBtn(drug)
    }
    
    // MARK: - Setup Data
    func setupCell(_ drug: Drug?) {
        self.drug = drug
    }
}

extension MyDrugCVCell: MyDrugCVCellBlurViewDelegate {
    @objc func tappedOnMoreBtn() {
        delegate?.didTappedOnEditBtn(drug)
    }
}
