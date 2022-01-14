//
//  SelectDateTVCell.swift
//  Infoapteka
//
//

import UIKit

protocol SelectDateTVCellDelegate {
    func didTFSelectDateEvent()
}

extension SelectDateTVCell {
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

        let rightArrowViewImage: UIImage = Asset.icCalendar.image
        let rightArrowViewWidth: CGFloat = 20.0
        let rightArrowViewRigthMargin: CGFloat = 20.0
        let rightArrowViewLeftMargin: CGFloat = 12.0
    }
}

class SelectDateTVCell: UITableViewCell, UITextFieldDelegate {

    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.font       =      appearance.titleLblFont
        view.textColor  = appearance.titleLblTextColor
        return view
    }()

    lazy private var textField: UITextField = {
        let view = UITextField()
        view.smartInsertDeleteType  = .yes
        view.textColor              = appearance.textFieldTextColor
        view.leftViewMode           = .always
        view.font                   = appearance.textFieldFont
        view.leftView               = self.rightArrowView
        view.addTarget(self, action: #selector(didEventTF), for: .editingDidBegin)
        return view
    }()

    lazy private var tfBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.tfBottomLineBackgroundColor
        return view
    }()

    lazy private var rightArrowView: UIView = {
        let view = UIView(frame: .init(x: 0, y: 0, width: 32, height: 20))
        view.addSubview(self.rightArrowIcon)
        self.rightArrowIcon.snp.remakeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview()
        }
        return view
    }()

    private let datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.backgroundColor = .white
        view.maximumDate = Date()
        return view
    }()

    lazy private var rightArrowIcon: UIImageView = {
        let view = UIImageView(frame: .init(x: 0, y: 0, width: 32, height: 20))
        view.image = appearance.rightArrowViewImage
        view.contentMode = .scaleAspectFit
        return view
    }()

    // MARK: Properties
    var delegate: SelectDateTVCellDelegate?
    private let appearance = Appearance()
    private var viewModel: RegisterVM?

    var field: RegisterField? {
        didSet {
            guard let field = field else { return }
            updateView(field)
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
    func setup(_ viewModel: RegisterVM, _ field: RegisterField) {
        self.viewModel = viewModel
        self.field = field
        self.endEditing(true)
    }

    // MARK: -- private methods
    private func updateView(_ field: RegisterField) {
        self.titleLbl.text = field.type.rawValue
        self.textField.placeholder = field.placeholder
        self.textField.text = (field.value as? String) ?? ""
    }

    @objc private func didEventTF() {
        self.delegate?.didTFSelectDateEvent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup UI
private extension SelectDateTVCell {

    private func setupUI() {
        self.selectionStyle = appearance.cellSelectioStyle

        contentView.addSubview(titleLbl)
        contentView.addSubview(textField)
        textField.delegate = self
        textField.inputAccessoryView = self.makeToolbar()
        textField.inputView = self.makeDatePicker()

        contentView.addSubview(tfBottomLine)
        setConstraints()
    }

    func makeToolbar() -> UIToolbar {
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Готово",
                                         style: .plain,
                                         target: self,
                                         action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                          target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Отмена",
                                           style: .plain,
                                           target: self,
                                           action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        return toolbar
    }

    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyy"
        self.textField.text = formatter.string(from: datePicker.date)

        formatter.dateFormat = "yyyy-MM-dd"
        self.field?.value = formatter.string(from: datePicker.date)
        viewModel?.setValue(field!)
        self.endEditing(true)
    }

    @objc func cancelDatePicker(){
        self.endEditing(true)
    }

    func makeDatePicker() -> UIDatePicker {
        self.datePicker.datePickerMode = .date
        self.datePicker.locale = Locale.init(identifier: "ru-Ru")
        if #available(iOS 13.4, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
            self.datePicker.sizeToFit()
        }
        return self.datePicker
    }

    private func setConstraints() {
        self.setupTFBottomLine()
    }

    func setupTFBottomLine() {
        self.tfBottomLine.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.tfBottomLineWidth)
            maker.height.equalTo(1)
            maker.bottom.equalTo(self.contentView.snp.bottom)
                .offset(-appearance.tfBottomLineBottomMargin)
        }

        self.setupTextFieldMaking()
    }

    func setupTextFieldMaking() {
        self.textField.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(appearance.textFieldWidth)
            maker.height.equalTo(appearance.textFieldHeight)
            maker.bottom.equalTo(self.tfBottomLine.snp.top)
        }

        self.setupTitleLblMaking()
    }

    func setupTitleLblMaking() {
        self.titleLbl.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(self.contentView.snp.top)
            maker.width.equalTo(appearance.titleWidth)
            maker.bottom.equalTo(self.textField.snp.top)
                .offset(-appearance.titleBottomMargin)
        }
    }
}
