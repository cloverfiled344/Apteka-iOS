//
//  RegisterVM.swift
//  Infoapteka
//
//  
//

import UIKit
import Alamofire

final class RegisterVM {

    private var userType: UserOptionsType
    private var showType: RegisterVCShowType
    private var fields: [RegisterField] = []
    private var phoneNumber: String
    private var profileForUpdate: Profile?

    init(_ profileForUpdate: Profile) {
        self.profileForUpdate = profileForUpdate
        self.phoneNumber = self.profileForUpdate?.phoneNumber ?? ""
        self.userType = self.profileForUpdate?.role ?? .Клиент
        self.showType = .editProfile
    }

    init(_ userType: UserOptionsType,
         _ phoneNumber: String) {
        self.userType = userType
        self.showType = .register
        self.phoneNumber = phoneNumber
    }

    func getPages(_ completion: @escaping(() -> Void)) {
        API.registerAPI.getPages(self.userType,
                                 self.showType,
                                 self.profileForUpdate) { fields in
            self.fields = fields
            self.fields.indices.forEach { fields[$0].type == .phone ? (self.fields[$0].value = self.phoneNumber) : nil }
            completion()
        }
    }

    func removeImage(_ certificate: Certificate?,
                     complation: @escaping ([Certificate]) -> ()) {
        var certificates: [Certificate] = []
        fields.indices.forEach {
            fields[$0].type == .certificates ? (certificates = fields[$0].value as? [Certificate] ?? []) : nil
        }
        certificates.removeAll {
            if let currentImage = $0.image, let image = certificate?.image  {
                return currentImage.id == image.id
            } else {
                return $0.id == certificate?.id ?? 0
            }
        }
        fields.indices.forEach {
            fields[$0].type == .certificates ? (fields[$0].value = certificates) : nil
        }
        complation(certificates)
    }

    func register(_ completion: @escaping((Bool) -> Void)) {
        let errorMessage: String = checkEmptyFields()
        guard errorMessage.isEmpty else {
            BannerTop.showToast(message: "Заполните следующие поля:\(errorMessage)", and: .systemRed)
            completion(false)
            return
        }

        var parameters: Parameters = [
            "phone"      : "+\(phoneNumber.digits)",
            "first_name" : getValue(.name),
            "last_name"  : getValue(.surname),
            "middle_name": getValue(.middleName),
            "birth_date" : getValue(.birthdate),
        ]
        userType == .Продавец ? (parameters["address"] = getValue(.address)) : nil
        API.registerAPI.registerProfile(self.userType,
                                 parameters,
                                 self.getCertificates()) { success in
            completion(success)
        }
    }

    fileprivate func checkEmptyFields() -> String {
        var errorMessage: String = ""
        fields.forEach {
            switch $0.type {
            case .phone, .name, .surname, .middleName, .birthdate, .address:
                if $0.value == nil || (($0.value as? String)?.isEmpty ?? true) || (($0.value as? String)?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                    errorMessage.append(" \($0.type.rawValue)")
                }
            case .certificates:
                if ($0.value as? [Certificate]) == nil || (($0.value as? [Certificate])?.isEmpty ?? true) {
                    errorMessage.append(" \($0.type.rawValue)")
                }
            case .title, .register, .save,  .avatar: break
            }
        }
        return errorMessage
    }

    func updateProfile(_ completion: @escaping ((Bool) -> Void)) {
        let errorMessage: String = checkEmptyFields()
        guard errorMessage.isEmpty else {
            BannerTop.showToast(message: "Заполните следующие поля:\(errorMessage)", and: .systemRed)
            completion(false)
            return
        }

        let checkFieldsForUpdating = checkFieldsForUpdating()
        let isEdited     = checkFieldsForUpdating.0
        let parameters   = checkFieldsForUpdating.1

        if let certificate = fields.filter({ $0.type == .certificates }).first {
            let certIsChanged = checkCertificates(certificate).0
            let certificates = checkCertificates(certificate).1
            if isEdited || certIsChanged {
                updateProfile(parameters, certificates, completion)
            } else { completion(true) }
        } else if isEdited {
            updateProfile(parameters, [], completion)
        } else { completion(true) }
    }

    fileprivate func updateProfile(_ parameters: Parameters, _ certificates: [Certificate] = [], _ completion: @escaping ((Bool) -> Void)) {
        API.registerAPI.updateProfile(self.userType, parameters, certificates) { isUpdated in
            completion(isUpdated)
        }
    }

    fileprivate func checkFieldsForUpdating() -> (Bool, Parameters) {
        var isEdited: Bool = false
        var parameters: Parameters = [:]
        fields.forEach {
            switch $0.type {
            case .phone:
                if checkString(profileForUpdate?.phoneNumber, $0) { isEdited = true }
            case .name:
                parameters["first_name"] = ($0.value as? String)
                if checkString(profileForUpdate?.firstName, $0) {
                    isEdited = true
                }
            case .surname:
                parameters["last_name"] = ($0.value as? String)
                if checkString(profileForUpdate?.lastName, $0) {
                    isEdited = true
                }
            case .middleName:
                parameters["middle_name"] = ($0.value as? String)
                if checkString(profileForUpdate?.middleName, $0) {
                    isEdited = true
                }
            case .birthdate:
                parameters["birth_date"] = ($0.value as? String)
                if checkString(profileForUpdate?.birthDate, $0) {
                    isEdited = true
                }
            case .address:
                parameters["address"] = ($0.value as? String)
                if checkString(profileForUpdate?.address, $0) {
                    isEdited = true
                }
            case .certificates:
                let certificates = ($0.value as? [Certificate])?.filter { $0.url != nil || !($0.url?.isEmpty ?? true) }
                parameters["certificates"] = certificates?.compactMap { $0.id} ?? []

                if (profileForUpdate?.certificates.count ?? 0) != (certificates?.count ?? 0) {
                    parameters["certificates"] = certificates?.compactMap { $0.id} ?? []
                    isEdited = true
                }
            case .avatar, .save, .title, .register: break
            }
        }
        return (isEdited, parameters)
    }

    fileprivate func checkString(_ str: String?, _ field: RegisterField) -> Bool {
        guard let string = field.value as? String, !string.isEmpty,
              let pString = str else {
            return (field.value as? String ?? "") != (str ?? "")
        }
        return string != pString
    }

    fileprivate func checkCertificates(_ field: RegisterField) -> (Bool, [Certificate]) {
        guard let certificates = field.value as? [Certificate], !certificates.isEmpty,
              let pCertificates = profileForUpdate?.certificates else {
            return (false, [])
        }
//        let addedCertificates = certificates.filter({ $0.url == nil || ($0.url?.isEmpty ?? true) })
        return ((certificates.count != pCertificates.count), certificates)
    }

    fileprivate func checkCity(_ field: RegisterField) -> Bool {
        guard let city = field.value as? City, let pCity = profileForUpdate?.city else {
            return false
        }
        return (city.id ?? 0) != (pCity.id ?? 0)
    }

    fileprivate func checkAvatar(_ field: RegisterField) -> Bool {
        if let avatar = (field.value as? Image), avatar.image != nil {
            return true
        } else if let avatar = (field.value as? String), !avatar.isEmpty {
            return true
        } else { return false }
    }

    // MARK: GET PRIVACY POLISY
    func getPrivacyPolicy(_ completion: @escaping((PrivacyPolicy?) -> Void)) {
        API.registerAPI.getPrivacyPolicy { result, errorMessage in
            guard errorMessage == nil else {
                BannerTop.showToast(message: errorMessage ?? "", and: .systemRed)
                completion(nil)
                return
            }
            completion(result)
        }
    }
    
    //MARK: -- setters
    func setCertificates(_ certificates: [Certificate]) {
        fields.indices.forEach {
            if fields[$0].type == .certificates {
                if var certs = fields[$0].value as? [Certificate] {
                    certs.append(contentsOf: certificates)
                    fields[$0].value = certs
                } else {
                    fields[$0].value = certificates
                }
            }
        }
    }

    func setAvatar(_ image: Image?, _ completion: @escaping((Bool) -> Void)) {
        API.registerAPI.updateProfileAvatar(image) { success in
            if success {
                self.fields.indices.forEach { self.fields[$0].type == .avatar ? (self.fields[$0].value = image) : nil }
                completion(success)
            } else {
                completion(success)
            }
        }
    }

    func deleteProfileAvatar(complation: @escaping (Bool) -> ()) {
        API.registerAPI.deleteProfileAvatar(complation)
    }

    func setBirthDate(_ birthDate: String) {
        fields.indices.forEach { fields[$0].type == .birthdate ? (fields[$0].value = birthDate) : nil }
    }

    func setValue(_ field: RegisterField) {
        fields.indices.forEach { fields[$0].type == field.type ? (fields[$0].value = field.value) : nil }
    }

    //MARK: -- getters
    func getTitle() -> String {
        return self.userType == .Клиент ? L10n.registerAsCustomer : L10n.registerAsSeller
    }

    func getFieldsCount() -> Int {
        self.fields.count
    }

    func getField(_ by: Int) -> RegisterField {
        fields.count > by ? fields[by] : .init(placeholder: "", type: .name)
    }

    func getAvatar() -> Any? {
        fields.filter { $0.type == .avatar }.first?.value
    }

    func getCertificates() -> [Certificate] {
        fields.filter { $0.type == .certificates }.first?.value as? [Certificate] ?? []
    }

    func getValue(_ type: RegisterFieldType) -> String {
        return (fields.filter { $0.type == type }.first?.value as? String ?? "")
    }
}
