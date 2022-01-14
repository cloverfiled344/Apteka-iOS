//
//  MyProductAPI.swift
//  Infoapteka
//
//  
//

import UIKit
import ObjectMapper

final class MyDrugsAPI {
    
    func getMyDrug(_ completion: @escaping((DrugResult) -> Void)) {
        var myProductPage: (DrugResult) = (.init(map: .init(mappingType: .fromJSON, JSON: [:])))
        self.paginateDrugs(1, true) { drugResult in
            myProductPage = drugResult
            completion(myProductPage)
        }
    }
    
    func paginateDrugs(_ page: Int,
                       _ withAnimation: Bool = false,
                       _ completion: @escaping((DrugResult) -> Void)) {
        let path = Global.pathFor(key: "account")
        APIManager.instance.GET(withAnimation: withAnimation, path: "\(path)drug/?page=\(page)") { [weak self] success, json, error in
            guard self != nil , let drugResult = Mapper<DrugResult>().map(JSONObject: json.dictionaryObject) else {
                completion(.init(map: .init(mappingType: .fromJSON, JSON: [:])))
                return
            }
            completion(drugResult)
        }
    }

    func getDrug(_ byID: Int,
                 _ completion: @escaping((Drug?) -> Void)) {
        let path = Global.pathFor(key: "create-drug")
        APIManager.instance.GET(path: "\(path)\(byID)/") { success,
                                                           json,
                                                           error in
            guard let drug = Mapper<Drug>().map(JSONObject: json.dictionaryObject) else {
                completion(nil)
                return
            }
            completion(drug)
        }
    }

    func removeDrug(_ id: Int, _ completion: @escaping((Bool) -> Void)) {
        let path = Global.pathFor(key: "account")
        APIManager.instance.DELETE(path: "\(path)drug/\(id)/", parameters: nil) { success, json, error in
            completion(success)
        }
    }
}

