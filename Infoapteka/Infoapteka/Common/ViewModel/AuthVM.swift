//
//  AuthVM.swift
//  Infoapteka
//
//

import Foundation
import Firebase

final class AuthVM {

    //MARK: -- properties
    private var verificationID: String?
    private var phoneNumber: String?
    private var userType: UserOptionsType?

    //MARK: -- verify phone number
    func verifyPhoneNumber(_ phoneNumber: String,
                           onCompletion: @escaping (Bool) -> Void) {
        API.authAPI.verifyPhoneNumber(phoneNumber) { success, verificationID in
            if success {
                self.verificationID = verificationID
                self.phoneNumber    = phoneNumber
                onCompletion(true)
            } else {
                onCompletion(false)
            }
        }
    }

    func tryVerifyPhoneNumber(onCompletion: @escaping (Bool) -> Void) {
        guard let phoneNumber = self.phoneNumber else {
            BannerTop.showToast(message: "Номер пользователя не найден!Попробуйте еще раз войти", and: .systemRed)
            onCompletion(false)
            return
        }
        verifyPhoneNumber(phoneNumber) { success in
            onCompletion(success)
        }
    }

    //MARK: -- signIn
    func signIn(_ verificationCode: String,
                onCompletion: @escaping (Bool, Bool) -> Void) {

        guard let verificationID = self.verificationID else {
            BannerTop.showToast(message: "Идентификатор подтверждения не найден!Попробуйте еще раз войти",
                                and: .systemRed)
            onCompletion(false, false)
            return
        }
        API.authAPI.signIn(phone,
                           verificationID,
                           verificationCode) { success, isActive in
            onCompletion(success, isActive)
        }
    }

    //MARK: -- getters
    var phone: String {
        get {
            guard let phoneNumber = self.phoneNumber,
                  !phoneNumber.isEmpty else {
                return ""
            }
            return phoneNumber
        }
    }

    var type: UserOptionsType {
        set {
            self.userType = newValue
        }
        get {
            guard let type = self.userType else { return .Клиент }
            return type
        }
    }

}
