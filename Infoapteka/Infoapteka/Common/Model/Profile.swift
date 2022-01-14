//
//  Profile.swift
//  Infoapteka
//
//

import Foundation
import ObjectMapper

struct Profile: Mappable {

    var id                  : Int?
    var firstName           : String?
    var phoneNumber         : String?
    var middleName          : String?
    var lastName            : String?
    var birthDate           : String?
    var city                : City?
    var avatar              : String?
    var address             : String?
    var hasNotification     : Bool?
    var moderationStatus    : ModerationStatus?
    var role                : UserOptionsType?
    var certificates        : [Certificate] = []

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["first_name"]
        middleName <- map["middle_name"]
        lastName <- map["last_name"]
        phoneNumber <- map["phone"]
        birthDate <- map["birth_date"]
        city <- map["city"]
        avatar <- map["avatar"]
        address <- map["address"]
        certificates <- map["certificates"]
        hasNotification <- map["has_notification"]
        role <- map["role"]
        moderationStatus <- map["status"]
    }
}

struct Certificate: Mappable {

    var id    : Int?
    var url   : String?
    var image : Image?

    init(_ image: Image) {
        self.image = image
    }
    
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id <- map["id"]
        url <- map["image"]
    }
}


