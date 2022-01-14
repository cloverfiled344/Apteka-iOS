//
//  InfoaptekaTabBarCoordinator.swift
//  Infoapteka
//
//  Created by Avazbek Kodiraliev on 4/8/21.
//

import UIKit

class InfoaptekaTabBarCoordinator: BaseCoordinator, InfoaptekaTabBarCoordinatorOutput {

    var finishFlow: CompletionBlock?

    private let factory : InfoaptekaTabBarFactoryProtocol
    private let router  : Routable

    init(with factory: InfoaptekaTabBarFactoryProtocol, router: Routable) {
        self.factory = factory
        self.router = router
    }
}

// MARK:- Coordinatable
extension InfoaptekaTabBarCoordinator: Coordinatable {
    func start() {
        let infoaptekaTabBar = InfoaptekaTabBar()
        infoaptekaTabBar.viewControllers = [factory.makeHome(),
                                            factory.makeCategories(),
                                            factory.makeCard(),
                                            factory.makeFavorites(),
                                            UINavigationController(rootViewController: MenuTVC())]
        infoaptekaTabBar.tabBar.items?.first?.imageInsets = .init(top: 2, left: 0, bottom: 0, right: 0)
        router.setRootModule(infoaptekaTabBar, hideBar: true)
    }
}
