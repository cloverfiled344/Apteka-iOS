//
//  DrugStoreResult.swift
//  Infoapteka
//
//  
//

import UIKit
import ObjectMapper

struct DrugStoreResult: Mappable {
    
    var count    : Int?
    var next     : Int?
    var previous : Int?
    var results  : [DrugStore] = []

    init(map: Map) {}

    mutating func mapping(map: Map) {
        count    <- map["count"]
        next     <- map["next"]
        previous <- map["previous"]
        results  <- map["results"]
    }
}

struct DrugStore: Mappable {
    
    var id:        Int?
    var image:     String?
    var name:      String?
    var address:   String?
    var isOpen:    Bool   = false
    var distance:  String?
    var latitude:  String?
    var longitude: String?
    
    var workHours: String?
    var phones:    [String] = []
    var images:    [String] = []
    
    init(map: Map) { }
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        image       <- map["image"]
        name        <- map["name"]
        address     <- map["address"]
        isOpen      <- map["is_open"]
        distance    <- map["distance"]
        latitude    <- map["latitude"]
        longitude   <- map["longitude"]
        
        workHours   <- map["working_hours"]
        phones      <- map["phones"]
        images      <- map["images"]
    }
}

