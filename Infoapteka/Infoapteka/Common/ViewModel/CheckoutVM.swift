//
//  CheckoutVM.swift
//  Infoapteka
//
//

import Foundation
import Alamofire

final class CheckoutVM {

    private var _basket: Basket?
    private var _orderHistory: OrderHistory?
    private var _profile: Profile?
    private var fields: [CheckoutField] = []

    init(_ _basket: Basket) {
        self._basket = _basket
    }

    init(_ orderHistory: OrderHistory) {
        self._orderHistory = orderHistory
    }

    func fetchProfile(completion: @escaping () -> ())  {
        API.checkoutAPI.fetchProfile { [weak self] profile, error in
            guard let self = self else { return }
            self._profile = profile
            completion()
        }
    }

    func getFields(_ completion: @escaping(() -> Void)) {
        API.checkoutAPI.getFields(profile, _orderHistory) { fields in
            self.fields = fields
            completion()
        }
    }

    func checkoutOrder(_ completion: @escaping((Bool?, String?) -> Void)) {
        let errorMessage = checkEmptyFields()
        if errorMessage.isEmpty {
            var parameters: Parameters = [
                "phones"     : getPhone(),
                "first_name" : getValue(.name),
                "last_name"  : getValue(.surname),
                "address"    : getValue(.deliveryAddress),
                "district"   : getDistrictID(),
                "comment"    : getValue(.comment),
                "pay_method" : getPayMethod()
            ]

            if let cartId = basket?.id {
                parameters["cart_id"] = cartId
            } else if let orderHistory = _orderHistory, let id = orderHistory.id {
                parameters["id"] = id
            } else {
                BannerTop.showToast(message: "Идентификационный номер данного заказа отсутствует!",
                                    and: .systemRed)
                completion(nil, nil)
            }
            API.checkoutAPI.checkoutOrder(parameters) { success, link in
                completion(success, link)
            }
        } else {
            BannerTop.showToast(message: "Заполните следующие поля:\(errorMessage)", and: .systemRed)
            completion(nil, nil)
        }
    }

    var numberOfRowsInSection: Int {
        get { fields.count }
    }

    func setValue(_ field: CheckoutField) {
        fields.indices.forEach { fields[$0].type == field.type ? (fields[$0].value = field.value) : nil }
    }

    func setPhone(_ phoneNumber: PhoneNumber) {
        var phoneField = fields.filter { $0.type == .phones }.first
        guard var phones = phoneField?.value as? [PhoneNumber], !phones.isEmpty else {
            phoneField?.value = [phoneNumber]
            return
        }
        phones.indices.forEach {
            if (phones[$0].id ?? 0) == (phoneNumber.id ?? 0) {
                phones[$0].phone = phoneNumber.phone
                phones[$0].isValidNumber = phoneNumber.isValidNumber
            }
        }
        fields.indices.forEach { fields[$0].type == .phones ? (fields[$0].value = phones) : nil }
    }

    func createPhoneTF() {
        let phoneField = fields.filter { $0.type == .phones }.first
        guard var phones = phoneField?.value as? [PhoneNumber], !phones.isEmpty else {
            fields.indices.forEach {
                fields[$0].type == .phones ? (fields[$0].value = [PhoneNumber(phone: "", id: 0)]) : nil
            }
            return
        }
        if phones.filter({ ($0.phone?.isEmpty ?? true) || !$0.isValidNumber }).isEmpty {
            phones.append(PhoneNumber(phone: "", id: phones.endIndex))
            fields.indices.forEach { fields[$0].type == .phones ? (fields[$0].value = phones) : nil }
        } else {
            BannerTop.showToast(message: "У вас есть поле с недействительным номером", and: .systemRed)
        }
    }

    func deletePhone(_ phoneNumber: PhoneNumber) {
        let phoneField = fields.filter { $0.type == .phones }.first
        guard var phones = phoneField?.value as? [PhoneNumber], !phones.isEmpty else {
            return
        }
        phones.removeAll { ($0.id ?? 0) == (phoneNumber.id ?? 0) }
        fields.indices.forEach { fields[$0].type == .phones ? (fields[$0].value = phones) : nil }
    }

    func getField(_ by: Int) -> CheckoutField {
        fields.count > by ? fields[by] : .init(placeholder: "", type: .name)
    }

    var basket: Basket? {
        get { return _basket }
    }

    func getPhone() -> [Dictionary<String, Any>] {
        let phoneNumbers = (fields.filter { $0.type == .phones }.first?.value as? [PhoneNumber] ?? [])
        var arrayOfDict: [Dictionary<String, Any>] = []
        phoneNumbers.forEach {
            arrayOfDict.append(["phone": $0.phone ?? ""])
        }
        return arrayOfDict
    }

    func getDistrictID() -> String {
        if let district = (fields.filter { $0.type == .district }.first?.value as? City) {
            return "\(district.id ?? 0)"
        } else {
            return "0"
        }
    }

    func getPayMethod() -> String { (fields.filter { $0.type == .paymentSelection }.first?.value as? PayMethod)?.rawValue ?? "" }
    func getValue(_ type: CheckoutFieldType) -> String {
        return (fields.filter { $0.type == type }.first?.value as? String ?? "")
    }

    func checkEmptyFields() -> String {
        var errorMessage: String = ""
        fields.forEach {
            switch $0.type {
            case .name, .surname, .deliveryAddress, .comment:
                if $0.value == nil || (($0.value as? String)?.isEmpty ?? true) || (($0.value as? String)?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                    errorMessage.append(" \($0.type.rawValue)")
                }
            case .phones:
                let phones = ($0.value as? [PhoneNumber]) ?? []
                if !phones.filter({ ($0.phone?.isEmpty ?? true) || !$0.isValidNumber }).isEmpty {
                    errorMessage.append(" \($0.type.rawValue)")
                }
            case .district:
                if ($0.value as? City) == nil || (($0.value as? City)?.id == nil) {
                    errorMessage.append(" \($0.type.rawValue)")
                }
            case .paymentSelection:
                if ($0.value as? PayMethod) == nil {
                    errorMessage.append(" \($0.type.rawValue)")
                }
            }
        }
        return errorMessage
    }
    
    // MARK: GET PRIVACY POLISY
    func getProgramRules(_ completion: @escaping((PrivacyPolicy?) -> Void)) {
        API.registerAPI.getPrivacyPolicy { result, errorMessage in
            guard errorMessage == nil else {
                BannerTop.showToast(message: errorMessage ?? "", and: .systemRed)
                completion(nil)
                return
            }
            completion(result)
        }
    }

    var profile: Profile? {
        get { self._profile }
    }

    var orderHistory: OrderHistory? {
        get { self._orderHistory }
    }
}
