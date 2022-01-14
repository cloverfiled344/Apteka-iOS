//
//  SaveTVCell.swift
//  Infoapteka
//
//

import UIKit

protocol SaveTVCellDelegate {
    func didTappedSubmitBtn()
}

// MARK: Appearance
extension SaveTVCell {
    struct Appearance {
        let submitBtnWidth: CGFloat = Constants.screenWidth - 40
        let submitBtnTitleFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let registerButtonTextColor: UIColor = Asset.mainWhite.color
        let registerButtonCornerRadius: CGFloat = 12.0
        let registerButtonBottomMargin: CGFloat = 32.0
    }
}

class SaveTVCell: UITableViewCell {

    // MARK: UI Components
    private lazy var submitBtn: UIButton = {
        let view = UIButton()
        view.setTitleColor(appearance.registerButtonTextColor, for: .normal)
        view.layer.cornerRadius = appearance.registerButtonCornerRadius
        view.titleLabel?.font = appearance.submitBtnTitleFont
        view.backgroundColor = Asset.mainGreen.color
        return view
    }()

    // MARK: Properties
    private let appearance = Appearance()
    var delegate: SaveTVCellDelegate?

    // MARK: Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    func setup(_ title: String) {
        submitBtn.setTitle(title, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup UI
private extension SaveTVCell {

    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(submitBtn)
        setConstraints()
    }

    private func setConstraints() {
        self.submitBtn.addTarget(self, action: #selector(didTappedSubmitBtn), for: .touchUpInside)
        let submitBtnHeight = appearance.submitBtnWidth * 0.12
        self.submitBtn.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.submitBtnWidth)
            maker.height.equalTo(submitBtnHeight)
            maker.top.equalTo(self.contentView.snp.top)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-appearance.registerButtonBottomMargin)
        }
    }

    @objc private func didTappedSubmitBtn() {
        self.submitBtn.pulsate()
        self.delegate?.didTappedSubmitBtn()
    }
}
