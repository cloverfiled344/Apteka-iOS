//
//  OnboardingItemVC.swift
//  Infoapteka
//
//

import UIKit

protocol OnboardingItemDelegate {
    func didTappedSkipBtn()
}

extension OnboardingItemVC {
    struct Appearance {
        let skipBtnTitle: String = L10n.skip
        let skipBtnTitleFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let skipBtnHeigth: CGFloat = 32
        let skipBtnMargin: CGFloat = 24
        let skipBtnWidth: CGFloat = 124

        let iconIVContentMode: UIView.ContentMode = .scaleAspectFill
        let iconIVMasksToBounds: Bool = true
        let iconIVBackgroundColor: UIColor = .clear
        let iconIVClipsToBounds: Bool = true
        let iconIVWidth: CGFloat = 284.0
        let iconIVHeight: CGFloat = 210.0
        let iconIVMargin: CGFloat = 16.0

        let titleLblNumberOfLines: Int = 4
        let titleLblLineBreakMode: NSLineBreakMode = .byWordWrapping
        let titleLblFont: UIFont = FontFamily.Inter.light.font(size: 24)
        let titleLblTopMargin: CGFloat = 16.0
        let titleLblLeftRightMargin: CGFloat = 36.0
    }
}

class OnboardingItemVC: BaseVC {

    private lazy var skipBtn: UIButton = {
        let view = UIButton()
        view.contentHorizontalAlignment = .right
        view.setTitle(appearance.skipBtnTitle, for: .normal)
        view.titleLabel?.font = appearance.skipBtnTitleFont
        view.setTitleColor(page.titleColor, for: .normal)
        return view
    }()

    private lazy var iconIV: UIImageView = {
        let view = UIImageView()
        view.contentMode = appearance.iconIVContentMode
        view.layer.masksToBounds = appearance.iconIVMasksToBounds
        view.backgroundColor = appearance.iconIVBackgroundColor
        view.clipsToBounds = appearance.iconIVClipsToBounds
        view.image = page.icon.image
        return view
    }()

    private lazy var titleLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = appearance.titleLblNumberOfLines
        view.lineBreakMode = appearance.titleLblLineBreakMode
        view.font = appearance.titleLblFont
        view.text = page.title
        view.textColor = page.titleColor
        return view
    }()

    private var page: OBPage
    private var numberOfPages: Int
    private let appearance = Appearance()
    private var _delegate: OnboardingItemDelegate

    init(_ page: OBPage, _ delegate: OnboardingItemDelegate, _ numberOfPages: Int) {
        self.page = page
        self.numberOfPages = numberOfPages
        self._delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    private func setupUI() {
        self.view.addSubview(self.skipBtn)
        self.skipBtn.addTarget(self, action: #selector(didTappedSkipBtn), for: .touchUpInside)

        self.view.addSubview(self.iconIV)
        self.view.addSubview(self.titleLbl)

        self.view.backgroundColor = page.backgroundColor

        self.setupMaker()
    }

    private func setupMaker() {
        self.skipBtn.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-appearance.skipBtnMargin)
            maker.height.equalTo(appearance.skipBtnHeigth)
            maker.top.equalTo(self.view.snp.top).offset(appearance.skipBtnMargin + 16)
            maker.width.equalTo(appearance.skipBtnWidth)
        }

        self.iconIV.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.snp.centerY).offset(-appearance.iconIVMargin)
            make.centerX.equalToSuperview()
            make.width.equalTo(appearance.iconIVWidth)
            make.height.equalTo(appearance.iconIVHeight)
        }

        self.titleLbl.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.centerY).offset(appearance.titleLblTopMargin)
            make.centerX.equalToSuperview()
            make.left.equalTo(self.iconIV.snp.left).offset(appearance.titleLblLeftRightMargin)
            make.right.equalTo(self.iconIV.snp.right).offset(-appearance.titleLblLeftRightMargin)
        }
    }

    @objc private func didTappedSkipBtn() {
        skipBtn.pulsate(sender: self.skipBtn)
        _delegate.didTappedSkipBtn()
    }
}
