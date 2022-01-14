//
//  InfoaptekaTabBar.swift
//  Infoapteka
//
//

import UIKit
import FirebaseCrashlytics

class InfoaptekaTabBarController: UITabBarController {

    private var factory: InfoaptekaTabBarFactory

    init(_ factory: InfoaptekaTabBarFactory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor          = Asset.mainWhite.color
        UITabBar.appearance().barTintColor = Asset.mainWhite.color
        UITabBar.appearance().tintColor    = Asset.mainGreen.color
        
        setNavBarBackColor(title: "",
                                statusBarBackColor: Asset.mainWhite.color,
                                navBarBackColor: Asset.mainWhite.color,
                                navBarTintColor: Asset.mainWhite.color,
                                prefersLargeTitles: false)
        
        setTabBarBackColor(tabBarBackColor: Asset.mainWhite.color,
                                tabBarTintColor: Asset.mainWhite.color)
        factory.makeInfoaptekaTabBar(self)
    }
}

extension InfoaptekaTabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        tabBar.items?.forEach({ item in
            item.imageInsets = .init(top: 4, left: 0, bottom: 0, right: 0)
        })
        item.imageInsets = .init(top: 2, left: 0, bottom: 0, right: 0)
    }
}
