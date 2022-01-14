//
//  RegisterPageAPI.swift
//  Infoapteka
//
//  
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

final class RegisterAPI {
    //MARK: -- Profile register
    func registerProfile(_ role: UserOptionsType,
                         _ parameters: Parameters,
                         _ certificates: [Certificate],
                         _ completion: @escaping((Bool) -> Void)) {
        let path = Global.pathFor(key: role == .Клиент ? "simple-user-registration" : "seller-user-registration")
        APIManager.instance.POST(path: path, parameters: parameters) { isCreated,
                                                                       json,
                                                                       error in
            self.processProfileAfterRegister(role, certificates, isCreated, json, completion)
        }
    }

    fileprivate func processProfileAfterRegister(_ role: UserOptionsType,
                                                 _ certificates: [Certificate],
                                                 _ isCreated: Bool,
                                                 _ json: JSON,
                                                 _ completion: @escaping((Bool) -> Void)) {
        switch (isCreated, role) {
        case (false, _) : completion(isCreated)
        case (true, _): checkToken(role, certificates, isCreated, json, completion)
        }
    }

    fileprivate func checkToken(_ role: UserOptionsType,
                                _ certificates: [Certificate],
                                _ isCreated: Bool,
                                _ json: JSON,
                                _ completion: @escaping((Bool) -> Void)) {
        guard let token = json["token"].string, !token.isEmpty else {
            BannerTop.showToast(message: "Токен не найден!", and: .systemRed)
            completion(false)
            return
        }
        AppSession.token = token
        switch role {
        case .Клиент: completion(isCreated)
        case .Продавец:
            uploadSellersCertificates(certificates, completion, isCreated)
        }
    }

    fileprivate func uploadSellersCertificates(_ certificates: [Certificate],
                                               _ completion: @escaping((Bool) -> Void),
                                               _ isCreated: Bool) {
        let data: [Data] = certificates.compactMap { $0.image?.image?.jpegData(compressionQuality: 0.5) }
        if !data.isEmpty {
            self.uploadCertificates(data) { [weak self] isUploaded, _ in
                guard self != nil else { completion(isCreated); return }
                completion(isCreated)
            }
        } else {
            completion(isCreated)
        }
    }

    fileprivate func uploadCertificates(_ data: [Data],
                                        _ completion: @escaping((Bool, [Certificate]) -> Void)) {
        let path = Global.pathFor(key: "account-certificate")
        APIManager.instance.uploadData(true, path, data, .post, "image") { success,
                                                                           json,
                                                                           error in
            guard error == nil, let certificates = Mapper<Certificate>().mapArray(JSONObject: json.arrayObject) else {
                completion(false, [])
                return
            }
            completion(success, certificates)
        }
    }
    
    // MARK: GET PRIVACY POLICY
    func getPrivacyPolicy(_ completion: @escaping((PrivacyPolicy?, String?) -> Void)) {
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


//MARK: -- Profile update
extension RegisterAPI {
    func updateProfileAvatar(_ image: Image?, _ completion: @escaping((Bool) -> Void)) {
        let path = Global.pathFor(key: "user-avatar-update")
        guard let avatar = image?.image?.jpegData(compressionQuality: 0.5) else {
            APIManager.instance.DELETE(path: path, parameters: nil) { success, _, error in
                guard error == nil else { completion(false); return }
                completion(success)
            }
            return
        }
        APIManager.instance.uploadData(true, path, [avatar], .patch, "avatar") { success,
                                                                                 json,
                                                                                 error in
            completion(success)
        }
    }

    func deleteProfileAvatar(_ completion: @escaping((Bool) -> Void)) {
        let path = Global.pathFor(key: "user-avatar-delete")
        APIManager.instance.DELETE(path: path, parameters: nil) { success,
                                                                  _, _ in
            completion(success)
        }

    }

    func updateProfile(_ role: UserOptionsType,
                       _ parameters: Parameters,
                       _ certificates: [Certificate] = [],
                       _ completion: @escaping((Bool) -> Void)) {

        switch role {
        case .Клиент:
            updateCustomerProfile(parameters, completion)
        case .Продавец:
            checkSellerProfileUntilUpdating(certificates, parameters, completion)
        }
    }

    fileprivate func updateCustomerProfile(_ parameters: Parameters, _ completion: @escaping((Bool) -> Void)) {
        let path = Global.pathFor(key: "customer-user-update")
        APIManager.instance.PUT(path: path, parameters: parameters) { isUpdated,
                                                                      json,
                                                                      error in
            completion(isUpdated)
        }
    }

    fileprivate func checkSellerProfileUntilUpdating(_ certificates: [Certificate], _ parameters: Parameters, _ completion: @escaping((Bool) -> Void)) {
        let path = Global.pathFor(key: "account-certificate")
        let data = certificates.compactMap { $0.image } .compactMap { $0.image?.jpegData(compressionQuality: 0.5) }
        if !data.isEmpty {
            uploadCertificatesAndUpdateSellerProfile(path, parameters, data, completion)
        } else {
            updateSellerProfile(certificates, parameters, completion)
        }
    }

    fileprivate func uploadCertificatesAndUpdateSellerProfile(_ path: String,
                                                              _ parameters: Parameters,
                                                              _ data: [Data],
                                                              _ completion: @escaping((Bool) -> Void)) {
        uploadCertificates(data) { [weak self] isCreated, certificates in
            guard self != nil else { return }
            let path = Global.pathFor(key: "seller-user-update")
            var params = parameters
            var arrayOfCert: [Int] = (params["certificates"] as? [Int]) ?? []
            arrayOfCert.append(contentsOf: certificates.compactMap { $0.id })
            !arrayOfCert.isEmpty ? params["certificates"] = arrayOfCert : nil
            APIManager.instance.PUT(path: path, parameters: params) { isUpdated,
                                                                      json,
                                                                      error in
                completion(isUpdated)
            }
        }
    }

    fileprivate func updateSellerProfile(_ certificates: [Certificate], _ parameters: Parameters, _ completion: @escaping((Bool) -> Void)) {
        let path = Global.pathFor(key: "seller-user-update")
        var params = parameters
        let arrayOfCert: [Int] = certificates.compactMap { $0.id }
        !arrayOfCert.isEmpty ? (params["certificates"] = arrayOfCert   ) : nil
        APIManager.instance.PUT(path: path, parameters: params) { isUpdated,
                                                                  json,
                                                                  error in
            completion(isUpdated)
        }
    }
}


//MARK: -- Dieelds for Register
extension RegisterAPI {
    func getPages(_ userType: UserOptionsType,
                  _ showType: RegisterVCShowType,
                  _ profileForUpdate: Profile?,
                  _ completion: @escaping(([RegisterField]) -> Void)) {

        switch (userType, showType) {
        case (.Продавец, .register):
            completion(getSellerFieldsForRegister())
        case (.Продавец, .editProfile):
            completion(getSellerFieldsForEditProfile(profileForUpdate))
        case (.Клиент, .register):
            completion(getCustomerFieldsForRegister())
        case (.Клиент, .editProfile):
            completion(getCustomerFieldForEditProfile(profileForUpdate))
        }
    }

    fileprivate func getSellerFieldsForRegister() -> [RegisterField] {
        return [
            .init(placeholder: "", type: .title, value: ""),
            .init(placeholder: "", type: .phone, value: ""),
            .init(placeholder: L10n.userNamePlaceholder, type: .name),
            .init(placeholder: L10n.userSurnamePlaceholder, type: .surname),
            .init(placeholder: L10n.userMiddlenamePlaceholder, type: .middleName),
            .init(placeholder: L10n.userAddressPlaceholder, type: .address),
            .init(placeholder: L10n.userBirthDayPlaceholder, type: .birthdate),
            .init(placeholder: "Размер файла не должен превышать 2мб. Формат файлов \nJPG, PDF.", type: .certificates),
            .init(placeholder: "", type: .register, value: ""),
        ]
    }

    fileprivate func getSellerFieldsForEditProfile(_ profileForUpdate: Profile?) -> [RegisterField] {
        return [
            .init(placeholder: "", type: .avatar, value: profileForUpdate?.avatar),
            .init(placeholder: "", type: .phone, value: profileForUpdate?.phoneNumber),
            .init(placeholder: L10n.userNamePlaceholder, type: .name, value: profileForUpdate?.firstName),
            .init(placeholder: L10n.userSurnamePlaceholder, type: .surname, value: profileForUpdate?.lastName),
            .init(placeholder: L10n.userMiddlenamePlaceholder, type: .middleName, value: profileForUpdate?.middleName),
            .init(placeholder: L10n.userAddressPlaceholder, type: .address, value: profileForUpdate?.address),
            .init(placeholder: L10n.userBirthDayPlaceholder, type: .birthdate, value: profileForUpdate?.birthDate),
            .init(placeholder: "Размер файла не должен превышать 2мб. Формат файлов \nJPG, PDF.", type: .certificates, value: profileForUpdate?.certificates),
            .init(placeholder: "Сохранить", type: .save, value: ""),
        ]
    }

    fileprivate func getCustomerFieldsForRegister() -> [RegisterField] {
        return [
            .init(placeholder: "", type: .title, value: ""),
            .init(placeholder: "", type: .phone, value: ""),
            .init(placeholder: L10n.userNamePlaceholder, type: .name),
            .init(placeholder: L10n.userSurnamePlaceholder, type: .surname),
            .init(placeholder: L10n.userMiddlenamePlaceholder, type: .middleName),
            .init(placeholder: L10n.userBirthDayPlaceholder, type: .birthdate),
            .init(placeholder: "", type: .register, value: ""),
        ]
    }

    fileprivate func getCustomerFieldForEditProfile(_ profileForUpdate: Profile?) -> [RegisterField] {
        return [
            .init(placeholder: "", type: .avatar, value: profileForUpdate?.avatar),
            .init(placeholder: "", type: .phone, value: profileForUpdate?.phoneNumber),
            .init(placeholder: L10n.userNamePlaceholder, type: .name, value: profileForUpdate?.firstName),
            .init(placeholder: L10n.userSurnamePlaceholder, type: .surname, value: profileForUpdate?.lastName),
            .init(placeholder: L10n.userMiddlenamePlaceholder, type: .middleName, value: profileForUpdate?.middleName),
            .init(placeholder: L10n.userBirthDayPlaceholder, type: .birthdate, value: profileForUpdate?.birthDate),
            .init(placeholder: "Сохранить", type: .save, value: ""),
        ]
    }
}
