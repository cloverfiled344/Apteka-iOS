//
//  AppSettingVM.swift
//  Infoapteka
//
//

import Foundation

class AppSettingVM: NSObject {

    //MARK: - Properties
    private var _appVersion: AppVersion?
    private let gcmMessageIDKey = "gcm.message_id"

    //MARK: - Methods
    func getAppVersion(_ completion: @escaping (Bool) -> ()) {
        API.appSettingAPI.getAppVersion { [weak self] appVersion, err in
            guard err == nil, let self = self else {
                completion(false)
                return
            }
            self._appVersion = appVersion
            completion(true)
        }
    }

    func postDeviceIdToServer(_ deviceToken: String?) {
//        API.appSettingAPI.postDeviceIdToServer(deviceToken)
    }

    //MARK: - Setters

    //MARK: - Getters
    var appVersion: AppVersion? {
        get { _appVersion }
    }

    func isNeedUpdate() -> Bool {
        guard let buildNumber = self.appVersion?.buildNumber else {
            return false
        }
        return self.getLocalBN() < buildNumber
    }

    private func isForceUpdate() -> Bool {
        return self.appVersion?.forceUpdate ?? false
    }

    private func getLocalBN() -> Int {
        return (Int(Bundle.main.buildNumber) ?? 0)
    }

    func getGCMMessageIDKey() -> String {
        self.gcmMessageIDKey
    }
}
