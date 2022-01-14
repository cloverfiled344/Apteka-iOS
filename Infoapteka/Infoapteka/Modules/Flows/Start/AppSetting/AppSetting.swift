//
//  AppSetting.swift
//  Infoapteka
//
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging

class AppSetting: NSObject {

    static let instance = AppSetting()
    private let viewModel = AppSettingVM()
    private let screenProtector = ScreenProtector()
    private var sheet: UpdateAppBottomSheet?

    func setup(_ application: UIApplication) {
        setupFirebaseConfigure()
        registerForRemoteNotifications(application)
        setupKeyboardManager()
        changeBackBarBtnIcon()
    }

    func checkAppVersion() {
        viewModel.getAppVersion { [ weak self] isSuccess in
            guard let self = self, isSuccess else { return }
            guard let appVersion = self.viewModel.appVersion else { return }
            self.viewModel.isNeedUpdate() ? self.screenProtector.presentWindowToUpdateApp(appVersion) : nil
        }
    }
}

extension AppSetting {
    func setAPNSToken(_ apnsToken: Data) {
        Messaging.messaging().apnsToken = apnsToken
    }
}

private extension AppSetting {
    private func registerForRemoteNotifications(_ application: UIApplication) {
        let authOptions: UNAuthorizationOptions = [ .alert, .badge, .sound]
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
    }

    private func openLink(_ path: String) {
        guard let url = URL(string: path),
              UIApplication.shared.canOpenURL(url) else {
            BannerTop.showToast(message: "Данная ссылка не активна!", and: .systemRed)
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    private func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }

    private func changeBackBarBtnIcon() {
        var backButtonImage = Asset.icAppArrowLeft.image
        backButtonImage = backButtonImage.stretchableImage(withLeftCapWidth: 32, topCapHeight: 32)
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default)
    }
}

extension AppSetting: UNUserNotificationCenterDelegate {
    private func setupFirebaseConfigure() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }

    func setAppBadgeCount(_ userInfo: [AnyHashable : Any]) {
        guard userInfo[viewModel.getGCMMessageIDKey()] != nil,
              let remotePushJSON = userInfo as? Dictionary<String, Any>,
              let remotePush = try? RemotePush(decoding: remotePushJSON) else { return }
        AppSession.appBadgeCount = remotePush.badge ?? AppSession.appBadgeCount
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        guard userInfo[viewModel.getGCMMessageIDKey()] != nil,
              let remotePushJSON = userInfo as? Dictionary<String, Any>,
              let remotePush = try? RemotePush(decoding: remotePushJSON) else { return }
        handleNotification(remotePush)
        completionHandler()
    }

    private func handleNotification(_ remotePush: RemotePush) {
        guard let objectID: Int = Int(remotePush.object_id ?? ""), let type = remotePush.type else { return }
        AppSession.remotePush = remotePush
        NotificationCenter.default.post(name: Notification.Name.handleOnPushNotification,
                                        object: nil, userInfo: ["type": type, "objectID": objectID])
    }
}

extension AppSetting: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        viewModel.postDeviceIdToServer(fcmToken)
    }
}
