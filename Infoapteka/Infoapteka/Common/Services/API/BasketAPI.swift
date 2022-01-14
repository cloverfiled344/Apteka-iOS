//
//  c.swift
//  Infoapteka
//
//

import Foundation
import ObjectMapper

final class BasketAPI {

    func getBasket(_ completion: @escaping((Basket?) -> Void)) {
        let path = Global.pathFor(key: "cart")
        APIManager.instance.GET(path: path) { success, json, error in
            guard error == nil else {
                completion(nil)
                return
            }
            guard let basket = Mapper<Basket>().map(JSONObject: json.dictionaryObject) else {
                completion(nil)
                return
            }
            completion(basket)
        }
    }

    func deleteCart(_ cart: Cart,
                    _ completion: @escaping((Bool) -> Void)) {
        let path = Global.pathFor(key: "cart")
        APIManager.instance.DELETE(path: "\(path)\(cart.drug?.id ?? 0)/delete/",
                                   parameters: nil) { success,
                                                      json,
                                                      error in
            completion(success)
        }
    }

    func changeQuantity(_ cart: Cart,
                        _ quantity: Int,
                        _ completion: @escaping((Bool) -> Void)) {
        let path = Global.pathFor(key: "cart")
        let state = (cart.quantity ?? 0) < quantity ? "add" : "remove"
        APIManager.instance.POST(path: "\(path)\(cart.drug?.id ?? 0)/\(state)/",
                                   parameters: nil) { success,
                                                      json,
                                                      error in
            completion(success)
        }
    }

    func changeFavourite(_ drug: Drug,
                         _ isFavourite: Bool,
                         _ completion: @escaping((Bool) -> Void)) {
        let path = Global.pathFor(key: "account-favorite")
        if isFavourite {
            APIManager.instance.POST(path: "\(path)\(drug.id ?? 0)/add/") { success,
                                                                            json,
                                                                            error in
                completion(success)
            }
        } else {
            APIManager.instance.DELETE(path: "\(path)\(drug.id ?? 0)/remove/",
                                       parameters: nil) { success,
                                                          json,
                                                          error in
                completion(success)
            }
        }
    }
}
