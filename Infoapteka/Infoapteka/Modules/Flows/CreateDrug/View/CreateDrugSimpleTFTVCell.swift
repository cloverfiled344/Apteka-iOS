//
//  CreateDrugSimpleTFTVCell.swift
//  Infoapteka
//
//

import UIKit

extension CreateDrugSimpleTFTVCell {
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
        let tfBottomLineBottomMargin: CGFloat = 24.0
        let tfBottomLineWidth: CGFloat = Constants.screenWidth - 40
    }
}

class CreateDrugSimpleTFTVCell: UITableViewCell {

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
        view.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
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
    private var createDrugVM: CreateDrugVM?
    private var field: CreateDrugField? {
        didSet {
            guard let field = self.field else { return }
            self.titleLbl.text = field.type.rawValue
            self.textField.placeholder = field.placeholder
            self.textField.text = (field.value as? String) ?? ""

            self.textField.keyboardType = field.type == .price ? .numberPad : .default
        }
    }

    // MARK: Initialize
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }

    @objc private func editingChanged() {
        guard field != nil else { return }
        field!.value = textField.text
        createDrugVM?.setValue(field!)
    }

    // MARK: -- public methods
    func setup(_ viewModel: CreateDrugVM,
               _ field: CreateDrugField) {
        self.createDrugVM = viewModel
        self.field = field
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup UI
extension CreateDrugSimpleTFTVCell {
    private func setupUI() {
        selectionStyle = appearance.cellSelectioStyle
        selectionStyle = .none

        contentView.addSubview(titleLbl)
        contentView.addSubview(textField)
        contentView.addSubview(tfBottomLine)
    }

    private func setConstraints() {
        setupTFBottomLine()
    }

    fileprivate func setupTFBottomLine() {
        tfBottomLine.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.tfBottomLineWidth)
            maker.height.equalTo(1.0)
            maker.bottom.equalTo(contentView.snp.bottom)
                .offset(-appearance.tfBottomLineBottomMargin)
        }

        setupTextFieldMaking()
    }

    fileprivate func setupTextFieldMaking() {
        textField.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.textFieldWidth)
            maker.height.equalTo(appearance.textFieldHeight)
            maker.bottom.equalTo(tfBottomLine.snp.top)
        }

        setupTitleLblMaking()
    }

    fileprivate func setupTitleLblMaking() {
        titleLbl.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(contentView.snp.top)
            maker.width.equalTo(appearance.titleWidth)
            maker.bottom.equalTo(textField.snp.top)
                .offset(-appearance.titleBottomMargin)
        }
    }
}
