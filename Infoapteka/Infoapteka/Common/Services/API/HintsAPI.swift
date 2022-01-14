//
//  HintsAPI.swift
//  Infoapteka
//
//

import Foundation

final class HintsAPI {

    func fetchHints(_ search: String?,_ completion: @escaping(([String]) -> Void)) {
        let path = Global.pathFor(key: "drug-search-hint")
        APIManager.instance.GET(withAnimation: false,
                                path: "\(path)?search=\(search ?? "")") { success,
                                              json,
                                              error in
            completion((json.arrayObject as? [String]) ?? [])
        }
    }
}
