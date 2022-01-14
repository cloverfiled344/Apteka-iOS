//
//  HelpTVCell.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK: Appearance
extension HelpTVCell {
    struct Appearance {
        let cellBackgroundColor: UIColor = Asset.backgroundGray.color
        let backViewCornerRadius: CGFloat = 16.0
        let backViewColor: UIColor = Asset.mainWhite.color
        let titleTextFont: UIFont = FontFamily.Inter.bold.font(size: 14)
        let titleTextColor: UIColor = Asset.mainBlack.color
        let subtitleTextFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let titleNumberOfLines: Int = 0
        let subtitleTextColor: UIColor = Asset.mainBlack.color
        let ivContentMode: UIImageView.ContentMode = .scaleAspectFill
        let arrowImageHeightWidth: CGFloat = 24.0
        let arrowDownImage: UIImage = Asset.icArrowDown.image
        let arrowTopImage: UIImage = Asset.icTopArrow.image
        let lineBreakMode: NSLineBreakMode = .byWordWrapping
        let kAnimationDuration: TimeInterval = 0.3
        let kAnimationDelay: TimeInterval = 0
        let kTextSpacing: CGFloat = 10
        let verticalStackAxis: NSLayoutConstraint.Axis = .vertical
        let additionalStackAxis: NSLayoutConstraint.Axis = .horizontal
        let additionalStackDistribution: UIStackView.Distribution = .equalCentering
        let stackAutoresizingConstraints: Bool = false
        let cellSelectionStyle: UITableViewCell.SelectionStyle = .none
    }
}

class HelpTVCell: UITableViewCell {
    
    // MARK: UI Components
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.backViewColor
        view.layer.cornerRadius = appearance.backViewCornerRadius
        return view
    }()
    
    private lazy var verticalStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = appearance.stackAutoresizingConstraints
        view.axis = appearance.verticalStackAxis
        view.spacing = appearance.kTextSpacing
        return view
    }()
    
    private lazy var additionalStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = appearance.stackAutoresizingConstraints
        view.axis = appearance.additionalStackAxis
        view.distribution = appearance.additionalStackDistribution
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = appearance.titleNumberOfLines
        view.textColor = appearance.titleTextColor
        view.font = appearance.titleTextFont
        view.lineBreakMode = appearance.lineBreakMode
        return view
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = appearance.subtitleTextFont
        view.textColor = appearance.subtitleTextColor
        view.numberOfLines = appearance.titleNumberOfLines
        view.lineBreakMode = appearance.lineBreakMode
        return view
    }()
    
    private lazy var expandImageView: UIImageView = {
        let view = UIImageView()
        view.image = appearance.arrowDownImage
        return view
    }()
    
    // MARK: Properties
    private let appearance = Appearance()
    private var helpResult: [HelpResult]?
    public var expandCallBack: ((() -> Void) -> Void)!
    
    
    private var help: HelpResult? {
        didSet {
            self.titleLabel.text = help?.question
            self.subtitleLabel.text = help?.answer
        }
    }
    
    // MARK: Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.selectionStyle = appearance.cellSelectionStyle
        self.contentView.backgroundColor = appearance.cellBackgroundColor
        self.contentView.addSubview(backView)
        self.backView.addSubview(verticalStack)
        self.verticalStack.addArrangedSubview(self.subtitleLabel)
        self.verticalStack.addArrangedSubview(self.additionalStack)
        self.backView.addSubview(titleLabel)
        self.backView.addSubview(expandImageView)
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandOnCellTap)))
        self.setConstraints()
    }
    
    private func setConstraints() {
        self.backView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contentView.snp.top).offset(8)
            maker.leading.equalTo(self.contentView.snp.leading).offset(20)
            maker.trailing.equalTo(self.contentView.snp.trailing).offset(-20)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-4)
        }
        
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(backView.snp.trailing).offset(-8)
            maker.leading.equalTo(self.backView.snp.leading).offset(12)
            maker.top.equalTo(self.backView.snp.top).offset(16)
        }
        
        self.verticalStack.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            maker.leading.equalTo(self.backView.snp.leading).offset(12)
            maker.trailing.equalTo(self.backView.snp.trailing).offset(-12)
            maker.bottom.equalTo(self.backView.snp.bottom).offset(-12)
        }
        
        self.expandImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.titleLabel.snp.top)
            maker.trailing.equalTo(self.backView.snp.trailing).offset(-12)
        }
    }
    
    func setupCell(_ helpResult: [HelpResult], _ help: HelpResult, _ completion: @escaping(() -> Void) -> Void) {
        self.helpResult = helpResult
        self.help = help
        self.expandCallBack = completion
        self.subtitleLabel.isHidden = !(help.isExpandable)
    }
    
    @objc private func expandOnCellTap() {
        expandCallBack({ [weak self] in
            guard let `self` = self else { return }
            self.help?.isExpandable.toggle()
            let titleHeight = self.titleLabel.frame.height
            UIView.animateKeyframes(withDuration: appearance.kAnimationDuration,
                                    delay: appearance.kAnimationDelay,
                                    options: .allowUserInteraction) {
                self.titleLabel.heightAnchor.constraint(equalToConstant: titleHeight).isActive = true
                self.subtitleLabel.isHidden = !(self.help?.isExpandable ?? false)
            } completion: { (finished) in
                self.titleLabel.heightAnchor.constraint(equalToConstant: titleHeight).isActive = false
            }
        })
        UIView.animate(withDuration: appearance.kAnimationDuration) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi * -0.999)
            self.expandImageView.transform = (self.help?.isExpandable ?? false) ? upsideDown : .identity
        }
    }
}
