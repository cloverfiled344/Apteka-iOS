//
//  DrugResultAPI.swift
//  Infoapteka
//
//  
//

import UIKit
import ObjectMapper

final class FavouritesAPI {
    
    func getFavourites(_ page: Int?,
                       _ withAnimation: Bool,
                       _ completion: @escaping((DrugResult?, String?) -> Void)) {
        let path = Global.pathFor(key: "account")
        APIManager.instance.GET(withAnimation: withAnimation,
                                path: path + "favorite/?page=\(page ?? 1)") { success,
                                                                              json,
                                                                              error in
            guard error == nil else {
                completion(nil, error?.localizedDescription)
                return
            }
            guard let favourites = Mapper<DrugResult>().map(JSONObject: json.dictionaryObject) else {
                completion(nil, "")
                return
            }
            completion(favourites, nil)
        }
    }
    
    func addToFavourties() {
        
    }
}
