//
//  SystemChecker.swift
//  Infoapteka
//
//  Created by Avazbek Kodiraliev on 27/7/21.
//

import UIKit

class SystemChecker {

    static let instance = SystemChecker()

    func isLoggedIn() -> Bool {
        let isLogged: Bool = UserDefaults.standard.bool(forKey: "isLogged")
        guard let token = KeychainService.instance().getToken(),
              !token.isEmpty,
              isLogged == true else {
            return false
        }
        return true
    }

    func login() {
        UserDefaults.standard.setValue(true, forKey: "isLogged")
    }

    func logout() {
        UserDefaults.standard.setValue(false, forKey: "isLogged")
    }
}
