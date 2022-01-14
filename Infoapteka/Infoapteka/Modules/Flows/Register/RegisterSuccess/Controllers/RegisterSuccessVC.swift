//
//  RegisterSuccessVC.swift
//  Infoapteka
//
//

import UIKit

extension RegisterSuccessVC {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color

        let infoLblextColor: UIColor = Asset.mainBlack.color
        let infoLblTextFont: UIFont = FontFamily.Inter.bold.font(size: 20)
        let infoLblText: String = L10n.successRegisterInfo

        let submitBtnWidth: CGFloat = Constants.screenWidth - 40
        let submitBtnnTitle: String = L10n.onGeneral
        let submitBtnTitleFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let registerButtonTextColor: UIColor = Asset.mainWhite.color
        let registerBtnBackgroundColor: UIColor = Asset.mainGreen.color
    }
}

class RegisterSuccessVC: BaseVC {

    lazy private var iconIV: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = Asset.icRegisterSuccess.image
        return view
    }()

    lazy private var infoLbl: UILabel = {
        let view = UILabel()
        view.textColor = appearance.infoLblextColor
        view.font = appearance.infoLblTextFont
        view.text = appearance.infoLblText
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()

    private lazy var submitBtn: UIButton = {
        let view = UIButton()
        view.setTitleColor(appearance.registerButtonTextColor, for: .normal)
        view.setTitle(appearance.submitBtnnTitle, for: .normal)
        view.titleLabel?.font = appearance.submitBtnTitleFont
        view.backgroundColor = appearance.registerBtnBackgroundColor
        return view
    }()

    private var appearance = Appearance()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = appearance.backgroundColor

        self.view.addSubview(self.infoLbl)
        self.view.addSubview(self.iconIV)
        self.view.addSubview(self.submitBtn)

        self.infoLbl.snp.remakeConstraints { make in
            make.bottom.equalTo(self.view.snp.centerY)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        self.iconIV.snp.remakeConstraints { make in
            make.bottom.equalTo(self.infoLbl.snp.top).offset(-16)
            make.height.width.equalTo(64)
            make.centerX.equalToSuperview()
        }

        let submitBtnWidth: CGFloat = self.view.bounds.size.width - 32
        let submitBtnHeight: CGFloat = submitBtnWidth * 0.12
        self.submitBtn.layer.cornerRadius = submitBtnHeight/2

        self.submitBtn.addTarget(self, action: #selector(didTappedSubmitBtn), for: .touchUpInside)
        self.submitBtn.snp.remakeConstraints { make in
            make.top.equalTo(self.infoLbl.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(submitBtnWidth)
            make.height.equalTo(submitBtnHeight)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @objc private func didTappedSubmitBtn() {
        self.submitBtn.pulsate()
        self.view.window?.rootViewController = InfoaptekaTabBarController(.init())
    }
}
