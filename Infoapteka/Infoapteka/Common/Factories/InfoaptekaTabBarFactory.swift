//
//  InfoaptekaFactory.swift
//  Infoapteka
//
//

import UIKit

class InfoaptekaTabBarFactory {

    func makeInfoaptekaTabBar(_ infoaptekTabBar: InfoaptekaTabBarController) {
        infoaptekTabBar.tabBar.items?.first?.imageInsets = .init(top: 2, left: 0, bottom: 0, right: 0)
        infoaptekTabBar.viewControllers = [makeHomeView(),
                                           makeCategoriesView(),
                                           makeBasketView(),
                                           makeFavoritesView(),
                                           makeCabinetView()]
    }
}

private extension InfoaptekaTabBarFactory {

    func makeHomeView() -> InfoaptekaNavController {
        let rootVC = HomeCVC(.init())
        let nav = self.makeNav(rootVC,
                               "Главная",
                               Asset.icUnselectedHome.image,
                               Asset.icSelectedHome.image)
        return nav
    }

    func makeCategoriesView() -> InfoaptekaNavController {
        makeNav(CategoriesTVC(.init(.search)),
                "Категории",
                Asset.icUnselectedCategories.image,
                Asset.icSelectedCategories.image)
    }

    func makeBasketView() -> InfoaptekaNavController {
        makeNav(BasketVC(.init()),
                "Корзина",
                Asset.icUnselectedCart.image,
                Asset.icSelectedCart.image)
    }

    func makeFavoritesView() -> UINavigationController {
        makeNav(FavouritesCVC(.init()),
                "Избранное",
                Asset.icUnselectedFavorites.image,
                Asset.icSelectedFavorites.image)
    }

    func makeCabinetView() -> UINavigationController {
        makeNav(CabinetTVC(.init()),
                "Меню",
                Asset.icUnselectedMenu.image,
                Asset.icSelectedMenu.image)
    }

    private func makeNav(_ rootViewController: UIViewController,
                         _ title: String,
                         _ image: UIImage?,
                         _ selectedImage: UIImage?) -> InfoaptekaNavController {
        return makeNavBar(rootViewController, title, image, selectedImage)
    }

    func makeNavBar(_ rootViewController: UIViewController,
                    _ title: String,
                    _ image: UIImage?,
                    _ selectedImage: UIImage?) -> InfoaptekaNavController {
        let nav = InfoaptekaNavController(rootViewController: rootViewController)
        nav.tabBarItem = UITabBarItem(title: title,
                                      image: image,
                                      selectedImage: selectedImage)
        nav.tabBarItem.imageInsets = .init(top: 4, left: 0, bottom: 0, right: 0)
        setTitleAttributes(nav)
        if (rootViewController as? BasketVC) != nil {
            changeBasketTVCBadgeValue(nav)
        } else if (rootViewController as? FavouritesCVC)  != nil {
            changeFavouritesCVCBadgeValue(nav)
        }
        return nav
    }

    private func setTitleAttributes(_ nav: InfoaptekaNavController) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.73

        nav.tabBarItem.setTitleTextAttributes([.font: FontFamily.Inter.medium.font(size: 0),
                                               .paragraphStyle: paragraphStyle,
                                               .kern: -0.2,
                                               .foregroundColor: UIColor.clear],
                                              for: .normal)

        nav.tabBarItem.setTitleTextAttributes([.font: FontFamily.Inter.medium.font(size: 11),
                                               .paragraphStyle: paragraphStyle,
                                               .kern: -0.2,
                                               .foregroundColor: Asset.mainGreen.color],
                                              for: .highlighted)
    }

    private func changeBasketTVCBadgeValue(_ nav: InfoaptekaNavController) {
        guard let basketCount = AppSession.basketCount, basketCount > 0 else { return }
        nav.tabBarItem.setBadgeTextAttributes([.foregroundColor: Asset.mainWhite.color,
                                               .font: FontFamily.Inter.regular.font(size: 12)],
                                              for: .normal)
        nav.tabBarItem.badgeValue = "\(basketCount)"
    }

    private func changeFavouritesCVCBadgeValue( _ nav: InfoaptekaNavController) {
        guard let favouritesCount = AppSession.favouritesCount, favouritesCount > 0 else { return }
        nav.tabBarItem.setBadgeTextAttributes([.foregroundColor: Asset.mainWhite.color,
                                               .font: FontFamily.Inter.regular.font(size: 12)],
                                              for: .normal)
        nav.tabBarItem.badgeValue = "\(favouritesCount)"
    }
}
