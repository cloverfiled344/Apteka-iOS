//
//  AppVersion.swift
//  Infoapteka
//
//

import Foundation
import ObjectMapper

class AppVersion: NSObject, Mappable {

    var version: String = "0.0.1"
    var buildNumber: Int = 1
    var forceUpdate: Bool = false

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        version <- map["ios_version"]
        buildNumber <- map["ios_build_number"]
        forceUpdate <- map["ios_force_update"]
    }
}
