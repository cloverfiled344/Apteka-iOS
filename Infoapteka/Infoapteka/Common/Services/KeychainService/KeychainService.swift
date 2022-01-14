//
//  KeychainService.swift
//  Infoapteka
//
//

import Foundation
import SwiftKeychainWrapper

struct Keys {
    static let token = "Token"
}

class KeychainService {

    //MARK : - Shared Instance
    class func instance() -> KeychainService {
        return sharedManager
    }

    private static var sharedManager: KeychainService = {
        let manager = KeychainService()
        return manager
    }()

    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Keys.token)
        }
        set {
            guard let token = newValue else {
                KeychainWrapper.standard.remove(forKey: KeychainWrapper.Key(rawValue: Keys.token))
                return
            }
            KeychainWrapper.standard.set(token, forKey: Keys.token)
        }
    }
}
