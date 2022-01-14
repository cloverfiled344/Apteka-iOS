//
//  AppDelegate.swift
//  Infoapteka
//
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let appSetting = AppSetting()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appSetting.setup(application)
        return true
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        appSetting.setAppBadgeCount(userInfo)
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        appSetting.setAppBadgeCount(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        appSetting.setAPNSToken(deviceToken)
    }
}

