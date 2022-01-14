//
//  Constants.swift
//  Infoapteka
//
//  
//

import UIKit

// MARK:- Typealiases
typealias CompletionBlock              = ()       -> Void
typealias CompletionBlockWithObject    = (Any)       -> Void
typealias AlertCompletionBlock         = (String) -> Void

class Constants {
    static let screenBounds = UIScreen.main.bounds
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenWidth = UIScreen.main.bounds.size.width
    static let safeAreaWidth = UIApplication.topViewController()?.view.safeAreaLayoutGuide.layoutFrame.size.width ?? 0.0
    static let safeAreaHeight = UIApplication.topViewController()?.view.safeAreaLayoutGuide.layoutFrame.size.height ?? 0.0

    static let statusBarHeigth: CGFloat = UIApplication.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
    static let statusBarWidth: CGFloat = UIApplication.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.width ?? 20
    static let navBarHeigth: CGFloat = UIApplication.topViewController()?.navigationController?.navigationBar.bounds.size.height ?? 0.0
    static let distanceBetweenSuperSafeViews = UIApplication.keyWindow?.safeAreaInsets.bottom ?? 0.0
        //Constants.screenHeight - (Constants.safeAreaHeight + Constants.statusBarHeigth + Constants.navBarHeigth)


    static let appstorelink: String = "https://apps.apple.com/us/app/fantomath/id1480332581"
}
