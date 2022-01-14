//
//  CheckoutTVManager.swift
//  Infoapteka
//
//

import UIKit

protocol CheckoutTVManagerDelegate {
    func didTappedAddBtn()
    func deletePhone(_ phoneNumber: PhoneNumber)
    func didTappedSelectAddresOnMapTF(_ field: CheckoutField)
    func didTappedOrderBtn()
    func pushToPrivacyPolicy()
}

class CheckoutTVManager: NSObject {

    // MARK: UI Components

    private var viewModel: CheckoutVM
    var delegate: CheckoutTVManagerDelegate?

    init(_ viewModel: CheckoutVM) {
        self.viewModel = viewModel
    }

    func setup(complation: @escaping () -> ()) {
        viewModel.getFields(complation)
    }
}

extension CheckoutTVManager: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.endEditing(true)
        let field = viewModel.getField(indexPath.row)
        if field.type == .district { delegate?.didTappedSelectAddresOnMapTF(field) }
     }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        makeFieldCell(tableView, cellForRowAt: indexPath)
    }

    private func makeFieldCell(_ tableView: UITableView,
                               cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = viewModel.getField(indexPath.row)
        var cell: UITableViewCell = UITableViewCell()
        switch field.type {
        case .name, .surname, .deliveryAddress:
            cell = tableView.dequeueReusableCell(CheckoutSimpleTFTVCell.self,
                                                 indexPath: indexPath)
            (cell as? CheckoutSimpleTFTVCell)?.setup(viewModel, field)
            cell.alpha = 0
        case .phones:
            cell = tableView.dequeueReusableCell(PhoneNumbersTVCell.self,
                                                 indexPath: indexPath)
            (cell as? PhoneNumbersTVCell)?.setup(viewModel, field)
            (cell as? PhoneNumbersTVCell)?.delegate = self
            cell.alpha = 0
        case .district:
            cell = tableView.dequeueReusableCell(SelectDistrictTVCell.self,
                                                 indexPath: indexPath)
            (cell as? SelectDistrictTVCell)?.setup(viewModel, field)
            cell.alpha = 0
        case .comment:
            cell = tableView.dequeueReusableCell(CommentTVCell.self,
                                                 indexPath: indexPath)
            (cell as? CommentTVCell)?.setup(viewModel, field)
            cell.alpha = 0
        case .paymentSelection: 
            cell = tableView.dequeueReusableCell(PaymetSelectionTVCell.self,
                                                 indexPath: indexPath)
            (cell as? PaymetSelectionTVCell)?.setup(viewModel, field)
            cell.alpha = 0
        }
        UIView.animate(withDuration: 0.2, delay: 0.02 * Double(indexPath.row), animations: {
            cell.alpha = 1
        })
        return cell
    }

    func makeTableViewFooter(_ tableView: UITableView) -> UIView? {
        guard viewModel.profile != nil else { return .init(frame: .zero) }
        let footer = tableView.dequeueReusableHeaderFooter(CheckoutTVFooter.self)
        if let basket = viewModel.basket {
            footer.setup(basket)
        } else if let orderHistory = viewModel.orderHistory {
            footer.setup(orderHistory)
        }
        footer.delegate = self
        footer.frame = .init(x: 0, y: 0, width: tableView.frame.size.width, height: 296.0)
        footer.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 1, animations: {
            footer.alpha = 1
        })
        return footer
    }
}

extension CheckoutTVManager: PhoneNumbersTVCellDelegate {
    func deletePhone(_ phoneNumber: PhoneNumber) {
        delegate?.deletePhone(phoneNumber)
    }

    func didTappedAddBtn() {
        delegate?.didTappedAddBtn()
    }
}

extension CheckoutTVManager: CheckoutTVFooterDelegate {
    func didTappedOnPrivacyPolicyBtn() {
        delegate?.pushToPrivacyPolicy()
    }
    
    func didTappedOrderBtn() {
        delegate?.didTappedOrderBtn()
    }
}
