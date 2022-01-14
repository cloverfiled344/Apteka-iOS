//
//  CategoriesAPI.swift
//  Infoapteka
//
//

import ObjectMapper

final class CategoriesAPI {

    func fetchCategories(_ completion: @escaping(([Category]) -> Void)) {
        let path = Global.pathFor(key: "drug-categories")
        APIManager.instance.GET(path: path) { success,
                                              json,
                                              error in
            guard error == nil,
                  let categories = Mapper<Category>().mapArray(JSONObject: json.arrayObject) else {
                completion([])
                return
            }
            completion(categories)
        }
    }
}
