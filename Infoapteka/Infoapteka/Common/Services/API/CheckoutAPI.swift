//
//  CheckoutAPI.swift
//  Infoapteka
//
//

import Foundation
import Alamofire
import ObjectMapper

final class CheckoutAPI {

    func getFields(_ profile: Profile?,
                   _ _orderHistory: OrderHistory?,
                   _ completion: @escaping(([CheckoutField]) -> Void)) {
        if let orderHistory = _orderHistory {
            completion([
                .init(placeholder: L10n.userNamePlaceholder, type: .name, value: profile?.firstName ?? ""),
                .init(placeholder: L10n.userSurnamePlaceholder, type: .surname, value: profile?.lastName ?? ""),
                .init(placeholder: L10n.phoneNumber, type: .phones,
                      value: [PhoneNumber(phone: profile?.phoneNumber ?? "", isValidNumber: true, id: 0)]),
                .init(placeholder: "Выбор города*", type: .district, value: orderHistory.district),
                .init(placeholder: "Введите адрес", type: .deliveryAddress, value: orderHistory.address ?? ""),
                .init(placeholder: "Введите текст", type: .comment, value: orderHistory.comment ?? ""),
                .init(placeholder: "", type: .paymentSelection, value: orderHistory.payMethod ?? ""),
            ])
        } else {
            completion([
                .init(placeholder: L10n.userNamePlaceholder, type: .name, value: profile?.firstName ?? ""),
                .init(placeholder: L10n.userSurnamePlaceholder, type: .surname, value: profile?.lastName ?? ""),
                .init(placeholder: L10n.phoneNumber, type: .phones,
                      value: [PhoneNumber(phone: profile?.phoneNumber ?? "", isValidNumber: true, id: 0)]),
                .init(placeholder: "Выбор города*", type: .district),
                .init(placeholder: "Введите адрес", type: .deliveryAddress),
                .init(placeholder: "Введите текст", type: .comment),
                .init(placeholder: "", type: .paymentSelection, value: PayMethod.elsom),
            ])
        }
    }

    func checkoutOrder(_ parameters: Parameters,
                       _ completion: @escaping((Bool, String?) -> Void)) {
        let path = Global.pathFor(key: "order")
        APIManager.instance.POST(path: "\(path)create_or_update/", parameters: parameters) { success,
                                                                       json,
                                                                       error in
            guard error == nil, let order = Mapper<OrderHistory>().map(JSONObject: json.dictionaryObject) else {
                completion(false, nil)
                return
            }
            switch order.payMethod {
            case .elsom:
                guard let orderID = order.id else {
                    completion(success, nil)
                    return
                }
                self.elsomPayment(orderID) { link in completion(success, link) }
            case .visa, .none, .some(_): completion(success, nil)
            }
        }
    }

    private func elsomPayment(_ orderID: Int,
                              _ completion: @escaping((String?) -> Void)) {
        let path = Global.pathFor(key: "elsom_payment")
        APIManager.instance.POST(path: path, parameters: ["order_id": orderID]) { success,
                                                                                  json,
                                                                                  error in
            completion(json["link"].string)
        }
    }

    func fetchProfile(completion: @escaping (Profile?, String?) -> ())  {
        let path = Global.pathFor(key: "account-data")
        APIManager.instance.GET(path: path) { success,
                                              json,
                                              error in
            guard error == nil, let profile = Mapper<Profile>().map(JSONObject: json.dictionaryObject) else {
                completion(nil, "\(error?.localizedDescription ?? "Ошибка при разборе профиля!")")
                return
            }
            completion(profile, nil)
        }
    }
}
