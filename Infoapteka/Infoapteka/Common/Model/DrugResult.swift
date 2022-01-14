//
//  HomeResult.swift
//  Infoapteka
//
//  
//

import UIKit
import ObjectMapper

struct DrugResult: Mappable {

    var count    : Int?
    var next     : Int?
    var previous : Int?
    var results  : [Drug] = []

    init(map: Map) {}

    mutating func mapping(map: Map) {
        count    <- map["count"]
        next     <- map["next"]
        previous <- map["previous"]
        results  <- map["results"]
    }
}

struct Drug: Mappable {
    var id              : Int?
    var name            : String?
    var price           : Int?
    var image           : String?
    var logo            : String?
    var isFavorites     : Bool              = false
    var isCart          : Bool              = false
    var owner           : Profile?
    var ownerName       : String?

    var isOwner         : Bool = false
    var isAvailable     : Bool = false
    var drugOwner       : String?
    var status          : DrugStatus        = .approved

    // MARK: DrugDetail
    var availability    : String?
    var addedByAdmin  : Bool?
    var instructions    : [DrugDetailInstruction] = []
    var instructionText : String?
    var images          : [DrugDetailImage] = []
    var similar         : [Drug]            = []
    var instructTitle   : String            = L10n.instruction
    
    // MARK: DrugUpdate
    var сategory: Category?
    var desc: String?

    
    init(map: Map) {}

    mutating func mapping(map: Map) {

        id              <- map["id"]
        name            <- map["name"]
        price           <- map["price"]
        image           <- map["image"]
        logo            <- map["logo"]
        isFavorites    <- map["in_favorites"]
        isCart         <- map["in_cart"]
        isOwner         <- map["is_owner"]
        isAvailable     <- map["is_available"]
        owner           <- map["owner"]
        ownerName           <- map["owner"]

        drugOwner  <- map["owner"]
        status        <- map["status"]
        
        сategory        <- map["category"]
        availability    <- map["availability"]
        addedByAdmin  <- map["added_by_admin"]
        instructions    <- map["instructions"]
        instructionText <- map["instruction_txt"]
        images          <- map["images"]
        similar         <- map["similar"]

        сategory        <- map["сategory"]
        desc <- map["instruction_txt"]
    }
}

struct Instruction {
    var image       : UIImage
    var title       : String
    var subtitle    : String
    var link        : String
    var type        : InstructionType
}

struct DrugDetailImage: Mappable {
    
    var id:      Int?
    var image:   String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id    <- map["id"]
        image <- map["image"]
    }
}

struct DrugDetailInstruction: Mappable {
    
    var instruction: String?
    var description: String?
    var isSelected:  Bool    = false
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        instruction <- map["instruction"]
        description <- map["description"]
    }
}
