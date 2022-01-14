//
//  CommentTVCell.swift
//  Infoapteka
//
//

import UIKit

extension CommentTVCell {
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

        let textViewBackgroundColor: UIColor = Asset.mainWhite.color
        let textViewLayerCornerRadius: CGFloat = 12.0
        let textViewFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let textViewTextColor: UIColor = Asset.mainBlack.color

        let textViewBorderWidth : CGFloat = 1.0
        let textViewBorderColor : CGColor = Asset.secondaryLight.color.cgColor
    }
}

class CommentTVCell: UITableViewCell {

    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.font =      appearance.titleLblFont
        view.textColor = appearance.titleLblTextColor
        return view
    }()

    private lazy var textView: TextViewWithPlaceholder = {
        let view = TextViewWithPlaceholder()
        view.layer.cornerRadius = appearance.textViewLayerCornerRadius
        view.backgroundColor = appearance.textViewBackgroundColor
        view.font = appearance.textViewFont
        view.layer.borderWidth = appearance.textViewBorderWidth
        view.layer.borderColor = appearance.textViewBorderColor
        view.textColor = appearance.textViewTextColor
        view.isScrollEnabled = true
        view.delegate = self
        view.textContainerInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        return view
    }()

    // MARK: Properties
    private let appearance = Appearance()
    var delegate: FullNameTVCellDelegate?
    private var checkoutVM: CheckoutVM?
    private var checkoutField: CheckoutField? {
        didSet {
            guard let field = checkoutField else { return }
            self.titleLbl.text = field.type.rawValue
            textView.setup((field.value as? String) ?? "", field.placeholder)
        }
    }

    private var createDrugVM: CreateDrugVM?
    private var createDrugField: CreateDrugField? {
        didSet {
            guard let field = createDrugField else { return }
            self.titleLbl.text = field.type.rawValue
            textView.setup((field.value as? String) ?? "", field.placeholder)
        }
    }

    // MARK: Initialize
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    // MARK: -- public methods
    func setup(_ viewModel: CheckoutVM,
               _ field: CheckoutField) {
        self.checkoutVM = viewModel
        self.checkoutField = field
    }

    func setup(_ viewModel: CreateDrugVM,
               _ field: CreateDrugField) {
        self.createDrugVM = viewModel
        self.createDrugField = field
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup UI
extension CommentTVCell {
    private func setupUI() {
        selectionStyle = appearance.cellSelectioStyle
        selectionStyle = .none

        contentView.addSubview(titleLbl)
        contentView.addSubview(textView)

        setConstraints()
    }

    private func setConstraints() {
        setupTextFieldMaking()
    }

    fileprivate func setupTextFieldMaking() {
        textView.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.textFieldWidth)
            maker.height.equalTo(appearance.textFieldWidth / 2.2)
            maker.bottom.equalTo(contentView.snp.bottom).offset(-24.0)
        }

        setupTitleLblMaking()
    }

    fileprivate func setupTitleLblMaking() {
        titleLbl.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(contentView.snp.top)
            maker.width.equalTo(appearance.titleWidth)
            maker.bottom.equalTo(textView.snp.top)
                .offset(-appearance.titleBottomMargin)
        }
    }
}

extension CommentTVCell: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if let checkoutVM = checkoutVM, var checkoutField = checkoutField {
            checkoutField.value = textView.text + text
            checkoutVM.setValue(checkoutField)
        } else if let createDrugVM = createDrugVM, var createDrugField = createDrugField {
            createDrugField.value = textView.text + text
            createDrugVM.setValue(createDrugField)
        }
        return true
    }
}
