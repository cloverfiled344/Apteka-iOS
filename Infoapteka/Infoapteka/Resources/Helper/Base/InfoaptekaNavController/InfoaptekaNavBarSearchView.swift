//
//  InfoaptekaNavBarSearchView.swift
//  Infoapteka
//
//  
//

import UIKit

protocol InfoaptekaNavBarSearchViewDelegate {
    func didTapNotificationBtn()
    func didTapLogo()
    func searchTextFieldEditingDidBegin()
    func textFieldShouldReturn(_ text: String)
    func searchTextFieldValueChanged(_ text: String)
}

extension InfoaptekaNavBarSearchViewDelegate {
    func didTapNotificationBtn() {
        BannerTop.showToast(message: "Это часть в разработке еще", and: .lightGray)
    }

    func didTapLogo() {
        guard let currentVC = UIApplication.topViewController(),
              let selectedIndex = currentVC.tabBarController?.selectedIndex, selectedIndex > 0 else {
            return
        }
        currentVC.tabBarController?.selectedIndex = 0
    }

    func searchTextFieldEditingDidBegin() {
        guard let currentVC = UIApplication.topViewController() else { return }
        let vc = SearchHintTVC(.init(nil))
        vc.hidesBottomBarWhenPushed = true
        currentVC.navigationController?.pushViewController(vc, animated: false)
    }

    func textFieldShouldReturn(_ text: String) {}
    func searchTextFieldValueChanged(_ text: String) {}
}

extension InfoaptekaNavBarSearchView {
    struct Appearance {
        let backgroundColor     : UIColor = Asset.mainWhite.color

        let appLogoImage        : UIImage = Asset.icNavBarLeftView.image
        let appLogoContentMode  : UIView.ContentMode = .scaleAspectFit
        let appLogoMasksToBounds    : Bool = true
        let appLogoBackgroundColor  : UIColor = Asset.mainWhite.color
        let appLogoMargin           : CGFloat = 36.0

        let textFieldLeftViewIV     : UIImageView = UIImageView(image: Asset.icSearch.image)
        let textFieldFont           : UIFont = FontFamily.Inter.regular.font(size: 15.0)
        let textFieldTextColor      : UIColor = Asset.mainBlack.color
        let textFieldBorderColor    : CGColor = Asset.light.color.cgColor
        let textFieldBorderWidth    : CGFloat = 1.0
        let textFieldCornnerRadius  : CGFloat = 12.0
    }
}

class InfoaptekaNavBarSearchView: UIView {

    lazy private var logoIV: UIImageView = {
        let view = UIImageView()
        view.image = appearance.appLogoImage
        view.contentMode = appearance.appLogoContentMode
        view.layer.masksToBounds = appearance.appLogoMasksToBounds
        view.backgroundColor = appearance.appLogoBackgroundColor
        return view
    }()

    private lazy var textField: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.font = appearance.textFieldFont
        view.textColor = appearance.textFieldTextColor
        view.smartQuotesType = .yes
        view.smartDashesType = .yes
        view.smartInsertDeleteType = .yes
        view.layer.borderWidth = appearance.textFieldBorderWidth
        view.layer.borderColor = appearance.textFieldBorderColor
        view.layer.cornerRadius = appearance.textFieldCornnerRadius

        let leftViewIV = appearance.textFieldLeftViewIV
        leftViewIV.frame = .init(x: 9, y: 9, width: 24, height: 24)

        view.leftViewMode = .always
        view.leftView = .init(frame: .init(x: 0, y: 0, width: 42, height: 40))
        view.leftView?.addSubview(leftViewIV)
        return view
    }()

    private let badgeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var notificationBtn: UIButton = {
        let view = UIButton()
        view.layer.masksToBounds = true
        view.setImage(Asset.icNotification.image, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Asset.mainWhite.color
        view.addSubview(self.badgeView)
        self.badgeView.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.snp.top)
            maker.centerX.equalTo(view.snp.centerX).offset(6)
            maker.width.height.equalTo(10)
        }
        self.badgeView.layer.cornerRadius = 5
        self.badgeView.clipsToBounds = true
        return view
    }()

    private let appearance = Appearance()
    private var fields: [InfoaptekaNavBarField]
    var _delegate: InfoaptekaNavBarSearchViewDelegate?

    init(_ fields: [InfoaptekaNavBarField]) {
        self.fields = fields
        super.init(frame: .zero)

        addSubview(logoIV)
        let logoTap = UITapGestureRecognizer(target: self, action: #selector(didTapLogo))
        logoIV.isUserInteractionEnabled = true
        logoIV.addGestureRecognizer(logoTap)

        addSubview(notificationBtn)
        notificationBtn.addTarget(self, action: #selector(didTapNotificationBtn), for: .touchUpInside)

        addSubview(textField)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        switch fields {
        case [.logoIV, .searchHintTF, .notificationBtn]:
            logoIV.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.height.width.equalTo(40)
                make.centerY.equalToSuperview()
            }

            notificationBtn.snp.remakeConstraints { make in
                make.right.equalToSuperview().offset(-16)
                make.height.width.equalTo(24)
                make.centerY.equalToSuperview()
            }

            textField.clearButtonMode = .never
            textField.addTarget(self, action: #selector(searchTextFieldEditingDidBegin), for: .editingDidBegin)
            textField.placeholder = fields.filter { $0 == .searchHintTF }.first?.rawValue
            textField.snp.remakeConstraints { make in
                make.left.equalTo(logoIV.snp.right).offset(12)
                make.right.equalTo(notificationBtn.snp.left).offset(-12)
                make.height.equalTo(36)
                make.centerY.equalToSuperview()
            }
        case [.searchTF, .notificationBtn]:
            notificationBtn.snp.remakeConstraints { make in
                make.right.equalToSuperview().offset(-16)
                make.height.width.equalTo(24)
                make.centerY.equalToSuperview()
            }

            textField.clearButtonMode = .always
            textField.becomeFirstResponder()
            textField.addTarget(self, action: #selector(searchTextFieldValueChanged), for: .editingChanged)
            textField.placeholder = fields.filter { $0 == .searchTF }.first?.rawValue
            textField.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.right.equalTo(notificationBtn.snp.left).offset(-12)
                make.height.equalTo(36)
                make.centerY.equalToSuperview()
            }
        case [.searchHintTF]:
            logoIV.removeFromSuperview()
            notificationBtn.removeFromSuperview()
            textField.clearButtonMode = .never
            textField.addTarget(self, action: #selector(searchTextFieldEditingDidBegin), for: .editingDidBegin)
            textField.placeholder = fields.filter { $0 == .searchHintTF }.first?.rawValue
            textField.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(12)
                make.right.equalToSuperview().offset(-12)
                make.height.equalTo(36)
                make.centerY.equalToSuperview()
            }
        case [.searchTF]:
            logoIV.removeFromSuperview()
            notificationBtn.removeFromSuperview()
            textField.becomeFirstResponder()
            textField.clearButtonMode = .never
            textField.addTarget(self, action: #selector(searchTextFieldValueChanged), for: .editingChanged)
            textField.placeholder = fields.filter { $0 == .searchTF }.first?.rawValue
            textField.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(12)
                make.right.equalToSuperview().offset(-12)
                make.height.equalTo(36)
                make.centerY.equalToSuperview()
            }
        default: break
        }
    }

    func setSearchText(_ search: String) {
        textField.text = search
    }

    @objc private func didTapLogo() {
        logoIV.pulsate()
        _delegate?.didTapLogo()
    }

    @objc private func didTapNotificationBtn() {
        notificationBtn.pulsate()
        _delegate?.didTapNotificationBtn()
    }

    @objc private func searchTextFieldEditingDidBegin() {
        textField.endEditing(true)
        _delegate?.searchTextFieldEditingDidBegin()
    }

    @objc private func searchTextFieldValueChanged() {
        _delegate?.searchTextFieldValueChanged(textField.allText)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InfoaptekaNavBarSearchView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        _delegate?.textFieldShouldReturn(textField.allText)
        return true
    }
}
