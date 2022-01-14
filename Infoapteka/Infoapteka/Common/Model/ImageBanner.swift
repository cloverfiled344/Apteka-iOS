//
//  ImageBanner.swift
//  Infoapteka
//
//

import Foundation
import ObjectMapper

struct ImageBanner: Mappable {

    var id    : Int?
    var image : String?
    var link  : String?

    init(map: Map) {}

    mutating func mapping(map: Map) {
        id    <- map["id"]
        image <- map["image"]
        link  <- map["link"]
    }
}
