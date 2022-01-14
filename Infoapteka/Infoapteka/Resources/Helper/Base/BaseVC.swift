//
//  BaseVC.swift
//  Infoapteka
//
//  
//

import UIKit
import NVActivityIndicatorView

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = .top
        extendedLayoutIncludesOpaqueBars = true
    }

    func startIndicatorAnimation() {
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.keyWindow else { return }
            let blackView = UIView(frame: keyWindow.frame)
            blackView.accessibilityIdentifier = "blackView"
            blackView.alpha = 0.0
            blackView.backgroundColor = Asset.mainBlack.color.withAlphaComponent(0.2)
            keyWindow.addSubview(blackView)
            
            let loading = NVActivityIndicatorView(frame: .zero, type: .ballPulse, color: .systemRed, padding: 0)
            loading.translatesAutoresizingMaskIntoConstraints = false
            loading.accessibilityIdentifier = "NVActivityIndicatorView"
            keyWindow.addSubview(loading)
            
            loading.snp.remakeConstraints { make in
                make.height.width.equalTo(40)
                make.center.equalToSuperview()
            }
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut, animations: {
                            blackView.alpha = 1
                           }) { _ in
                loading.startAnimating()
            }
        }
    }
    
    func stopIndicatorAnimation() {
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.keyWindow else { return }
            let blackViews = keyWindow.subviews.filter({ $0.accessibilityIdentifier == "blackView" })
            let loadings = keyWindow.subviews.filter({ $0.accessibilityIdentifier == "NVActivityIndicatorView" })
            
            UIView.animate(withDuration: 0.2, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                blackViews.forEach { $0.alpha = 0 }
            }) { _ in
                blackViews.first?.removeFromSuperview()
                
                (loadings.first as? NVActivityIndicatorView)?.stopAnimating()
                loadings.first?.removeFromSuperview()
            }
        }
    }

    @objc func keyboardNotification(notification: NSNotification,
                                    _ height: CGFloat,
                                    _ completion: @escaping ((CGFloat) -> Void)) {
        guard let userInfo = notification.userInfo else { return }

        guard let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let endFrameY = endFrame.origin.y
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)

        let constant: CGFloat = endFrameY >=
            Constants.safeAreaHeight ? height :
            (endFrame.size.height - height)

        UIView.animate(withDuration: duration, delay: 0, options: animationCurve, animations: {
            self.view.layoutIfNeeded()
        })
        completion(constant)
    }

    func checkTitleView(_ types: [InfoaptekaNavBarField],
                        _ delegate: InfoaptekaNavBarSearchViewDelegate? = nil) {
        var navTitleView = self.navigationController?.visibleViewController?.navigationItem.titleView
        let infoaptekaNavBarSearchView = navTitleView?.subviews
            .compactMap { $0.accessibilityIdentifier }
            .filter { $0 == String(describing: InfoaptekaNavBarSearchView.self) }
            .first
        guard infoaptekaNavBarSearchView != nil else {
            createInfoaptekaNavBarSearchView(types, &navTitleView, delegate)
            return
        }
    }
 
    private func createInfoaptekaNavBarSearchView(_ types: [InfoaptekaNavBarField],
                                                  _ navTitleView: inout UIView?,
                                                  _ delegate: InfoaptekaNavBarSearchViewDelegate?) {
        guard var navBarWidth = navigationController?.navigationBar.bounds.size.width else { return }
        if ((navigationController?.viewControllers.count ?? 0) > 1) && !navigationItem.hidesBackButton {
            navBarWidth = navBarWidth - 44
        }
        let titleViewFrame = CGRect(x: -8, y: 0, width: navBarWidth, height: 44)
        let titleView = InfoaptekaNavBarSearchView(types)
        titleView.accessibilityIdentifier = String(describing: InfoaptekaNavBarSearchView.self)
        titleView._delegate = delegate

        navTitleView = .init(frame: titleViewFrame)
        titleView.frame = navTitleView?.frame ?? .zero
        navTitleView?.addSubview(titleView)
        self.navigationController?.visibleViewController?.navigationItem.titleView = navTitleView
    }
    
    func setupPullToTVRefreshControl(_ selector: Selector, _ tableView: UITableView) {
        let refreshControl = UIRefreshControl(frame: .init(x: 0, y: 0, width: 12, height: 12))
        refreshControl.addTarget(self, action: selector, for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func setupPullToCVRefreshControl(_ selector: Selector, _ collectionView: UICollectionView) {
        let refreshControl = UIRefreshControl()
        refreshControl.bounds = .init(x: 0, y: 0, width: 24, height: 24)
        refreshControl.addTarget(self, action: selector, for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
}
