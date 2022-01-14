//
//  UserRegisterTVC.swift
//  Infoapteka
//
//  
//

import UIKit
import FloatingPanel
import ImageSlideshow
import ImagePicker

// MARK: Appearance
extension RegisterVC {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color

        let tableViewBackgroundColor: UIColor = Asset.mainWhite.color
        let tableViewSeparatorStyle: UITableViewCell.SeparatorStyle = .none

        let titleFont: UIFont = FontFamily.Inter.bold.font(size: 24)

        let citiesTVCMaskedCorners: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        let citiesTVCCornerRadius: CGFloat = 8.0

        let fpcBackgorundColor: UIColor = Asset.mainBlack.color.withAlphaComponent(0.3)
    }
}

class RegisterVC: BaseVC {

    // MARK: Properties
    private let appearance = Appearance()
    private var viewModel: RegisterVM
    private var tableViewManager: RegisterTVManager
    private var isAvatar: Bool = false
    var isSuccess: (() -> ())?

    // MARK: UIProperties
    lazy private var tableView: UITableView = {
        let view = UITableView()
        return view
    }()

    // MARK: Initialize
    init(_ viewModel: RegisterVM) {
        self.viewModel        = viewModel
        self.tableViewManager = .init(viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTV()
        updateView()
    }

    private func setupView() {
        view.backgroundColor = appearance.backgroundColor
        setNavBarBackColor(title: "",
                           statusBarBackColor: .white,
                           navBarBackColor: .white,
                           navBarTintColor: .white,
                           prefersLargeTitles: false)
    }

    fileprivate func setupTV() {
        view.backgroundColor = appearance.backgroundColor

        tableViewManager.delegate = self
        tableView.delegate   = tableViewManager
        tableView.dataSource = tableViewManager

        tableView.backgroundColor = appearance.tableViewBackgroundColor
        tableView.separatorStyle = appearance.tableViewSeparatorStyle

        tableView.registerdequeueReusableCell(PhoneNumberTVCell.self)
        tableView.registerdequeueReusableCell(FullNameTVCell.self)
        tableView.registerdequeueReusableCell(SelectDateTVCell.self)
        tableView.registerdequeueReusableCell(CertificatesCell.self)

        tableView.registerdequeueReusableCell(RegisterTVCell.self)
        tableView.registerdequeueReusableCell(TitleTVCell.self)

        tableView.registerdequeueReusableCell(AvatarTVCell.self)
        tableView.registerdequeueReusableCell(SaveTVCell.self)

        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    fileprivate func updateView() {
        tableViewManager.setup {
            self.reloadData()
        }
    }

    internal func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension RegisterVC: RegisterTVManagerDelegate {
    func eventTF() {}

    func privacyPolicy() {
        viewModel.getPrivacyPolicy { [weak self] result in
            guard let self = self else { return }
            let vc = PrivacyPolicyVC()
            vc.setupPDF(result)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didTappedAvatarEditBtn(_ avatarIsHave: Bool) {
        let sheet = EditProfileAvatarBottomSheet.instance
        sheet.uploadAvatar = { [weak self] in
            guard let self = self else { return }
            self.setupPickerView(true, 1)
        }
        sheet.deleteAvatar = { [weak self] in
            guard let self = self else { return }
            self.viewModel.deleteProfileAvatar { [weak self] success in
                guard let self = self else { return }
                self.updateView()
                self.isSuccess?()
            }
        }
        sheet.show(avatarIsHave)
    }

    func didTappedSaveBtn() {
        viewModel.updateProfile { isUpdated in
            if isUpdated {
                self.isSuccess?()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func register() {
        viewModel.register { success in
            if success {
                let registerSuccessVC = RegisterSuccessVC()
                self.navigationController?.pushViewController(registerSuccessVC, animated: true)
            }
        }
    }

    func incorrectPhoneNumber() {
        navigationController?.popViewController(animated: true)
    }

    func didTapOnSlideshow(_ imageSlideshow: ImageSlideshow) {
        let fullScreenController = imageSlideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .medium,
                                                                                    color: nil)
    }

    func openPickerForSelectCertificates() {
        setupPickerView(false)
    }

    private func logout() {
        stopIndicatorAnimation()
        AppSession.token = nil
    }

    func didTappedTF() {
        self.reloadData()
    }
}

extension RegisterVC: UINavigationControllerDelegate {
    func setupPickerView(_ isAvatar: Bool,
                         _ maxImagesCount: Int = 100) {
        self.isAvatar = isAvatar

        let configuration = Configuration()
        configuration.doneButtonTitle = "Готово"
        configuration.cancelButtonTitle = "Отмена"
        configuration.noImagesTitle = "Извините! Здесь нет изображений!"
        configuration.recordLocation = true

        let imagePickerController = ImagePickerController(configuration: configuration)
        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.delegate = self
        imagePickerController.imageLimit = maxImagesCount
        present(imagePickerController, animated: true, completion: nil)
    }

    fileprivate func setImages(_ images: [Image], _ isAvatar: Bool) {
        if isAvatar {
            self.viewModel.setAvatar(images.first) { [weak self] _ in
                guard let self = self else { return }
                self.isSuccess?()
                self.reloadData()
            }
        } else {
            let certificates: [Certificate] = images.compactMap { Certificate($0) }
            self.viewModel.setCertificates(certificates)
            self.reloadData()
        }
    }
}

extension RegisterVC: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.expandGalleryView()
    }

    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            let imgs = self.getImagesFromAssets(imgs: images)
            self.setImages(imgs, self.isAvatar)
        }
    }

    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}



/*   lazy private var fpc: FloatingPanelController = {
 let fpc = FloatingPanelController()
 fpc.view.backgroundColor = appearance.fpcBackgorundColor
 (fpc.view.subviews.first)?.isUserInteractionEnabled = false
 return fpc
 }()

 lazy private var citiesTVC: CitiesTVC = {
 let vc = CitiesTVC(.init())
 vc.view.layer.maskedCorners = appearance.citiesTVCMaskedCorners
 vc.view.layer.cornerRadius  = appearance.citiesTVCCornerRadius
 vc._delegate = self
 return vc
 }()


 extension RegisterVC: FloatingPanelControllerDelegate {
 private func setupFPC() {
 fpc.delegate = self
 let city = viewModel.getCity()
 city != nil ? self.citiesTVC.setCity(city!) : nil
 fpc.set(contentViewController: self.citiesTVC)
 fpc.track(scrollView: self.citiesTVC.tableView)
 fpc.addPanel(toParent: self, animated: true)
 fpc.move(to: .half, animated: true)
 }

 func floatingPanelDidChangePosition(_ vc: FloatingPanelController) {
 if vc.position == FloatingPanelPosition.tip {
 fpc.delegate = nil
 fpc.removePanelFromParent(animated: true)
 }
 }
 }
 

 extension RegisterVC: CitiesTVCDelegate {
 func selected(_ city: City?) {
 self.viewModel.setCity(city)
 self.fpc.delegate = nil
 self.fpc.removePanelFromParent(animated: true)
 self.reloadData()
 }
 }
 */
