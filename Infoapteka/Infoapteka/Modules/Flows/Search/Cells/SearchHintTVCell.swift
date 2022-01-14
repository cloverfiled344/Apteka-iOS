//
//  SearchHintTVCell.swift
//  Infoapteka
//
//

import UIKit

extension SearchHintTVCell {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color
        let separatorInset: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)

        let titleLblFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let titleLblColor: UIColor = Asset.mainBlack.color
        let titleLblNumberOfLines: Int = 2
        let titleLblLeftRightMargin: CGFloat = 16.0
        let titleLblTopBottomMargin: CGFloat = 12.0
    }
}

class SearchHintTVCell: UITableViewCell {

    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.font = appearance.titleLblFont
        view.textColor = appearance.titleLblColor
        view.numberOfLines = appearance.titleLblNumberOfLines
        return view
    }()

    private var appearance = Appearance()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = appearance.backgroundColor
        contentView.backgroundColor = appearance.backgroundColor
        separatorInset = appearance.separatorInset
        selectionStyle = .none
        
        contentView.addSubview(titleLbl)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLbl.snp.remakeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(appearance.titleLblLeftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.titleLblLeftRightMargin)
            make.top.equalTo(contentView.snp.top).offset(appearance.titleLblTopBottomMargin)
            make.bottom.equalTo(contentView.snp.bottom).offset(-appearance.titleLblTopBottomMargin)
        }
    }

    func setHint(_ hint: String?) {
        self.titleLbl.text = hint
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        titleLbl.textColor = highlighted ? Asset.mainBlue.color : appearance.titleLblColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
