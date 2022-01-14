//
//  CabinetVM.swift
//  Infoapteka
//
//

import Foundation

final class CabinetVM {

    //MARK: -- properties
    private var profile: Profile?
    private var menuItems: [MenuItem] = []

    //MARK: -- public methods
    func fetchProfile(completion: @escaping () -> ())  {
        API.cabinetAPI.fetchProfile { [weak self] profile, error in
            guard let self = self else { return }
            self.profile = profile
            completion()
        }
    }

    func getMenuItems(completion: @escaping () -> ()) {
        refetchProfile(completion)
//        guard let profile = self.profile else {
//            AppSession.isAuthorized ? self.refetchProfile(completion) : self.getMenuItems(profile, completion)
//            return
//        }
//        getMenuItems(profile, completion)
    }
    
    // MARK: GET PRIVACY POLISY
    func getProgramRules(_ completion: @escaping((PrivacyPolicy?) -> Void)) {
        API.registerAPI.getPrivacyPolicy { result, errorMessage in
            guard errorMessage == nil else {
                BannerTop.showToast(message: errorMessage ?? "", and: .systemRed)
                completion(nil)
                return
            }
            completion(result)
        }
    }

    fileprivate func getMenuItems(_ profile: Profile?,
                                  _ completion: @escaping() -> ()) {
        API.cabinetAPI.getMenuItems(profile) { [weak self] menuItems in
            self?.menuItems = menuItems
            completion()
        }
    }

    //MARK: -- private methods
    fileprivate func refetchProfile(_ completion: @escaping () -> ()) {
        self.fetchProfile { [weak self] in
            guard let self = self else { return }
            API.cabinetAPI.getMenuItems(self.profile) { menuItems in
                self.menuItems = menuItems
                completion()
            }
        }
    }

    //MARK: -- setters

    //MARK: -- getters
    func getMenuItemsCount() -> Int {
        self.menuItems.count
    }

    func getMenuItem(_ by: Int) -> MenuItem? {
        menuItems.count > by ? menuItems[by] : nil
    }

    func getProfile() -> Profile? {
        self.profile
    }
}
