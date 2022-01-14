//
//  UITabBarController + Extensions.swift
//  Infoapteka
//
//  
//

import UIKit

extension UITabBarController {
    func openVC(_ rootVC: UIViewController) {
        guard let currentNav = selectedViewController as? UINavigationController,
              let currentVC = currentNav.viewControllers.last else {
            return
        }
        if let currentVCNav = currentVC.navigationController {
            currentVCNav.hidesBottomBarWhenPushed = true
            currentVCNav.pushViewController(rootVC, animated: true)
        } else {
            let nav = UINavigationController(rootViewController: rootVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        }
    }
}
