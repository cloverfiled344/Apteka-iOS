//
//  PaymetSelectionTVCell.swift
//  Infoapteka
//
//

import UIKit

extension PaymetSelectionTVCell {
    struct Appearance {
        let cellSelectioStyle: UITableViewCell.SelectionStyle = .none

        let titleLblTextColor: UIColor = Asset.secondaryGray3.color
        let titleLblFont: UIFont = FontFamily.Inter.semiBold.font(size: 13)
        let titleWidth: CGFloat = Constants.screenWidth - 40
        let titleBottomMargin: CGFloat = 4.0

        let elsomValue: String = "Элсом"
        let visaValue: String = "VISA"
    }
}

class PaymetSelectionTVCell: UITableViewCell {

    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.font =      appearance.titleLblFont
        view.textColor = appearance.titleLblTextColor
        return view
    }()

//    lazy private var visaView: CheckBoxWithTitle = {
//        let view = CheckBoxWithTitle()
//        view.setup(false, appearance.visaValue)
//        return view
//    }()

    lazy private var elsomView: CheckBoxWithTitle = {
        let view = CheckBoxWithTitle()
        view.setup(false, appearance.elsomValue)
        return view
    }()

    private var appearance = Appearance()
    private var viewModel: CheckoutVM?
    private var field: CheckoutField? {
        didSet {
            guard let field = self.field else { return }
            self.titleLbl.text = field.type.rawValue
            guard let value = field.value as? PayMethod else { return }
            switch value {
            case .elsom: didTappedOnElsomView()
            case .visa: didTappedOnVisaView()
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        contentView.addSubview(titleLbl)
        titleLbl.snp.remakeConstraints { (maker) in
            maker.left.equalTo(contentView.snp.left).offset(20.0)
            maker.right.equalTo(contentView.snp.right).offset(-20.0)
            maker.top.equalTo(contentView.snp.top)
        }

//        contentView.addSubview(visaView)
//        let tapOnVisaView = UITapGestureRecognizer(target: self, action: #selector(didTappedOnVisaView))
//        visaView.isUserInteractionEnabled = true
//        visaView.addGestureRecognizer(tapOnVisaView)
//        visaView.snp.remakeConstraints { (maker) in
//            maker.left.equalTo(contentView.snp.left)
//            maker.right.equalTo(contentView.snp.right)
//            maker.top.equalTo(titleLbl.snp.bottom).offset(16.0)
//            maker.height.equalTo(24.0)
//        }

        contentView.addSubview(elsomView)
        let tapOnElsomView = UITapGestureRecognizer(target: self, action: #selector(didTappedOnElsomView))
        elsomView.isUserInteractionEnabled = true
        elsomView.addGestureRecognizer(tapOnElsomView)
        elsomView.snp.remakeConstraints { (maker) in
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
            maker.top.equalTo(titleLbl.snp.bottom).offset(16.0)
            maker.height.equalTo(24.0)
            maker.bottom.equalTo(contentView.snp.bottom).offset(-32.0)
        }
    }

    // MARK: -- public methods
    func setup(_ viewModel: CheckoutVM,
               _ field: CheckoutField) {
        self.viewModel = viewModel
        self.field = field
    }
    
    @objc private func didTappedOnVisaView() {
        switchCheckBox(true, false)
    }

    @objc private func didTappedOnElsomView() {
        switchCheckBox(false, true)
    }

    private func switchCheckBox(_ isVisa: Bool, _ isElsom: Bool) {
        elsomView.isChecked = isElsom
//        visaView.isChecked = isVisa
        guard var field = field else { return }
        field.value = isVisa ? PayMethod.visa : PayMethod.elsom
        viewModel?.setValue(field)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
