//
//  PhoneNumbersTVCell.swift
//  Infoapteka
//
//

import UIKit

protocol PhoneNumbersTVCellDelegate {
    func didTappedAddBtn()
    func deletePhone(_ phoneNumber: PhoneNumber)
}

class PhoneNumbersTVCell: UITableViewCell {

    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.font = FontFamily.Inter.regular.font(size: 14.0)
        view.textColor = Asset.secondaryGray.color
        view.text = "Добавить номер телефона"
        return view
    }()

    lazy private var addBtn: UIButton = {
        let view = UIButton()
        view.setImage(Asset.icPlus.image, for: .normal)
        view.backgroundColor = Asset.mainGreen.color
        view.layer.cornerRadius = 10.0
        return view
    }()

    var delegate: PhoneNumbersTVCellDelegate?

    func setup(_ viewModel: CheckoutVM,
               _ field: CheckoutField) {
        selectionStyle = .none
        contentView.subviews.forEach { ($0 as? PhoneNumberView)?.removeFromSuperview() }
        guard let phoneNumbers = field.value as? [PhoneNumber] else {
            viewModel.createPhoneTF()
            addNewField(viewModel, field, .init(phone: "", id: 0), 0, 0)
            return
        }

        for (index, phoneNumber) in phoneNumbers.enumerated() {
            addNewField(viewModel, field, phoneNumber, index, phoneNumbers.endIndex - 1)
        }
    }

    fileprivate func addNewField(_ viewModel: CheckoutVM,
                                 _ field: CheckoutField,
                                 _ phoneNumber: PhoneNumber,
                                 _ index: Int,
                                 _ endIndex: Int) {
        let view = PhoneNumberView()
        view.delegate = self
        view.setup(viewModel, phoneNumber, field)
        contentView.addSubview(view)
        view.snp.remakeConstraints { make in
            make.height.equalTo(70.0)
            make.left.right.equalToSuperview()
            let topMargin: CGFloat = CGFloat(index) * 70.0
            make.top.equalTo(contentView.snp.top).offset(topMargin)
            if index == endIndex {
                make.bottom.equalTo(contentView.snp.bottom).offset(-60.0)
                setupAddBtn()
            }
        }
    }

    private func setupAddBtn() {
        contentView.addSubview(addBtn)
        addBtn.addTarget(self, action: #selector(didTappedAddBtn), for: .touchUpInside)
        addBtn.snp.remakeConstraints { make in
            make.right.equalTo(contentView.snp.right).offset(-20.0)
            make.height.width.equalTo(20.0)
            make.bottom.equalTo(contentView.snp.bottom).offset(-24.0)
        }

        contentView.addSubview(titleLbl)
        titleLbl.snp.remakeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(20.0)
            make.right.equalTo(addBtn.snp.left).offset(-20.0)
            make.centerY.equalTo(addBtn.snp.centerY)
        }
    }

    @objc private func didTappedAddBtn() {
        addBtn.pulsate()
        delegate?.didTappedAddBtn()
    }
}

extension PhoneNumbersTVCell: PhoneNumberViewDelegate {
    func deletePhone(_ phoneNumber: PhoneNumber) {
        delegate?.deletePhone(phoneNumber)
    }
}

