//
//  Category.swift
//  Infoapteka
//
//

import Foundation
import ObjectMapper

struct Category: Mappable {

    var id          : Int?
    var title       : String = "Категории"
    var logo        : String?
    var children    : [Category] = []
    var type        : CategoryCellType = .category

    init(map: Map) {}

    mutating func mapping(map: Map) {
        id          <- map["id"]
        title       <- map["name"]
        logo        <- map["logo"]
        children    <- map["children"]
    }
}
