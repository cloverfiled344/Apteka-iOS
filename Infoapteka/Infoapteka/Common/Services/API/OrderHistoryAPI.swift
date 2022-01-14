//
//  OrderHistoryAPI.swift
//  Infoapteka
//
//

import Foundation
import ObjectMapper

final class OrderHistoryAPI {

    func fetchOrderHistory(_ completion: @escaping(([OrderHistory]?) -> Void)) {
        let path = Global.pathFor(key: "order")
        APIManager.instance.GET(path: path) { success, json, error in
            guard error == nil else {
                completion(nil)
                return
            }
            guard error == nil, let orders = Mapper<OrderHistory>().mapArray(JSONObject: json.arrayObject) else {
                completion([])
                return
            }
            completion(orders)
        }
    }

    func fetchOrderHistory(_ id: Int, _ completion: @escaping((OrderHistory?) -> Void)) {
        let path = Global.pathFor(key: "order")
        APIManager.instance.GET(path: "\(path)\(id)/") { success, json, error in
            guard error == nil else {
                completion(nil)
                return
            }
            guard error == nil, let orders = Mapper<OrderHistory>().map(JSONObject: json.dictionaryObject) else {
                completion(nil)
                return
            }
            completion(orders)
        }
    }
}
