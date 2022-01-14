//
//  UIViewcontroller + Extensions.swift
//  Infoapteka
//
//  
//

import UIKit
import NVActivityIndicatorView
import Photos
import MHWebViewController

extension UIViewController {
    func setNavBarBackColor(title: String = "",
                            titleColor: UIColor = Asset.mainBlack.color,
                            titleFont: UIFont = FontFamily.Inter.semiBold.font(size: 18),
                            statusBarBackColor: UIColor,
                            navBarBackColor: UIColor,
                            navBarTintColor: UIColor, prefersLargeTitles: Bool) {

        UIApplication.statusBarUIView?.backgroundColor           = statusBarBackColor
        self.navigationController?.navigationBar.backgroundColor = navBarBackColor
        self.navigationController?.navigationBar.barTintColor    = navBarTintColor
        self.navigationController?.navigationBar.isTranslucent   = false
        self.navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left

        self.navigationController?.navigationBar.titleTextAttributes = [
            .font: titleFont,
            .foregroundColor: titleColor,
            .paragraphStyle: paragraphStyle]

        self.navigationItem.title = title
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }

    func setTabBarBackColor(tabBarBackColor: UIColor, tabBarTintColor: UIColor) {

        self.tabBarController?.tabBar.backgroundColor = tabBarBackColor
        self.tabBarController?.tabBar.barTintColor = tabBarTintColor
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        self.tabBarController?.tabBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.layoutIfNeeded()
    }


    func makeACall(_ phone: String) {
        let path = "tel://\(phone)"
        openLink(path)
    }

    func openLink(_ path: String) {
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

    func openLinkInApp(_ path: String) {
        guard let url = URL(string: path),
              UIApplication.shared.canOpenURL(url) else {
            BannerTop.showToast(message: "Данная ссылка не активна!", and: .systemRed)
            return
        }
        guard let tabBarController = tabBarController else {
            present(url: url)
            return
        }
        tabBarController.present(url: url)
    }

    func openLinkInApp(_ path: String, _ completion: @escaping (() -> ())) {
        guard let url = URL(string: path),
              UIApplication.shared.canOpenURL(url) else {
            BannerTop.showToast(message: "Данная ссылка не активна!", and: .systemRed)
            return
        }
        guard let tabBarController = tabBarController else {
            presentWithDismissed(urlRequest: .init(url: url), completion: completion)
            return
        }
        tabBarController.presentWithDismissed(urlRequest: .init(url: url), completion: completion)
    }

    @objc private func presentWithDismissed(urlRequest: URLRequest, completion: (() -> Void)? = nil) {
        let web = MHWebViewController()
        web.modalPresentationStyle = .overCurrentContext
        web.request = urlRequest
        web.dismissed = completion
        present(web, animated: true, completion: nil)
    }

    func getSafeAreaLayoutGuideHeigth() -> CGFloat {
        let tabBarHeigth = self.tabBarController?.tabBar.bounds.height ?? 0
        let navHeight = self.navigationController?.navigationBar.bounds.height ?? 0
        return Constants.screenHeight - (tabBarHeigth + navHeight + Constants.statusBarHeigth)
    }

    func getImagesFromAssets(assets: [PHAsset]) -> [Image] {
        var images: [Image] = []
        assets.forEach { asset in
            let image = self.getAssetThumbnail(asset: asset)
            let assetResources = PHAssetResource.assetResources(for: asset)
            images.append(.init(id: UUID().uuidString,
                                image: image,
                                title: assetResources.first?.originalFilename,
                                size: image.sizeInMB)) }
        return images
    }

    func getImagesFromAssets(imgs: [UIImage]) -> [Image] {
        var images: [Image] = []
        imgs.forEach { img in
            let title = String(describing: UUID().uuidString.prefix(14))
            images.append(.init(id: UUID().uuidString,
                                image: img,
                                title: title,
                                size: img.sizeInMB)) }
        return images
    }

    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 1000, height: 1000),
                             contentMode: .aspectFill,
                             options: option,
                             resultHandler: {(result, info) -> Void in
            thumbnail = result!
        })
        return thumbnail
    }
}

extension UIViewController {
    func getSenderFromSuperView(_ sender: UIButton,
                                _ animateViewTo: AnimateViewTo,
                                _ collectionView: UICollectionView,
                                _ isAdded: Bool) {
        let senderPosition : CGPoint = sender.convert(sender.bounds.origin, to: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: senderPosition) {
            getSenderPosition(animateViewTo, indexPath, collectionView, isAdded)
        }
    }

    fileprivate func getSenderPosition(_ animateViewTo: AnimateViewTo,
                                       _ indexPath: IndexPath,
                                       _ collectionView: UICollectionView,
                                       _ isAdded: Bool) {
        var senderBtnPosition : CGPoint = .zero
        var currentView: UIImageView = .init()
        if isAdded {
            switch animateViewTo {
            case .toBasket:
                getCurrentViewFromBasket(indexPath, &senderBtnPosition, &currentView, collectionView)
            case .toFavorite:
                getCurrentViewFromFavourite(indexPath, &senderBtnPosition, &currentView, collectionView)
            }
            zoomCurrentView(currentView, animateViewTo, senderBtnPosition, isAdded)
        } else {
            switch animateViewTo {
            case .toBasket:
                guard let basketCount = AppSession.basketCount, basketCount > 0 else {
                    return
                }
                changeBasketBadgeValue(false, 1)
                if let cell = collectionView.cellForItem(at: indexPath) as? DrugGridCVCell {
                    senderBtnPosition = cell.basketBtn.convert(cell.basketBtn.bounds.origin,
                                                               to: (view as? UICollectionView))
                    currentView.image = cell.basketBtn.imageView?.image
                    currentView.frame = cell.basketBtn.frame
                } else if let cell = collectionView.cellForItem(at: indexPath) as? DrugListCVCell {
                    senderBtnPosition = cell.basketBtn.convert(cell.basketBtn.bounds.origin,
                                                               to: (view as? UICollectionView))
                    currentView.image = cell.basketBtn.imageView?.image
                    currentView.frame = cell.basketBtn.frame
                }
                let tabBarItemsCount: CGFloat = CGFloat(self.tabBarController?.tabBar.items?.count ?? 0)
                let tabBarItemWidth: CGFloat = (Constants.screenWidth - ((tabBarItemsCount + 1) * 2))/tabBarItemsCount

                let currenntViewX: CGFloat = ((tabBarItemWidth * (animateViewTo == .toBasket ? 3 : 4)) - currentView.frame.size.width - (animateViewTo == .toBasket ? 2 * 3 : 2 * 4))
                let currenntViewY = (Constants.screenHeight - (self.tabBarController?.tabBar.frame.size.height ?? 0.0))
                currentView.frame.origin.x = currenntViewX
                currentView.frame.origin.y = currenntViewY
                zoomCurrentView(currentView, animateViewTo, senderBtnPosition, isAdded)
            case .toFavorite:
                guard let favouritesCount = AppSession.favouritesCount, favouritesCount > 0 else {
                    return
                }
                changeFavouritesbadgeValue(false, 1)
                if let cell = collectionView.cellForItem(at: indexPath) as? DrugGridCVCell {
                    senderBtnPosition = cell.favouriteBtn.convert(cell.favouriteBtn.bounds.origin,
                                                                  to: (view as? UICollectionView))
                    currentView.image = Asset.icUnselectedHeartWithBorder.image
                    currentView.frame = cell.favouriteBtn.frame
                } else if let cell = collectionView.cellForItem(at: indexPath) as? DrugListCVCell {
                    senderBtnPosition = cell.favouriteBtn.convert(cell.favouriteBtn.bounds.origin,
                                                                  to: (view as? UICollectionView))
                    currentView.image = Asset.icUnselectedHeartWithBorder.image
                    currentView.frame = cell.favouriteBtn.frame
                }
                let tabBarItemsCount: CGFloat = CGFloat(self.tabBarController?.tabBar.items?.count ?? 0)
                let tabBarItemWidth: CGFloat = (Constants.screenWidth - ((tabBarItemsCount + 1) * 2))/tabBarItemsCount

                let currenntViewX: CGFloat = ((tabBarItemWidth * (animateViewTo == .toBasket ? 3 : 4)) - currentView.frame.size.width - (animateViewTo == .toBasket ? 2 * 3 : 2 * 4))
                let currenntViewY = (Constants.screenHeight - (self.tabBarController?.tabBar.frame.size.height ?? 0.0))
                currentView.frame.origin.x = currenntViewX
                currentView.frame.origin.y = currenntViewY

                zoomCurrentView(currentView, animateViewTo, senderBtnPosition, isAdded)
            }
        }
    }

    fileprivate func getCurrentViewFromBasket(_ indexPath: IndexPath,
                                              _ senderBtnPosition: inout CGPoint,
                                              _ currentView: inout UIImageView,
                                              _ collectionView: UICollectionView) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DrugGridCVCell {
            senderBtnPosition = cell.basketBtn.convert(cell.basketBtn.bounds.origin,
                                                       to: (view as? UICollectionView))
            currentView = UIImageView(frame: CGRect(x: senderBtnPosition.x,
                                                    y: senderBtnPosition.y,
                                                    width: cell.basketBtn.frame.size.width,
                                                    height: cell.basketBtn.frame.size.height))
            currentView.image = cell.basketBtn.imageView?.image
        } else if let cell = collectionView.cellForItem(at: indexPath) as? DrugListCVCell {
            senderBtnPosition = cell.basketBtn.convert(cell.basketBtn.bounds.origin,
                                                       to: (view as? UICollectionView))
            currentView = UIImageView(frame: CGRect(x: senderBtnPosition.x,
                                                    y: senderBtnPosition.y,
                                                    width: cell.basketBtn.frame.size.width,
                                                    height: cell.basketBtn.frame.size.height))
            currentView.image = cell.basketBtn.imageView?.image
        }
    }

    fileprivate func getCurrentViewFromFavourite(_ indexPath: IndexPath,
                                                 _ senderBtnPosition: inout CGPoint,
                                                 _ currentView: inout UIImageView,
                                                 _ collectionView: UICollectionView) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DrugGridCVCell {
            senderBtnPosition = cell.favouriteBtn.convert(cell.favouriteBtn.bounds.origin,
                                                          to: (view as? UICollectionView))
            currentView = UIImageView(frame: CGRect(x: senderBtnPosition.x,
                                                    y: senderBtnPosition.y,
                                                    width: cell.favouriteBtn.frame.size.width,
                                                    height: cell.favouriteBtn.frame.size.height))
            currentView.image = cell.favouriteBtn.imageView?.image
        } else if let cell = collectionView.cellForItem(at: indexPath) as? DrugListCVCell {
            senderBtnPosition = cell.favouriteBtn.convert(cell.favouriteBtn.bounds.origin,
                                                          to: (view as? UICollectionView))
            currentView = UIImageView(frame: CGRect(x: senderBtnPosition.x,
                                                    y: senderBtnPosition.y,
                                                    width: cell.favouriteBtn.frame.size.width,
                                                    height: cell.favouriteBtn.frame.size.height))
            currentView.image = cell.favouriteBtn.imageView?.image
        }
    }

    private func zoomCurrentView(_ currentView : UIView,
                                 _ animateViewTo: AnimateViewTo,
                                 _ senderBtnPosition: CGPoint,
                                 _ isAdded: Bool)  {
        view.addSubview(currentView)
        UIView.animate(withDuration: 0.5) {
            currentView.animationZoom(scaleX: 1.5, y: 1.5)
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.moveCurrentViewToPointB(currentView, animateViewTo, isAdded, senderBtnPosition)
        }
    }

    fileprivate func moveCurrentViewToPointB(_ currentView : UIView,
                                             _ animateViewTo: AnimateViewTo,
                                             _ isAdded: Bool,
                                             _ senderBtnPosition: CGPoint) {
        UIView.animate(withDuration: 0.7, animations: {
            currentView.pulsate()
            currentView.animationZoom(scaleX: 1.2, y: 1.2)
            currentView.animationRoted(angle: CGFloat(Double.pi))

            if isAdded {
                let tabBarItemsCount: CGFloat = CGFloat(self.tabBarController?.tabBar.items?.count ?? 0)
                let tabBarItemWidth: CGFloat = (Constants.screenWidth - ((tabBarItemsCount + 1) * 2))/tabBarItemsCount

                let currenntViewX: CGFloat = ((tabBarItemWidth * (animateViewTo == .toBasket ? 3 : 4)) - currentView.frame.size.width - (animateViewTo == .toBasket ? 2 * 3 : 2 * 4))
                let currenntViewY = (Constants.screenHeight - (self.tabBarController?.tabBar.frame.size.height ?? 0.0))
                currentView.frame.origin.x = currenntViewX
                currentView.frame.origin.y = currenntViewY
            } else {
                currentView.frame.origin.x = senderBtnPosition.x
                currentView.frame.origin.y = senderBtnPosition.y
            }
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            if isAdded {
                switch animateViewTo {
                case .toFavorite:
                    self.changeFavouritesbadgeValue(true, 1)
                case .toBasket:
                    self.changeBasketBadgeValue(true , 1)
                }
                self.removeCurrentViewAndAnimateViewB(currentView, animateViewTo)
            } else {
                currentView.removeFromSuperview()
            }
        })
    }

    func changeFavouritesbadgeValue(_ isAdded: Bool, _ count: Int) {
        if let controllersCount = self.tabBarController?.viewControllers?.count, controllersCount > 3 {
            let favouritesCount = AppSession.favouritesCount ?? 0
            AppSession.favouritesCount = isAdded ? (favouritesCount + count) : ((favouritesCount >= count) ? favouritesCount - count : 0)
            if let favouritesCount = AppSession.favouritesCount, favouritesCount > 0 {
                self.tabBarController?.viewControllers?[3].tabBarItem.badgeValue = "\(favouritesCount)"
            } else {
                self.tabBarController?.viewControllers?[3].tabBarItem.badgeValue = nil
            }
        }
    }
    
    func changeBasketBadgeValue(_ isAdded: Bool, _ count: Int) {
        if let controllersCount = self.tabBarController?.viewControllers?.count, controllersCount > 2 {
            let basketCount = AppSession.basketCount ?? 0
            AppSession.basketCount = isAdded ? (basketCount + count) : ((basketCount >= count) ? basketCount - count : 0)
            if let basketCount = AppSession.basketCount, basketCount > 0 {
                self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = "\(basketCount)"
            } else {
                self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = nil
            }
        }
    }

    fileprivate func removeCurrentViewAndAnimateViewB(_ currentView : UIView,
                                                      _ animateViewTo: AnimateViewTo) {
        currentView.removeFromSuperview()
        guard let view = self.tabBarController?.tabBar.items?[animateViewTo == .toBasket ? 2 : 3].value(forKey: "view") as? UIView else {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            view.animationZoom(scaleX: 1.5, y: 1.5)
        }, completion: {_ in
            UIView.animate(withDuration: 0.5) {
                view.animationZoom(scaleX: 1.0, y: 1.0)
            }
        })
    }
}
