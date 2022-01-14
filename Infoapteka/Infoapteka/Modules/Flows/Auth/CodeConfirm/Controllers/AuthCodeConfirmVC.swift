//
//  AuthCodeConfirmVC.swift
//  Infoapteka
//
//

import UIKit
import IQKeyboardManagerSwift

extension AuthCodeConfirmVC {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color

        let flipViewBottomMargin: CGFloat = 48.0
    }
}

class AuthCodeConfirmVC: BaseVC {

    lazy private var codeConfirmView: AuthCodeConfirmView = {
        let view = AuthCodeConfirmView(viewModel.phone)
        return view
    }()
    private var flipView: UIView = UIView()

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
        self.setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupKeyboardNatification()
    }

    @objc func didTappedAuthCodeConfirmVCLeftBtn() {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

private extension AuthCodeConfirmVC {
    func setupUI() {
        self.setupView()
        self.setupFlipView()
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
        self.view.addSubview(self.flipView)
        self.flipView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view.layoutMarginsGuide)
            maker.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom).offset(-appearance.flipViewBottomMargin)
        }

        self.flipView.addSubview(self.codeConfirmView)
        self.codeConfirmView.delegate = self
        self.configureSignInView(appearance.flipViewBottomMargin)
    }
    
    func configureSignInView(_ bottomOffset: CGFloat) {
        self.codeConfirmView.snp.remakeConstraints { (maker) in
            maker.top.left.right.equalTo(self.flipView)
            maker.bottom.equalTo(self.flipView.snp.bottom).offset(-bottomOffset)
        }
    }

    func setupKeyboardNatification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupKeyboardNatification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    @objc private func setupKeyboardNatification(notification: NSNotification) {
        self.keyboardNotification(notification: notification,
                                  appearance.flipViewBottomMargin) { [weak self] flipViewBottomOffset in
            self?.configureSignInView(flipViewBottomOffset)
        }
    }
}

extension AuthCodeConfirmVC: AuthCodeConfirmViewDelegate {
    func didTappedTrySendSms() {
        viewModel.tryVerifyPhoneNumber { [weak self] success in
            guard let self = self else { return }
            if success {
                self.codeConfirmView.updateScheduledTimer()
            }
        }
    }

    func didTappedIncorrectNumberLbl() {
        self.navigationController?.popViewController(animated: true)
    }

    func didTappedConfirmBtn(_ verificationCode: String, complation: @escaping () -> ()) {
        startIndicatorAnimation()
        viewModel.signIn(verificationCode) { [weak self] success, isActive in
            guard let self = self else { return }
            self.stopIndicatorAnimation()
            if success && isActive {
                self.view.window?.rootViewController = InfoaptekaTabBarController(.init())
                complation()
            } else if !isActive {
                let userOptionsVC = UserOptionsVC(self.viewModel)
                self.navigationController?.pushViewController(userOptionsVC, animated: true)
                complation()
            }
        }
    }
}
