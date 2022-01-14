//
//  AppSettingAPI.swift
//  Infoapteka
//
//

import Foundation
import ObjectMapper
import Alamofire

class AppSettingAPI: NSObject {

    func getAppVersion(completion: @escaping((AppVersion?, String?) -> Void)) {
        let path = Global.pathFor(key: "setting-version")
        APIManager.instance.GET(withAnimation: false, path: path, parameters: nil) { status, json, error in
            guard let version = Mapper<AppVersion>().map(JSONObject: json.dictionaryObject) else {
                completion(nil, "Ошибка при разборе версии приложения!")
                return
            }
            completion(version, nil)
        }
    }
}
