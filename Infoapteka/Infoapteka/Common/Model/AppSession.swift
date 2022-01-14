//
//  AppSession.swift
//  Infoapteka
//
//

import Foundation

struct AppSession {
    static var isAuthorized: Bool {
        get { return KeychainService.instance().token != nil && isLoggedIn }
    }

    static var token: String? {
        get { return KeychainService.instance().token }
        set {
            KeychainService.instance().token = newValue
            AppSession.isLoggedIn = newValue != nil
            AppSession.deviceToken = newValue == nil ? nil : AppSession.deviceToken
        }
    }

    static var appVersion: String {
        get { return UserDefaultsWrapper.deviceToken ?? "" }
    }

    static var isSeenOnboarding: Bool {
        get { return UserDefaultsWrapper.isSeenOnboarding }
        set { UserDefaultsWrapper.isSeenOnboarding = newValue }
    }

    static var appBadgeCount: Int {
        get { return UserDefaultsWrapper.appBadgeCount }
        set { UserDefaultsWrapper.appBadgeCount = newValue }
    }

    static var deviceToken: String? {
        get { return UserDefaultsWrapper.deviceToken }
        set {
            guard let deviceToken = newValue else { return }
            UserDefaultsWrapper.deviceToken = deviceToken
        }
    }

    private static var isLoggedIn: Bool {
        get { return UserDefaultsWrapper.isLoggedIn }
        set { UserDefaultsWrapper.isLoggedIn = newValue }
    }

    static var searchFilter: SearchFilter? {
        get { return UserDefaultsWrapper.searchFilterType }
        set { UserDefaultsWrapper.searchFilterType = newValue}
    }

    static var collectionType: CollectionType? {
        get { return UserDefaultsWrapper.collectionType }
        set { UserDefaultsWrapper.collectionType = newValue }
    }

    static var favouritesCount: Int? {
        get { return UserDefaultsWrapper.favouritesCount }
        set { UserDefaultsWrapper.favouritesCount = newValue }
    }

    static var basketCount: Int? {
        get { return UserDefaultsWrapper.basketCount }
        set { UserDefaultsWrapper.basketCount = newValue }
    }

    static var remotePush: RemotePush? {
        get { return UserDefaultsWrapper.remotePush }
        set { UserDefaultsWrapper.remotePush = newValue }
    }
}

