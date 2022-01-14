//
//  SignInVC.swift
//  Infoapteka
//
//

import UIKit
import IQKeyboardManagerSwift

extension AuthSignInVC {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color
        let flipViewBottomMargin: CGFloat = 48.0
    }
}

class AuthSignInVC: BaseVC {

    private lazy var signInView: AuthSignInView = { AuthSignInView(self) }()
    private var flipView: UIView = { UIView() }()

    private let appearance = Appearance()
    private var viewModel: AuthVM

    init(_ viewModel: AuthVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupKeyboardNatification()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

private extension AuthSignInVC {
    func setupUI() {
        setupView()
        setupFlipView()
    }

    func setupView() {
        view.backgroundColor = appearance.backgroundColor
        setNavBarBackColor(title: "",
                           statusBarBackColor: .white,
                           navBarBackColor: .white,
                           navBarTintColor: .white,
                           prefersLargeTitles: false)
    }

    func setupFlipView() {
        view.addSubview(flipView)
        flipView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(view.layoutMarginsGuide)
            maker.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).offset(-appearance.flipViewBottomMargin)
        }

        flipView.addSubview(signInView)
        configureSignInView(appearance.flipViewBottomMargin)
    }

    func configureSignInView(_ bottomOffset: CGFloat) {
        signInView.snp.remakeConstraints { (maker) in
            maker.top.left.right.equalTo(flipView)
            maker.bottom.equalTo(flipView.snp.bottom).offset(-bottomOffset)
        }
    }

    func setupKeyboardNatification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupKeyboardNatification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    @objc private func setupKeyboardNatification(notification: NSNotification) {
        keyboardNotification(notification: notification,
                             appearance.flipViewBottomMargin) { [weak self] flipViewBottomOffset in
            self?.configureSignInView(flipViewBottomOffset)
        }
    }
}

extension AuthSignInVC: AuthSignInViewDelegate {
    func didTappedLoginBtn(_ phoneNumber: String,
                           complation: @escaping () -> ()) {
        view.endEditing(true)
        startIndicatorAnimation()
        viewModel.verifyPhoneNumber(phoneNumber) { [weak self] success in
            guard let self = self else { return }
            self.stopIndicatorAnimation()
            if success {
                let authCodeConfirmVC = AuthCodeConfirmVC(self.viewModel)
                self.navigationController?.pushViewController(authCodeConfirmVC, animated: true)
                complation()
            } else { complation() }
        }
    }
}
