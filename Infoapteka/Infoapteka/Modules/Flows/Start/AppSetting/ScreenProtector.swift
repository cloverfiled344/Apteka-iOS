//
//  ScreenProtector.swift
//  Infoapteka
//
//

import UIKit
import SmileToUnlock

class ScreenProtector {
    private var window: UIWindow? {
        get { (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window }
        set { (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window = newValue }
    }

    private var updateAppwindow: UIWindow?

    func presentWindowToUpdateApp(_ appVersion: AppVersion) {
        updateAppwindow = makeProtectorWindow()
        updateAppwindow?.backgroundColor = Asset.mainBlack.color.withAlphaComponent(0.2)
        let vc =  UpdateAppVC(appVersion)
        vc.skipBtnClicked = { [weak self] in
            guard let self = self else { return }
            vc.removeFromParent()
            self.updateAppwindow?.isHidden = true
            self.updateAppwindow?.removeFromSuperview()
        }
        updateAppwindow?.rootViewController = vc
        updateAppwindow?.makeKeyAndVisible()
    }

    func presentWindowToUnlockWithSmile() {
        let protectorWindow = makeProtectorWindow()
        if SmileToUnlock.isSupported {
            let vc = SmileToUnlock()
            vc.onSuccess = { [weak self] in
                guard let self = self else { return }
                self.presentWorkingWindow()
                protectorWindow.removeFromSuperview()
            }
            protectorWindow.rootViewController = vc
            self.window = protectorWindow
            self.window?.makeKeyAndVisible()
        } else {
            presentWorkingWindow()
        }
    }

    private func presentWorkingWindow() {
        window?.rootViewController = LaunchVC()
        window?.makeKeyAndVisible()
    }

    private func makeProtectorWindow() -> UIWindow {
        guard let windowScene = window?.windowScene else {
            return UIWindow(frame: UIScreen.main.bounds)
        }
        let protectorWindow = UIWindow(windowScene: windowScene)
        protectorWindow.backgroundColor = .white
        protectorWindow.windowLevel = UIWindow.Level.alert + 1
        protectorWindow.clipsToBounds = true
        protectorWindow.isHidden = false
        return protectorWindow
    }
}
