//
//  SelectCategoryTVCell.swift
//  Infoapteka
//
//

import UIKit

protocol SelectCategoryTVCellDelegate {
    func didTappedTF(_ field: CreateDrugField)
}

extension SelectCategoryTVCell {
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

        let rightArrowViewImage: UIImage = Asset.icArrowDown.image
        let rightArrowViewWidth: CGFloat = 20.0
        let rightArrowViewRigthMargin: CGFloat = 20.0
        let rightArrowViewLeftMargin: CGFloat = 12.0
    }
}

class SelectCategoryTVCell: UITableViewCell {

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
        view.font = appearance.textFieldFont
        view.addTarget(self, action: #selector(didTappedTF), for: .editingDidBegin)
        return view
    }()

    lazy private var tfBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.tfBottomLineBackgroundColor
        return view
    }()

    lazy private var rightArrowView: UIImageView = {
        let view = UIImageView()
        view.image = appearance.rightArrowViewImage
        view.contentMode = .scaleAspectFit
        return view
    }()

    // MARK: Properties
    private let appearance = Appearance()
    private var createDrugVM: CreateDrugVM?
    private var field: CreateDrugField? {
        didSet {
            guard let field = field else { return }
            self.titleLbl.text = field.type.rawValue
            self.textField.placeholder = field.placeholder
            if let category = (field.value as? Category) {
                self.textField.text = category.title
            }
        }
    }
    var delegate: SelectCategoryTVCellDelegate?

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

    // MARK: -- private methods
    @objc private func didTappedTF() {
        textField.endEditing(true)
        guard let field = field else { return }
        delegate?.didTappedTF(field)
    }

    // MARK: -- public methods
    func setup(_ viewModel: CreateDrugVM,
               _ field: CreateDrugField) {
        self.createDrugVM = viewModel
        self.field     = field
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup UI
private extension SelectCategoryTVCell {

    private func setupUI() {
        selectionStyle = appearance.cellSelectioStyle

        contentView.addSubview(titleLbl)
        contentView.addSubview(textField)
        contentView.addSubview(tfBottomLine)
        contentView.addSubview(rightArrowView)
    }

    private func setConstraints() {
        setupTFBottomLine()
    }

    func setupTFBottomLine() {
        tfBottomLine.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.tfBottomLineWidth)
            maker.height.equalTo(1.0)
            maker.bottom.equalTo(contentView.snp.bottom)
                .offset(-appearance.tfBottomLineBottomMargin)
        }

        setupTextFieldMaking()
    }

    func setupTextFieldMaking() {
        textField.snp.remakeConstraints { (maker) in
            maker.left.equalTo(contentView.snp.left).offset(20.0)
            maker.right.equalTo(contentView.snp.right).offset(-52.0)
            maker.height.equalTo(appearance.textFieldHeight)
            maker.bottom.equalTo(tfBottomLine.snp.top)
        }

        rightArrowView.snp.remakeConstraints { make in
            make.right.equalTo(contentView.snp.right).offset(-appearance.rightArrowViewRigthMargin)
            make.height.width.equalTo(appearance.rightArrowViewWidth)
            make.centerY.equalTo(textField.snp.centerY)
            make.left.equalTo(textField.snp.right).offset(appearance.rightArrowViewLeftMargin)
        }

        setupTitleLblMaking()
    }

    func setupTitleLblMaking() {
        titleLbl.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(contentView.snp.top)
            maker.width.equalTo(appearance.titleWidth)
            maker.bottom.equalTo(textField.snp.top)
                .offset(-appearance.titleBottomMargin)
        }
    }
}
