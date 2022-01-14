//
//  CitiesAPI.swift
//  Infoapteka
//
//

import Foundation
import ObjectMapper

final class CitiesAPI {

    func fetchCities(_ completion: @escaping(([City]) -> Void)) {
        let path = Global.pathFor(key: "setting-cities")
        APIManager.instance.GET(path: path) { success,
                                              json,
                                              error in
            guard error == nil, let cities = Mapper<City>().mapArray(JSONObject: json.arrayObject) else {
                completion([])
                return
            }
            completion(cities)
        }
    }

    func searchDistricts(_ completion: @escaping(([City]) -> Void)) {
        let path = Global.pathFor(key: "setting-districts")
        APIManager.instance.GET(path: path) { success,
                                              json,
                                              error in
            guard error == nil, let cities = Mapper<City>().mapArray(JSONObject: json.arrayObject) else {
                completion([])
                return
            }
            completion(cities)
        }
    }
}
