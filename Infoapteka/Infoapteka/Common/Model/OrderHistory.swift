//
//  OrderHistory.swift
//  Infoapteka
//
//

import ObjectMapper
import UIKit

struct OrderHistory: Mappable {
    var id     : Int?
    var orderID: String?
    var orders : [Order] = []
    var ordersCount : Int?
    var ordersPrice : Int?
    var payMethod   : PayMethod?
    var status   : OrderStatus?
    var createdAt: String?
    var isExpanded: Bool = false

    var phones: [PhoneNumber]?
    var firstName: String?
    var lastName : String?
    var address: String?
    var comment: String?
    var district: City?

    init(map: Map) {}

    mutating func mapping(map: Map) {
        id      <- map["id"]
        orderID <- map["order_id"]
        orders  <- map["order_items"]
        ordersCount <- map["get_order_total_items"]
        ordersPrice <- map["get_order_total"]
        status    <- map["status"]
        createdAt <- map["created_at"]
        payMethod <- map["pay_method"]

        phones <- map["phones"]
        firstName <- map["first_name"]
        lastName  <- map["last_name"]
        address  <- map["address"]
        comment  <- map["comment"]
        district <- map["district"]
    }
}

struct Order: Mappable {
    var drug    : Drug?
    var quantity: Int?

    init(map: Map) {}

    mutating func mapping(map: Map) {
        drug     <- map["drug"]
        quantity <- map["quantity"]
    }
}


enum PayMethod: String {
    case visa
    case elsom
}
