//
//  HelpResultAPI.swift
//  Infoapteka
//
//  
//

import UIKit
import ObjectMapper

final class HelpResultAPI {
    
    func getHelpPage(_ completion: @escaping(([HelpResult]?, String?) ->  Void)) {
        let path = Global.pathFor(key: "info")
        APIManager.instance.GET(path: path + "handbook/") { success, json, error in
            guard error == nil else {
                completion(nil, error?.localizedDescription)
                return
            }
            guard let result = Mapper<HelpResult>().mapArray(JSONObject: json.arrayObject) else {
                completion(nil, "")
                return 
            }
            completion(result, nil)
        }
    }
    
}
