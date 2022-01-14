//
//  NotificationsAPI.swift
//  Infoapteka
//
//

import Foundation
import ObjectMapper

final class NotificationsAPI {

    func fetchNotifications(_ page: Int?,
                            _ completion: @escaping((NotifResult?) -> Void)) {
        let path = Global.pathFor(key: "notification")
        APIManager.instance.GET(path: "\(path)?page=\(page ?? 1)") { success, json, error in
            guard error == nil, let notifResult = Mapper<NotifResult>().map(JSONObject: json.dictionaryObject) else {
                completion(nil)
                return
            }
            completion(notifResult)
        }
    }
}
