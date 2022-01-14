//
//  SceneDelegate.swift
//  Infoapteka
//
//

import UIKit
import SmileToUnlock

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let appSetting = AppSetting()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = LaunchVC()
        window?.makeKeyAndVisible()
        appSetting.checkAppVersion()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
//        appSetting.checkAppVersion()
    }
}
