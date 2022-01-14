//
//  RegisterTVHeader.swift
//  Infoapteka
//
//

import UIKit

// MARK: Appearance
extension TitleTVCell {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color

        let titleLblTextColor: UIColor = Asset.mainBlack.color
        let titleLblFont: UIFont = FontFamily.Inter.bold.font(size: 24)
    }
}


class TitleTVCell: UITableViewCell {

    // MARK: -- UI Components
    private lazy var titleLbl: UILabel = {
        let view = UILabel()
        view.textColor = appearance.titleLblTextColor
        view.font = appearance.titleLblFont
        view.numberOfLines = 2
        return view
    }()

    // MARK: Properties
    private let appearance = Appearance()

    // MARK: -- Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.contentView.addSubview(self.titleLbl)
    }
    
    // MARK: -- making
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLbl.snp.remakeConstraints { make in
            make.top.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView.snp.left).offset(16)
            make.right.equalTo(self.contentView.snp.right).offset(-16)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-36)
        }
    }

    // MARK: -- public methods
    func setTitle(_ title: String) {
        self.titleLbl.text = title
    }
    
    // MARK: -- Initialize
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
