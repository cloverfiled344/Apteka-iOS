//
//  City.swift
//  Infoapteka
//
//

import Foundation
import ObjectMapper

struct City: Mappable {

    var id    : Int?
    var title : String?
    var districts: [City] = []

    init(map: Map) {}

    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        districts <- map["districts"]
    }
}
