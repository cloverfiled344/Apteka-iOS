//
//  CheckErrorVC.swift
//  Infoapteka
//
//

import UIKit
import SnapKit

extension CheckErrorVC {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color
        let contentLeftRightMargin: CGFloat = 30
    }
}

class CheckErrorVC: BaseVC, NetworkErrorViewDelegate {

    private let appearance = Appearance()
    private var showtype: CheckErrorVCShowType
    private var dismissType: CheckErrorVCDismissType

    lazy private var contentView: UIView = {
        showtype == .network ? NetworkErrorView(for: self) : ServerErrorView()
    }()

    init(_ showtype: CheckErrorVCShowType,
         _ dismissType: CheckErrorVCDismissType) {
        self.showtype = showtype
        self.dismissType = dismissType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = appearance.backgroundColor
        view.addSubview(contentView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func checkNetwork() {
        switch (dismissType, NetworkChecker.instance.isConnection()) {
        case (.root, true):
            self.view.window?.rootViewController = LaunchVC()
        case (.pop, true):
            self.navigationController?.popViewController(animated: true)
        case (.dismiss, true):
            self.dismiss(animated: true, completion: nil)
        case (.root, false):
            BannerTop.showToast(message: L10n.networkErrorInfo, and: .systemRed)
        case (.pop, false):
            BannerTop.showToast(message: L10n.networkErrorInfo, and: .systemRed)
        case (.dismiss, false):
            BannerTop.showToast(message: L10n.networkErrorInfo, and: .systemRed)
        }
    }
}

extension ServerErrorView {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color

        let titleLblTextColor: UIColor = Asset.secondaryGray.color
        let titleLblNumberOfLines: Int = 0
        let titleLblTextFont: UIFont = FontFamily.Inter.bold.font(size: 15)
        let titleLblTextAligment: NSTextAlignment = .center
        let titleLblBackgroundColor: UIColor = Asset.mainWhite.color

        let networkErrorInfo: String = L10n.unavailableServerInfo

        let iconImage: UIImage = Asset.icServerError.image
        let iconWidth: CGFloat = 250.0
    }
}

class ServerErrorView: UIView {

    private lazy var titleLbl: PaddingLbl = {
        let view = PaddingLbl(withInsets: 16, 16, 24, 24)
        view.textColor = appearance.titleLblTextColor
        view.font = appearance.titleLblTextFont
        view.textAlignment = appearance.titleLblTextAligment
        view.backgroundColor = appearance.titleLblBackgroundColor
        view.numberOfLines = appearance.titleLblNumberOfLines
        view.text = appearance.networkErrorInfo
        return view
    }()

    private lazy var iconIV: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = appearance.iconImage
        return view
    }()

    private let appearance = Appearance()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = appearance.backgroundColor
        addSubview(titleLbl)
        addSubview(iconIV)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLbl.snp.remakeConstraints { (maker) in
            maker.left.right.centerX.equalToSuperview()
            maker.top.equalTo(snp.centerY).offset(8.0)
        }

        iconIV.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.height.width.equalTo(appearance.iconWidth)
            maker.bottom.equalTo(titleLbl.snp.top).offset(-8.0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NetworkErrorView {
    struct Appearance {
        let backgroundColor     : UIColor = Asset.mainWhite.color

        let titleLblTextColor   : UIColor = Asset.secondaryGray.color
        let titleLblNumberOfLines: Int = 0
        let titleLblTextFont: UIFont = FontFamily.Inter.bold.font(size: 15)
        let titleLblTextAligment: NSTextAlignment = .center
        let titleLblBackgroundColor: UIColor = Asset.mainWhite.color

        let networkErrorInfo: String = L10n.networkErrorInfo

        let iconImage: UIImage = Asset.icNetworkError.image

        let updateNetworkBtnBackgroundColor: UIColor = Asset.mainGreen.color
        let updateNetworkBtnTitleColor: UIColor = Asset.mainWhite.color
        let updateNetworkBtnTitle: String = L10n.update
        let updateNetworkBtnTitleFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let updateNetworkBtnWidth: CGFloat = Constants.screenWidth - 164
    }
}

protocol NetworkErrorViewDelegate {
    func checkNetwork()
}

class NetworkErrorView: UIView {

    private lazy var titleLbl: PaddingLbl = {
        let view = PaddingLbl(withInsets: 16, 16, 24, 24)
        view.textColor = appearance.titleLblTextColor
        view.font = appearance.titleLblTextFont
        view.textAlignment = appearance.titleLblTextAligment
        view.backgroundColor = appearance.titleLblBackgroundColor
        view.numberOfLines = appearance.titleLblNumberOfLines
        view.text = appearance.networkErrorInfo
        view.sizeToFit()
        return view
    }()

    private lazy var iconIV: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = appearance.iconImage
        return view
    }()

    private lazy var checkNetworkBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = appearance.updateNetworkBtnBackgroundColor
        view.setTitle(appearance.updateNetworkBtnTitle, for: .normal)
        view.setTitleColor(appearance.updateNetworkBtnTitleColor, for: .normal)
        view.titleLabel?.font = appearance.updateNetworkBtnTitleFont
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        view.titleLabel?.minimumScaleFactor = 0.5
        view.titleLabel?.lineBreakMode = .byClipping
        return view
    }()

    private let appearance = Appearance()
    private var delegate: NetworkErrorViewDelegate

    init(for delegate: NetworkErrorViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)

        setupUI()
    }

    fileprivate func setupUI() {
        backgroundColor = appearance.backgroundColor

        addSubview(titleLbl)
        addSubview(iconIV)

        addSubview(checkNetworkBtn)
        checkNetworkBtn.addTarget(self, action: #selector(checkNetwork), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLbl.snp.remakeConstraints { (maker) in
            maker.centerX.left.right.equalToSuperview()
            maker.centerY.equalTo(snp.centerY)
        }

        iconIV.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(titleLbl.snp.top)
            maker.height.width.equalTo(72)
        }

        let checkNetworkBtnHeight = appearance.updateNetworkBtnWidth * 0.2
        checkNetworkBtn.layer.cornerRadius = checkNetworkBtnHeight * 0.2
        checkNetworkBtn.snp.remakeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(titleLbl.snp.bottom)
            maker.width.equalTo(appearance.updateNetworkBtnWidth)
            maker.height.equalTo(checkNetworkBtnHeight)
        }
    }

    @objc func checkNetwork() {
        checkNetworkBtn.pulsate(sender: self.checkNetworkBtn)
        delegate.checkNetwork()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
