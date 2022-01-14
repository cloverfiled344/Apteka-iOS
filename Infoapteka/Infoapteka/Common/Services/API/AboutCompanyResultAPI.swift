//
//  AboutCompanyResultAPI.swift
//  Infoapteka
//
//  
//

import UIKit
import ObjectMapper

final class AboutCompanyResultAPI {
    
    func getAboutCompanyResult(_ completion: @escaping((AboutCompanyResult?, [AboutHeaderText], String?) -> Void)) {
        let path = Global.pathFor(key: "info")
        var companyResult: (companyResult: AboutCompanyResult?, headerText: [AboutHeaderText]) = (.init(JSON: [:]), [])
        APIManager.instance.GET(path: path + "about/") { [weak self] success, json, error in
            guard let `self` = self else { return }
            guard error == nil else {
                completion(nil, [], error?.localizedDescription)
                return
            }
            guard let aboutResult = Mapper<AboutCompanyResult>().map(JSONObject: json.dictionaryObject) else {
                completion(nil, [], "")
                return
            }
            companyResult.companyResult = aboutResult
            companyResult.headerText = self.getCompanyFieldType()
            completion(companyResult.companyResult, companyResult.headerText, nil)
        }
    }
    
    private func getCompanyFieldType() -> [AboutHeaderText] {
        return [
            AboutHeaderText(type: .desc),
            AboutHeaderText(type: .phones),
            AboutHeaderText(type: .emailAddress),
            AboutHeaderText(type: .socialMedia),
            AboutHeaderText(type: .map)
        ]
    }
}
