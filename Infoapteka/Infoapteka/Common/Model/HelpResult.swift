//
//  HelpResult.swift
//  Infoapteka
//
//  
//

import UIKit
import ObjectMapper

struct HelpResult: Mappable{
    
    var id: Int?
    var question: String?
    var answer: String?
    var isExpandable: Bool = false
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        question <- map["question"]
        answer <- map["answer"]
    }
}

struct PrivacyPolicy: Mappable {
    var id: Int?
    var pdfFile: String?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        pdfFile <- map["pdf_file"]
    }
}
