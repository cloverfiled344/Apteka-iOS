//
//  Session.swift
//  Infoapteka
//
//  Created by Avazbek Kodiraliev on 3/8/21.
//

import UIKit

typealias Credentials = (username: String, password: String)

struct Session {
    static var isAuthorized: Bool {
        get {
            return KeychainService.instance().getToken() != nil
        }
    }
    static var appVersion: String {
        get {
            return UserDefaultsWrapper.deviceToken ?? ""
        }
    }

    static var isSeenOnboarding: Bool {
        get {
            return UserDefaultsWrapper.isSeenOnboarding
        }
        set {
            UserDefaultsWrapper.isSeenOnboarding = newValue
        }
    }

    static var appBadgeCount: Int {
        get {
            return UserDefaultsWrapper.appBadgeCount
        }
        set {
            UserDefaultsWrapper.appBadgeCount = newValue
        }
    }

    static var deviceToken: String {
        get {
            return UserDefaultsWrapper.deviceToken ?? ""
        }
        set {
            UserDefaultsWrapper.deviceToken = newValue
        }
    }
}
