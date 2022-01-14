//
//  SearchHintFooter.swift
//  Infoapteka
//
//

import UIKit

protocol SearchHintFooterDelegate {
    func selectedOnTitle()
}

extension SearchHintFooter {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color

        let titleLblFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let titleLblColor: UIColor = Asset.secondaryGray.color
        let titleLblNumberOfLines: Int = 2
        let titleLblLeftRightMargin: CGFloat = 16.0
        let titleLblTopBottomMargin: CGFloat = 12.0
    }
}

class SearchHintFooter: UITableViewHeaderFooterView {

    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = appearance.titleLblNumberOfLines
        return view
    }()

    private var appearance = Appearance()
    var delegate: SearchHintFooterDelegate?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    func setTitle(_ title: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.24

        titleLbl.attributedText = .init(string: title,
                                        attributes: [.font: appearance.titleLblFont,
                                                     .foregroundColor: appearance.titleLblColor,
                                                     .underlineStyle:  NSUnderlineStyle.single.rawValue,
                                                     .paragraphStyle: paragraphStyle])
    }

    fileprivate func setupUI() {
        backgroundColor             = appearance.backgroundColor
        contentView.backgroundColor = appearance.backgroundColor
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalTo(snp.left).offset(appearance.titleLblLeftRightMargin)
            make.right.equalTo(snp.right).offset(-appearance.titleLblLeftRightMargin)
            make.top.equalTo(snp.top).offset(appearance.titleLblTopBottomMargin)
            make.bottom.equalTo(snp.bottom).offset(-appearance.titleLblTopBottomMargin)
        }

        setTargetOnTitleLbl()
    }

    fileprivate func setTargetOnTitleLbl() {
        let tapOnTtileLbl = UITapGestureRecognizer(target: self, action: #selector(didTappedOnTitleLbl))
        titleLbl.isUserInteractionEnabled = true
        titleLbl.addGestureRecognizer(tapOnTtileLbl)
    }

    @objc private func didTappedOnTitleLbl() {
        titleLbl.pulsate()
        delegate?.selectedOnTitle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


