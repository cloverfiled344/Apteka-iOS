//
//  FullNameTVCell.swift
//  Infoapteka
//
//

import UIKit

protocol FullNameTVCellDelegate {
    func didFullNameTFEvent()
}

extension FullNameTVCell {
    struct Appearance {
        let cellSelectioStyle: UITableViewCell.SelectionStyle = .none

        let titleLblTextColor: UIColor = Asset.secondaryGray3.color
        let titleLblFont: UIFont = FontFamily.Inter.semiBold.font(size: 13)
        let titleWidth: CGFloat = Constants.screenWidth - 40
        let titleBottomMargin: CGFloat = 4.0

        let textFieldWidth: CGFloat = Constants.screenWidth - 40
        let textFieldTextColor: UIColor = Asset.mainBlack.color
        let textFieldFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let textFieldHeight: CGFloat = 34

        let errorTitleLblText = L10n.enteredIncorrectPhoneNumber
        let errorTitleLblTextColor: UIColor = Asset.secondaryRed.color
        let errorTitleLblFont: UIFont = FontFamily.Inter.regular.font(size: 13)
        let errorTitleWidth: CGFloat = Constants.screenWidth - 40
        let errorTitleTopMargin: CGFloat = 4.0

        let tfBottomLineBackgroundColor: UIColor = Asset.secondaryGray2.color
        let tfBottomLineBottomMargin: CGFloat = 32.0
        let tfBottomLineWidth: CGFloat = Constants.screenWidth - 40
    }
}

class FullNameTVCell: UITableViewCell {

    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.font =      appearance.titleLblFont
        view.textColor = appearance.titleLblTextColor
        return view
    }()

    lazy private var textField: UITextField = {
        let view = UITextField()
        view.smartInsertDeleteType  = .yes
        view.textColor              = appearance.textFieldTextColor
        view.font                   = appearance.textFieldFont
        view.addTarget(self, action: #selector(didEventTF), for: .allEvents)
        return view
    }()

    lazy private var tfBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.tfBottomLineBackgroundColor
        return view
    }()

    // MARK: Properties
    private let appearance = Appearance()
    var delegate: FullNameTVCellDelegate?
    private var viewModel: RegisterVM?
    var field: RegisterField? {
        didSet {
            guard let field = self.field else { return }
            self.titleLbl.text = field.type.rawValue
            self.textField.placeholder = field.placeholder
            if let addres = field.value as? String {
                self.textField.text = addres
            } else if let city = field.value as? City {
                self.textField.text = city.title
            }
        }
    }

    // MARK: Initialize
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    @objc private func didEventTF() {
        delegate?.didFullNameTFEvent()
        guard field != nil else { return }
        field!.value = self.textField.text
        viewModel?.setValue(field!)
    }

    // MARK: -- public methods
    func setup(_ viewModel: RegisterVM,
               _ field: RegisterField) {
        self.viewModel = viewModel
        self.field = field
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup UI
extension FullNameTVCell {

    private func setupUI() {
        selectionStyle = appearance.cellSelectioStyle

        contentView.addSubview(titleLbl)
        contentView.addSubview(textField)
        contentView.addSubview(tfBottomLine)

        setConstraints()
    }

    private func setConstraints() {
        self.setupTFBottomLine()
    }

    fileprivate func setupTFBottomLine() {
        self.tfBottomLine.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.tfBottomLineWidth)
            maker.height.equalTo(1)
            maker.bottom.equalTo(self.contentView.snp.bottom)
                .offset(-appearance.tfBottomLineBottomMargin)
        }

        self.setupTextFieldMaking()
    }

    fileprivate func setupTextFieldMaking() {
        self.textField.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.textFieldWidth)
            maker.height.equalTo(appearance.textFieldHeight)
            maker.bottom.equalTo(self.tfBottomLine.snp.top)
        }

        self.setupTitleLblMaking()
    }

    fileprivate func setupTitleLblMaking() {
        self.titleLbl.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(self.contentView.snp.top)
            maker.width.equalTo(appearance.titleWidth)
            maker.bottom.equalTo(self.textField.snp.top)
                .offset(-appearance.titleBottomMargin)
        }
    }
}
