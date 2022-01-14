//
//  FilterCell.swift
//  Infoapteka
//
//

import UIKit

// MARK: Appearance
extension FilterCell {
    struct Appearance {
        let unSelectedCheckbox: UIImage = Asset.icUnselectedRadioButton.image
        let selectedCheckbox: UIImage = Asset.icSelectedRadioButton.image

        let checkBoxBtWidth: CGFloat = 20.0
        let checkBoxBtnRightMargin: CGFloat = 20.0

        let titleLblTextColor: UIColor = Asset.mainBlack.color
        let titleLblFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let titleLblLeftMargin: CGFloat = 20.0
        let titleLblRightMargin: CGFloat = 12.0
    }
}

class FilterCell: UITableViewCell {

    //MARK: -- UIProperties
    lazy private var titleLbl: UILabel = { UILabel() }()
    private lazy var checkBoxBtn: CheckBoxBtn = {
        let view = CheckBoxBtn(appearance.selectedCheckbox,
                               appearance.unSelectedCheckbox)
        return view
    }()

    private let appearance = Appearance()

    //MARK: -- init
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)

        contentView.addSubview(self.checkBoxBtn)
        contentView.addSubview(self.titleLbl)

        separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        checkBoxBtn.snp.remakeConstraints { make in
            make.right.equalTo(contentView.snp.right).offset(-appearance.checkBoxBtnRightMargin)
            make.width.height.equalTo(appearance.checkBoxBtWidth)
            make.centerY.equalTo(contentView.snp.centerY)
        }

        titleLbl.snp.remakeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(appearance.titleLblLeftMargin)
            make.right.equalTo(checkBoxBtn.snp.left).offset(-appearance.titleLblRightMargin)
            make.centerY.equalTo(checkBoxBtn.snp.centerY)
        }
    }

    //MARK: -- public methods
    func setFilter(_ searchFilter: SearchFilter?) {
        self.checkBoxBtn.isChecked = searchFilter?.isSelected ?? false
        self.titleLbl.text         = searchFilter?.filterType?.rawValue
    }

    //MARK: -- deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

