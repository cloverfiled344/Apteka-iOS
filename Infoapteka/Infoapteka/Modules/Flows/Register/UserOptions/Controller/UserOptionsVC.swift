//
//  UserOptionsVC.swift
//  Infoapteka
//
//  
//

import UIKit
import ActiveLabel

// MARK: Appearance
extension UserOptionsVC {
    struct Appearance {
        let viewBackgroundColor: UIColor = Asset.mainWhite.color

        let logoIV: UIImage = Asset.icLaunch.image
        let logoIVContentMode: UIImageView.ContentMode = .scaleAspectFill
        let logoIVBottomMargin: CGFloat = 16.0

        let isHasAccountLabelTextColor: UIColor = Asset.secondaryGray.color
        let isHasAccountLabelTextFont: UIFont = FontFamily.Inter.medium.font(size: 15)
        let isHasAccountText: String = L10n.isHasAccount
        let titleLblBottomMargin: CGFloat = 8.0
        let loginTextColor: UIColor = Asset.mainGreen.color

        let subtitleNumberOfLines: Int = 0
        let subtitleBottomMargin: CGFloat = 18.0

        let subtitleLabelTextColor: UIColor = Asset.mainBlack.color
        let subtitleLabelTextFont: UIFont = FontFamily.Inter.bold.font(size: 24)
        let subtitleText: String = L10n.registerDescription
        let loginText: String = L10n.login
        let contentLabelIsUserInteraction: Bool = true

        let customerImage: UIImage = Asset.icCustomerOption.image
        let customerViewBottomMargin: CGFloat = 79.0
        let customerViewLeftMargin: CGFloat = 20.0
        let customerViewRightMargin: CGFloat = 5.0

        let sellerViewBottomMargin: CGFloat = 79.0
        let sellerViewRightMargin: CGFloat = 20.0
        let sellerViewLeftMargin: CGFloat = 5.0

        let sellerImage: UIImage = Asset.icSellerOption.image
        let customerText: String = L10n.customer
        let sellerText: String = L10n.seller

    }
}

class UserOptionsVC: UIViewController {

    // MARK: -- UI Components
    private lazy var logoIV: UIImageView = {
        let view = UIImageView()
        view.contentMode = appearance.logoIVContentMode
        view.image = appearance.logoIV
        return view
    }()

    private lazy var subtitleLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = appearance.subtitleNumberOfLines
        view.text = appearance.subtitleText
        view.textColor = appearance.subtitleLabelTextColor
        view.font = appearance.subtitleLabelTextFont
        view.sizeToFit()
        return view
    }()
    
    private lazy var customerView: UserOptionsView = {
        let view = UserOptionsView(.Клиент,
                                   appearance.customerImage,
                                   appearance.customerText)
        return view
    }()
    
    private lazy var sellerView: UserOptionsView = {
        let view = UserOptionsView(.Продавец,
                                   appearance.sellerImage,
                                   appearance.sellerText)
        return view
    }()
    
    // MARK: Properties
    private let appearance = Appearance()
    private var viewModel: AuthVM

    init(_ viewModel: AuthVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setConstraints()
    }
}

// MARK: Setup UI
extension UserOptionsVC {
    
    private func setupUI() {
        self.view.backgroundColor = appearance.viewBackgroundColor

        self.view.addSubview(customerView)
        self.view.addSubview(sellerView)

        self.view.addSubview(subtitleLbl)
        self.view.addSubview(logoIV)
        self.addGestureToViews()
    }
    
    private func setConstraints() {

        let margins: CGFloat = appearance.customerViewLeftMargin + appearance.sellerViewRightMargin + appearance.customerViewRightMargin + appearance.sellerViewLeftMargin
        let customerSellerViewsHeight = ((Constants.screenWidth - margins) / 2) * 1.5

        self.customerView.snp.remakeConstraints { (maker) in
            maker.left.equalToSuperview()
                .offset(appearance.customerViewLeftMargin)
            maker.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom)
                .offset(-appearance.customerViewBottomMargin)
            maker.right.equalTo(self.view.snp.centerX).offset(-appearance.customerViewRightMargin)
            maker.height.equalTo(customerSellerViewsHeight)
        }

        self.sellerView.snp.remakeConstraints { (maker) in
            maker.right.equalToSuperview()
                .offset(-appearance.customerViewLeftMargin)
            maker.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom)
                .offset(-appearance.customerViewBottomMargin)
            maker.left.equalTo(self.view.snp.centerX)
                .offset(appearance.sellerViewLeftMargin)
            maker.height.equalTo(customerSellerViewsHeight)
        }

        self.subtitleLbl.snp.remakeConstraints { maker in
            maker.left.equalTo(self.customerView.snp.left)
            maker.right.equalTo(self.sellerView.snp.right)
            maker.bottom.equalTo(self.customerView.snp.top)
                .offset(-appearance.subtitleBottomMargin)
        }

        let logoIVWidth: CGFloat = Constants.screenWidth / 2
        self.logoIV.snp.remakeConstraints { (maker) in
            maker.width.equalTo(logoIVWidth)
            maker.height.equalTo(logoIVWidth)
            maker.centerX.equalToSuperview()
            maker.bottom.greaterThanOrEqualTo(self.subtitleLbl.snp.top)
                .offset(-appearance.logoIVBottomMargin)
        }
    }

    private func addGestureToViews() {
        self.customerView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                      action: #selector(didTappedOnCustomerView)))
        self.sellerView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                    action: #selector(didTappedOnSellerView)))
    }
    
    @objc private func didTappedOnCustomerView() {
        viewModel.type = .Клиент
        navigationController?.pushViewController(RegisterVC(.init(viewModel.type,
                                                                       viewModel.phone)),
                                                      animated: true)
    }
    
    @objc private func didTappedOnSellerView() {
        viewModel.type = .Продавец
        self.navigationController?.pushViewController(RegisterVC(.init(viewModel.type,
                                                                       viewModel.phone)),
                                                      animated: true)
    }
}


/*
    lazy private var titleLbl: ActiveLabel = {
        let view = ActiveLabel()
        view.sizeToFit()

        view.numberOfLines = 0
        view.lineSpacing = 4
        view.text = "\(appearance.isHasAccountText) \(appearance.loginText)"
        view.font =      appearance.isHasAccountLabelTextFont
        view.textColor = appearance.isHasAccountLabelTextColor

        let customType = ActiveType.custom(pattern: "\\\(appearance.loginText)\\b")
        view.enabledTypes.append(customType)

        view.customize { [weak self] label in
            label.customColor[customType] = appearance.loginTextColor
            label.handleCustomTap(for: customType) { [weak self] _ in
                print("handleCustomTap")
            }
        }
        return view
    }()

        self.view.addSubview(titleLbl)
        self.titleLbl.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.customerView.snp.left)
            maker.right.equalTo(self.sallerView.snp.right)
            maker.bottom.equalTo(self.subtitleLbl.snp.top)
                .offset(-appearance.titleLblBottomMargin)
        }
 */
