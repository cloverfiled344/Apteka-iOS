//
//  AuthAPI.swift
//  Infoapteka
//
//

import Foundation
import Firebase

final class AuthAPI {

    func verifyPhoneNumber(_ phoneNumber: String,
                           onCompletion: @escaping (Bool, String?) -> Void) {

        PhoneAuthProvider.provider().verifyPhoneNumber("+\(phoneNumber.digits)",
                                                       uiDelegate: nil,
                                                       multiFactorSession: nil) { verificationID, error in
            guard error == nil, let verificationID = verificationID, !verificationID.isEmpty else {
                BannerTop.showToast(message: error?.localizedDescription, and: .systemRed)
                onCompletion(false, nil)
                return
            }
            BannerTop.showToast(message: "На \(phoneNumber) отправлен код подтверждения", and: .systemGreen)
            onCompletion(true, verificationID)
        }
    }

    func signIn(_ phoneNumber: String,
                _ verificationID: String,
                _ verificationCode: String,
                onCompletion: @escaping (Bool, Bool) -> Void) {

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID,
                                                                 verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { [weak self] (user, error) in
            guard let self = self else {
                onCompletion(false, false)
                return
            }
            guard error == nil else {
                BannerTop.showToast(message: "Неверный код подтверждения!\nПопробуйте еще раз!", and: .systemRed)
                onCompletion(false, false)
                return
            }
            BannerTop.showToast(message: "Номер телефона успешно подтвержден", and: .systemGreen)
            self.checkUser(phoneNumber) { isActive in
                onCompletion(true, isActive)
            }
        }
    }

    private func checkUser(_ phoneNumber: String,
                           onCompletion: @escaping (Bool) -> Void) {
        let path = Global.pathFor(key: "check-user")
        APIManager.instance.POST(path: path,
                                 parameters: ["phone": "+\(phoneNumber.digits)"]) { success,
                                                                       json,
                                                                       error in
            guard let token = json["token"].string, !token.isEmpty else {
                onCompletion(false)
                return
            }
            AppSession.token = token
            onCompletion(true)
        }
    }
}

