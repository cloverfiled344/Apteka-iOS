//
//  Global.swift
//  Infoapteka
//
//

import Foundation

class Global {

    class func pathFor(key: String) -> String {
        if let path = Bundle.main.path(forResource: "Api", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            guard let path = dict[key] as? String else {
                BannerTop.showToast(message: "Такой страницы нет!", and: Asset.mainRed.color)
                return ""
            }
            let domen = PlistFiles.Api.domen
            let api = PlistFiles.Api.api
            let version = PlistFiles.Api.version
            let link = "\(domen)\(api)\(version)\(path)"
            return link
        }
        else { return "" }
    }

    class func valueFor(key: String) -> String {
        if let path = Bundle.main.path(forResource: "api", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            return dict[key] as? String ?? ""
        }
        else { return "" }
    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch { return nil }
        }
        return nil
    }
}
