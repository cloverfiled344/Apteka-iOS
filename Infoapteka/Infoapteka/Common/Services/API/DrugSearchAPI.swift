//
//  DrugSearchAPI.swift
//  Infoapteka
//
//

import Foundation
import ObjectMapper
import Alamofire

final class DrugSearchAPI {

    func getOwner(_ profileID: Int,
                  _ completion: @escaping (Profile?) -> ()) {
        let path = Global.pathFor(key: "drug-seller")
        APIManager.instance.GET(path: "\(path)\(profileID)") { success, json, error in
            guard let profile = Mapper<Profile>().map(JSONObject: json.dictionaryObject) else {
                completion(nil)
                return
            }
            completion(profile)
        }
    }

    func search(_ page: Int?,
                _ ownerID: Int?,
                _ categoryID: Int?,
                _ search: String?,
                _ searchFilter: SearchFilter?,
                _ withAnimation: Bool,
                _ completion: @escaping((DrugResult?) -> Void)) {

        var path = Global.pathFor(key: "drug-list")
        path.append("?page=\(page ?? 1)")
        search != nil && (!search!.isEmpty) ? path.append("&search=\(search!)") : nil
        if let searchFilter = searchFilter, let filterType = searchFilter.filterType {
            switch filterType {
            case .maxPrice:
                path.append("&ordering=-price")
            case .minPrice:
                path.append("&ordering=price")
            case .filterAlphabeticallyByAz:
                path.append("&ordering=name")
            case .filterAlphabeticallyByZa:
                path.append("&ordering=-name")
            case .newFirst:
                path.append("&ordering=-created_at")
            case .oldFirst:
                path.append("&ordering=created_at")
            case .bestseller:
                path.append("&ordering=-is_hit")
            }
        }

        ownerID != nil ? path.append("&owner_id=\(ownerID!)") : nil
        categoryID != nil ? path.append("&category_id=\(categoryID!)") : nil


        APIManager.instance.GET(withAnimation: withAnimation, path: path) { [weak self] success, json, error in
            guard self != nil,
                  let drugResult = Mapper<DrugResult>().map(JSONObject: json.dictionaryObject) else {
                completion(nil)
                return
            }
            completion(drugResult)
        }
    }
}
