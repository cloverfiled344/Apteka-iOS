//
//  CabinetAPI.swift
//  Infoapteka
//
//

import UIKit
import ObjectMapper

final class CabinetAPI {

    func fetchProfile(completion: @escaping (Profile?, String?) -> ())  {
        let path = Global.pathFor(key: "account-data")
        APIManager.instance.GET(path: path) { success,
                                              json,
                                              error in
            guard error == nil, let profile = Mapper<Profile>().map(JSONObject: json.dictionaryObject) else {
                completion(nil, "\(error?.localizedDescription ?? "Ошибка при разборе профиля!")")
                return
            }
            completion(profile, nil)
        }
    }

    func getMenuItems(_ profile: Profile?, completion: @escaping ([MenuItem]) -> ())  {
        if AppSession.isAuthorized && profile != nil {
            switch profile?.role {
            case .Клиент:
                return completion([
                    .init(icon: Asset.icProfile.image,
                          moderationStatus: profile?.moderationStatus,
                          type: .profile),
                    .init(icon: Asset.icHistoryOfOrders.image,
                          type: .historyOfOrders),
                    .init(icon: Asset.icAboutCompany.image,
                          type: .aboutCompany),
                    .init(icon: Asset.icHelp.image,
                          type: .help),
                    .init(icon: Asset.icProgramRules.image,
                          type: .programRules),
                    .init(icon: Asset.icSignOut.image,
                          type: .signOut)
                ])
            case .Продавец, .none:
                return completion([
                    .init(icon: Asset.icProfile.image,
                          moderationStatus: profile!.moderationStatus,
                          type: .profile),
                    .init(icon: Asset.icMyGoods.image,
                          type: .myGoods),
                    .init(icon: Asset.icHistoryOfOrders.image,
                          type: .historyOfOrders),
                    .init(icon: Asset.icAboutCompany.image,
                          type: .aboutCompany),
                    .init(icon: Asset.icHelp.image,
                          type: .help),
                    .init(icon: Asset.icProgramRules.image,
                          type: .programRules),
                    .init(icon: Asset.icSignOut.image,
                          type: .signOut)
                ])
            }
        } else {
            return completion([
                .init(icon: Asset.icProfile.image, type: .signIn),
                .init(icon: Asset.icAboutCompany.image, type: .aboutCompany),
                .init(icon: Asset.icHelp.image, type: .help),
                .init(icon: Asset.icProgramRules.image, type: .programRules)
            ])
        }
    }
    
    // MARK: GET PRIVACY POLICY
    func getProgramRules(_ completion: @escaping((PrivacyPolicy?, String?) -> Void)) {
        let path = Global.pathFor(key: "info")
        APIManager.instance.GET(path: path + "privacy-policy/") { success, json, error in
            guard error == nil else { completion(nil, "Ошибка при получения PDF файла!"); return }
            guard let result = Mapper<PrivacyPolicy>().map(JSONObject: json.dictionaryObject) else {
                completion(nil, "Ошибка при получения PDF файла!")
                return
            }
            completion(result, nil)
        }
    }
}
