//
//  Basket.swift
//  Infoapteka
//
//

import Foundation
import ObjectMapper

struct Basket: Mappable {

    var id         : Int?
    var carts      : [Cart] = []
    var totalCartItems : Int?
    var totalCart      : Int?

    init(map: Map) {}

    mutating func mapping(map: Map) {
        id    <- map["id"]
        carts <- map["cart_items"]
        totalCartItems <- map["get_cart_total_items"]
        totalCart      <- map["get_cart_total"]
    }
}

struct Cart: Mappable {

    var id       : Int?
    var quantity : Int?
    var drug     : Drug?

    init(map: Map) {}

    mutating func mapping(map: Map) {
        id       <- map["id"]
        quantity <- map["quantity"]
        drug     <- map["drug"]
    }
}
