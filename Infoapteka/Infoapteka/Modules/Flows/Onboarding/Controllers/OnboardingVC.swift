//
//  OnboardingVC.swift
//  Infoapteka
//
//

import UIKit
import liquid_swipe
import IQKeyboardManagerSwift

extension OnboardingVC {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color

        let pageControllerCurrentPageIndicatorTintColor: UIColor = Asset.orange.color
        let pageControllerPageIndicatorTintColor: UIColor = Asset.secondaryGrayLight.color
        let pageControllerHeigth: CGFloat = 8
        let pageControllerWidth: CGFloat = 40
        let pageControllerTopBottomMargin: CGFloat = 48
    }
}

class OnboardingVC: LiquidSwipeContainerController, LiquidSwipeContainerDataSource {

    private var viewModel: OnboardingVM
    private var appearance = Appearance()

    init(_ viewModel: OnboardingVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = appearance.backgroundColor

        self.viewModel.fetchPages(self) {}
        self.datasource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        IQKeyboardManager.shared.enable = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        IQKeyboardManager.shared.enable = true
    }

    func numberOfControllersInLiquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController) -> Int {
        return self.viewModel.getLiquidSwipeContainerCount()
    }

    func liquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController,
                              viewControllerAtIndex index: Int) -> UIViewController {
        guard let item = self.viewModel.getItem(index) else { return .init() }
        return item
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension OnboardingVC: OnboardingItemDelegate {
    func didTappedSkipBtn() {
        AppSession.isSeenOnboarding = true
        self.view.window?.rootViewController = InfoaptekaTabBarController(.init())
    }
}
