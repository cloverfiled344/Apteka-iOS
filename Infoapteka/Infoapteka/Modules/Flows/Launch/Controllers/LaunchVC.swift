//
//  LaunchVC.swift
//  Infoapteka
//
//

import UIKit

extension LaunchVC {
    fileprivate enum LaunchInstructor {
        case onboarding, main, networkError, serverError

        static func setup() -> LaunchInstructor {
            switch (AppSession.isSeenOnboarding, NetworkChecker.instance.isConnection()) {
            case (false, true):
                return .onboarding
            case (true, true):
                return .main
            case (_, false):
                return .networkError
            }
        }
    }

}

extension LaunchVC {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color

        let appLogoImage: UIImage = Asset.icLaunch.image
        let appLogoContentMode: UIView.ContentMode = .scaleAspectFit
        let appLogoMasksToBounds: Bool = true
        let appLogoBackgroundColor: UIColor = Asset.mainWhite.color
        let appLogoMargin: CGFloat = 36.0
    }
}

class LaunchVC: BaseVC {

    lazy private var appLogo: UIImageView = {
        let view = UIImageView()
        view.image = appearance.appLogoImage
        view.contentMode = appearance.appLogoContentMode
        view.layer.masksToBounds = appearance.appLogoMasksToBounds
        view.backgroundColor = appearance.appLogoBackgroundColor
        view.alpha = 0
        return view
    }()

    fileprivate var instructor: LaunchInstructor {
        return LaunchInstructor.setup()
    }
    private let appearance = Appearance()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = appearance.backgroundColor
        self.view.addSubview(self.appLogo)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let appLogoHeight: CGFloat = (Constants.screenWidth - (appearance.appLogoMargin * 2))
        let appLogoScaleHaight: CGFloat = appLogoHeight * 1.5
        self.appLogo.snp.remakeConstraints { make in
            make.centerY.equalTo(self.view.snp.centerY)
            make.left.equalToSuperview().offset(appearance.appLogoMargin)
            make.right.equalToSuperview().offset(-appearance.appLogoMargin)
            make.height.equalTo(appLogoScaleHaight)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.beginAlphaAnimation()
    }

    func beginAlphaAnimation() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            self.appLogo.alpha = 1
        }) { (isTrue) in
            self.endAlphaAnimation()
        }
    }

    fileprivate func endAlphaAnimation() {
        UIView.animate(withDuration: 1, delay: 1.5, options: .curveEaseIn, animations: {
            self.appLogo.alpha = 0
        }) { (isTrue) in
            self.performSwitch()
        }
    }

    private func performSwitch() {
        switch instructor {
        case .serverError:
            view.window?.rootViewController = CheckErrorVC(.server, .root)
        case .networkError:
            view.window?.rootViewController = CheckErrorVC(.network, .root)
        case .onboarding:
            view.window?.rootViewController = OnboardingVC(.init())
        case .main:
            view.window?.rootViewController = InfoaptekaTabBarController(.init())
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
