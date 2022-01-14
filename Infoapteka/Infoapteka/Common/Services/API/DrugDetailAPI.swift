//
//  DrugDetailAPI.swift
//  Infoapteka
//
//  
//

import UIKit
import ObjectMapper

final class DrugDetailAPI {
    
    func getDrugDetail(_ id: Int, _ type: DrugDetailType, _ completion: @escaping((Drug?, Bool) -> Void)) {
        let path = type == .other ? Global.pathFor(key: "drug") : Global.pathFor(key: "create-drug")
        APIManager.instance.GET(path: "\(path)\(id)/") { success, json, error in
            guard error == nil else {
                completion(nil, success)
                return
            }
            guard let drugDetail = Mapper<Drug>().map(JSONObject: json.dictionaryObject) else {
                completion(nil, success)
                return
            }
            completion(drugDetail, success)
        }
    }
    
    func addToBasket(_ drug: Drug, _ id: Int, _ completion: @escaping(Bool) -> Void) {
        let path = Global.pathFor(key: "cart")
        let state = drug.isCart ? "remove" : "add"
        APIManager.instance.POST(path: "\(path)\(id)/\(state)/") { success, json, error in
            completion(success)
        }
    }
}
