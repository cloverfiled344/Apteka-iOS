//
//  CheckoutTVC.swift
//  Infoapteka
//
//

import UIKit
import IQKeyboardManagerSwift

// MARK: Appearance
extension CheckoutTVC {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color

        let tableViewBackgroundColor: UIColor = Asset.mainWhite.color
        let tableViewSeparatorColor: UIColor = Asset.secondaryGrayLight.color

        let title    : String = L10n.basket
        let titleFont: UIFont = FontFamily.Inter.semiBold.font(size: 18.0)
        let titleColor   : UIColor = Asset.mainBlack.color
        let subtitleColor: UIColor = Asset.secondaryGray3.color
    }
}

class CheckoutTVC: BaseTVC {

    // MARK: -- UI Properties
    lazy private var titleLbl: UILabel = {
        let view = UILabel(frame: .init(x: 0, y: 0, width: 0, height: 44))
        view.textAlignment = .center
        return view
    }()

    private var appearance = Appearance()
    private var viewModel       : CheckoutVM
    private var tableViewManager: CheckoutTVManager
    var checkoutOrderCalback: ((Bool, String?) -> ())?

    init(_ viewModel: CheckoutVM) {
        self.viewModel = viewModel
        self.tableViewManager = .init(self.viewModel)
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTV()
        fetchData()
    }

    fileprivate func fetchData() {
        viewModel.fetchProfile { [weak self] in
            guard let self = self else { return }
            guard self.viewModel.profile != nil else {
                BannerTop.showToast(message: "Произошла ошибка при загрузке профиля! \nПопробуйте еще раз! ", and: .systemRed)
                self.navigationController?.popViewController(animated: true)
                return
            }
            self.tableViewManager.setup { [weak self] in
                guard let self = self else { return }
                self.reloadData()
                self.tableView.tableFooterView = self.tableViewManager.makeTableViewFooter(self.tableView)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavBar()
    }

    private func updateNavBar() {
        view.backgroundColor = appearance.backgroundColor
        setNavBarBackColor(title: "",
                           statusBarBackColor: .white,
                           navBarBackColor: .white,
                           navBarTintColor: .white,
                           prefersLargeTitles: false)
        updateTitleLbl()
    }

    fileprivate func updateTitleLbl() {
        let attributedText = NSMutableAttributedString(string: appearance.title,
                                                       attributes: [.font: appearance.titleFont,
                                                                    .foregroundColor: appearance.titleColor])
        titleLbl.attributedText = attributedText
        navigationItem.titleView = titleLbl
    }

    fileprivate func setupTV() {
        tableViewManager.delegate = self
        tableView.delegate   = tableViewManager
        tableView.dataSource = tableViewManager

        tableView.separatorInset = .init(top: 0, left: 20.0, bottom: 0, right: 20.0)
        tableView.backgroundColor = appearance.tableViewBackgroundColor
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .onDrag

        tableView.registerdequeueReusableCell(CheckoutSimpleTFTVCell.self)
        tableView.registerdequeueReusableCell(PhoneNumbersTVCell.self)
        tableView.registerdequeueReusableCell(SelectDistrictTVCell.self)
        tableView.registerdequeueReusableCell(CommentTVCell.self)
        tableView.registerdequeueReusableCell(PaymetSelectionTVCell.self)
        tableView.registerdequeueReusableCell(UITableViewCell.self)
        tableView.registerdequeueReusableHeaderFooter(CheckoutTVFooter.self)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableHeaderView = UIView(frame: .zero)
    }
}

extension CheckoutTVC: CheckoutTVManagerDelegate {
    func didTappedOrderBtn() {
        view.endEditing(true)
        startIndicatorAnimation()
        viewModel.checkoutOrder { [weak self] success, link in
            guard let self = self else { return }
            self.stopIndicatorAnimation()
            guard let status = success else { return }
            self.checkoutOrderCalback?(status, link)
        }
    }

    func didTappedSelectAddresOnMapTF(_ field: CheckoutField) {
        let vc = CitiesTVC(.init(.cities))
        vc.selectedCity = { [weak self] city in
            guard let self = self else { return }
            var newField = field
            newField.value = city
            self.viewModel.setValue(newField)
            self.reloadData()
            vc.navigationController?.popToViewController(self, animated: true)
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    func deletePhone(_ phoneNumber: PhoneNumber) {
        viewModel.deletePhone(phoneNumber)
        reloadData()
    }

    func didTappedAddBtn() {
        viewModel.createPhoneTF()
        reloadData()
    }
    
    func pushToPrivacyPolicy() {
        viewModel.getProgramRules { [weak self] result in
            guard let self = self else { return }
            let vc = PrivacyPolicyVC()
            vc.setupPDF(result)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
