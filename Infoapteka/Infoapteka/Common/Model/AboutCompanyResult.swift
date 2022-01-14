//
//  AboutCompanyResult.swift
//  Infoapteka
//
//  
//

import Foundation
import ObjectMapper

struct AboutCompanyResult: Mappable {
    var id: Int?
    var title: String?
    var desc: String?
    var email: String?
    var address: String?
    var latitude: String?
    var longitude: String?
    var aboutSocials: [AboutSocials] = []
    var phones: [String] = []
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        id              <- map["id"]
        title           <- map["title"]
        desc            <- map["description"]
        email           <- map["email"]
        address         <- map["address"]
        latitude        <- map["latitude"]
        longitude       <- map["longitude"]
        aboutSocials    <- map["about_socials"]
        phones          <- map["phones"]
    }
}

struct AboutSocials: Mappable {
    var id: Int?
    var logo: String?
    var link: String?
    var title: String?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        id      <- map["id"]
        logo    <- map["logo"]
        link    <- map["link"]
        title   <- map["title"]
    }
}

struct AboutHeaderText {
    var type: AboutCompanyType
}
