//
//  UserDefaultsWrapper.swift
//  Infoapteka
//
//

import Foundation

struct UserDefaultsWrapper {

    fileprivate static let UserDefaultsStandart = UserDefaults.standard

    static var isSeenOnboarding: Bool {
        get {
            return UserDefaultsStandart.bool(forKey: PersistantKeys.isSeenOnboarding)
        }
        set {
            UserDefaultsStandart.set(newValue, forKey: PersistantKeys.isSeenOnboarding)
            UserDefaultsStandart.synchronize()
        }
    }

    static var token: String? {
        get {
            return UserDefaultsStandart.string(forKey: PersistantKeys.token)
        }
        set {
            UserDefaultsStandart.set(newValue, forKey: PersistantKeys.token)
            UserDefaultsStandart.synchronize()
        }
    }

    static var deviceToken: String? {
        get {
            return UserDefaultsStandart.string(forKey: PersistantKeys.deviceToken)
        }
        set {
            UserDefaultsStandart.set(newValue, forKey: PersistantKeys.deviceToken)
            UserDefaultsStandart.synchronize()
        }
    }

    static var appBadgeCount: Int {
        get {
            return UserDefaultsStandart.integer(forKey: PersistantKeys.appBadgeCount)
        }
        set {
            UserDefaultsStandart.set(newValue, forKey: PersistantKeys.appBadgeCount)
            UserDefaultsStandart.synchronize()
        }
    }

    static var isLoggedIn: Bool {
        set {
            UserDefaultsStandart.set(newValue, forKey: PersistantKeys.isLoggedIn)
            UserDefaultsStandart.synchronize()
        }
        get {
            return UserDefaultsStandart.bool(forKey: PersistantKeys.isLoggedIn)
        }
    }

    static var searchFilterType: SearchFilter? {
        get {
            guard let data = UserDefaults.standard.data(forKey: PersistantKeys.searchFilter) else {
                return nil
            }
            guard let searchFilter = try? JSONDecoder().decode(SearchFilter.self, from: data) else {
                return nil
            }
            return searchFilter
        }
        set {
            guard let searchFilter = newValue, let data = try? JSONEncoder().encode(searchFilter) else {
                return
            }
            UserDefaultsStandart.setValue(data, forKey: PersistantKeys.searchFilter)
            UserDefaultsStandart.synchronize()
        }
    }

    static var collectionType: CollectionType? {
        get {
            return CollectionType(rawValue:
                                    UserDefaultsStandart.string(forKey:
                                                                    PersistantKeys.collectionType) ?? "")
        }
        set {
            guard let collectionType = newValue else { return }
            UserDefaultsStandart.set(collectionType.rawValue, forKey: PersistantKeys.collectionType)
            UserDefaultsStandart.synchronize()
        }
    }

    static var favouritesCount: Int? {
        get {
            return UserDefaultsStandart.integer(forKey:
                                                    PersistantKeys.favouritesCount)
        }
        set {
            guard let favoritesCount = newValue else { return }
            UserDefaultsStandart.set(favoritesCount, forKey: PersistantKeys.favouritesCount)
            UserDefaultsStandart.synchronize()
        }
    }

    static var basketCount: Int? {
        get {
            return UserDefaultsStandart.integer(forKey:
                                                    PersistantKeys.basketCount)
        }
        set {
            guard let basketCount = newValue else { return }
            UserDefaultsStandart.set(basketCount, forKey: PersistantKeys.basketCount)
            UserDefaultsStandart.synchronize()
        }
    }

    static var remotePush: RemotePush? {
        get {
            do {
                let remotePushObjectID = UserDefaultsStandart.string(forKey: PersistantKeys.remotePushObjectID)
                let remotePushType = UserDefaultsStandart.string(forKey: PersistantKeys.remotePushType)
                guard let objectID = remotePushObjectID, let pushType = remotePushType else {
                    return nil
                }
                return try RemotePush(decoding: ["object_id": objectID, "type": pushType])
            } catch  {
                return nil
            }

        }
        set {
            guard let remotePush = newValue else {
                UserDefaultsStandart.removeObject(forKey: PersistantKeys.remotePushType)
                UserDefaultsStandart.removeObject(forKey: PersistantKeys.remotePushObjectID)
                return
            }
            UserDefaultsStandart.set(remotePush.type?.rawValue, forKey: PersistantKeys.remotePushType)
            UserDefaultsStandart.set(remotePush.object_id, forKey: PersistantKeys.remotePushObjectID)
            UserDefaultsStandart.synchronize()
        }
    }
}
