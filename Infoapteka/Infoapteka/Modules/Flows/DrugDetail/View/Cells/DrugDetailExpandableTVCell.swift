//
//  DrugDetailExpandableTVCell.swift
//  Infoapteka
//
//  
//

import UIKit

extension DrugDetailExpandableTVCell {
    struct Appearance {
        let backViewCornerRadius: CGFloat = 16.0
        let backViewColor: UIColor = Asset.mainWhite.color

        let titleNumberOfLines: Int = 0
        let titleTextFont: UIFont = FontFamily.Inter.regular.font(size: 13.0)
        let titleTextColor: UIColor = Asset.mainBlack.color
        let subtitleTextFont: UIFont = FontFamily.Inter.regular.font(size: 13.0)
        let subtitleTextColor: UIColor = Asset.mainBlack.color

        let ivContentMode: UIImageView.ContentMode = .scaleAspectFill
        let arrowImageHeightWidth: CGFloat = 24.0
        let icPlusImage: UIImage = Asset.icDrugPlus.image
        let icMinusImage: UIImage = Asset.icDrugMinus.image
        let lineBreakMode: NSLineBreakMode = .byWordWrapping
        let kAnimationDuration: TimeInterval = 0.5
        let kAnimationDelay: TimeInterval = 0
        let kTextSpacing: CGFloat = 0
        let verticalStackAxis: NSLayoutConstraint.Axis = .vertical
        let additionalStackAxis: NSLayoutConstraint.Axis = .horizontal
        let additionalStackDistribution: UIStackView.Distribution = .equalCentering
        let stackAutoresizingConstraints: Bool = false
        let cellSelectionStyle: UITableViewCell.SelectionStyle = .none
        let lineViewColor: UIColor = Asset.light.color
    }
}

class DrugDetailExpandableTVCell: UITableViewCell {
    
    // MARK: UI Components
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.backViewColor
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = appearance.titleNumberOfLines
        return view
    }()
    
    private lazy var expandImageView: UIImageView = {
        let view = UIImageView()
        view.image = appearance.icPlusImage
        return view
    }()
    
    private lazy var topLine: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.lineViewColor
        return view
    }()
    
    // MARK: Properties
    private let appearance = Appearance()
    public var expandCallBack: ((() -> Void) -> Void)!
    private var instruction: DrugDetailInstruction?
    private var titleHeightConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = appearance.cellSelectionStyle
        contentView.backgroundColor = appearance.backViewColor
        contentView.addSubview(backView)

        backView.addSubview(titleLabel)
        backView.addSubview(expandImageView)
        backView.addSubview(topLine)

        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandOnCellTap)))
        setConstraints()
    }

    private func setConstraints() {
        backView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView.snp.top)
            maker.left.equalTo(contentView.snp.left).offset(20.0)
            maker.right.equalTo(contentView.snp.right).offset(-20.0)
            maker.bottom.equalTo(contentView.snp.bottom)
        }

        topLine.snp.remakeConstraints { make in
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
            make.top.equalTo(backView.snp.top)
        }

        expandImageView.snp.remakeConstraints { (maker) in
            maker.top.equalTo(topLine.snp.top).offset(13.0)
            maker.height.width.equalTo(20.0)
            maker.left.equalTo(backView.snp.left)
        }

        titleLabel.snp.remakeConstraints { (maker) in
            maker.top.equalTo(expandImageView.snp.top)
            maker.right.equalTo(backView.snp.right)
            maker.left.equalTo(expandImageView.snp.right).offset(12.0)
            maker.bottom.equalTo(backView.snp.bottom).offset(-15.0)
        }
        titleHeightConstraint = titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16.0)
        titleHeightConstraint?.isActive = true
    }

    func setupCell(_ instruction: DrugDetailInstruction?,
                   _ row: Int,
                   _ completion: @escaping(() -> Void) -> Void) {
        self.instruction = instruction
        topLine.isHidden = row <= 0
        expandCallBack = completion
        titleLabel.attributedText = getTitleLblAttributedText()
    }

    private func getTitleLblAttributedText() -> NSMutableAttributedString? {
        guard let instruction = instruction else { return nil }
        let paraghraphStyle = NSMutableParagraphStyle()
        paraghraphStyle.paragraphSpacing = 15.0
        let attributedTxt = NSMutableAttributedString(string: instruction.instruction ?? "",
                                                      attributes: [.font: appearance.titleTextFont,
                                                                   .foregroundColor: appearance.titleTextColor,
                                                                    .paragraphStyle: paraghraphStyle])

        guard let desc = instruction.description, instruction.isSelected else {
            return attributedTxt
        }
        attributedTxt.append(.init(string: "\n  \(desc)", attributes: [.font: appearance.subtitleTextFont,
                                                                       .foregroundColor: appearance.subtitleTextColor]))
        return attributedTxt
    }

    @objc private func expandOnCellTap() {
        expandCallBack({ [weak self] in
            guard let `self` = self else { return }
            self.instruction?.isSelected.toggle()
            self.titleLabel.attributedText = self.getTitleLblAttributedText()
            UIView.animate(withDuration: appearance.kAnimationDuration) {
                self.expandImageView.image = (self.instruction?.isSelected ?? false) ?
                    self.appearance.icMinusImage : self.appearance.icPlusImage
            }
        })
    }
}

