//
//  CreateDrugTVC.swift
//  Infoapteka
//
//

import UIKit
import ImageSlideshow
import ImagePicker

// MARK: -- Appearance
extension CreateDrugTVC {
    struct Appearance {
        let backgroundColor          : UIColor = Asset.mainWhite.color
        let tableViewBackgroundColor : UIColor = Asset.mainWhite.color
        let tableViewSeparatorStyle  : UITableViewCell.SeparatorStyle = .none

        let title    : String = L10n.createDrug
        let titleFont: UIFont = FontFamily.Inter.semiBold.font(size: 18.0)
        let titleColor   : UIColor = Asset.mainBlack.color
    }
}

class CreateDrugTVC: BaseTVC {

    // MARK: -- UI Properties
    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        return view
    }()

    private var appearance = Appearance()
    private var viewModel       : CreateDrugVM
    private var tableViewManager: CreateDrugTVManager
    var isSuccessEdited: (() -> ())?

    init(_ viewModel: CreateDrugVM) {
        self.viewModel = viewModel
        self.tableViewManager = .init(self.viewModel)
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTV()

        tableViewManager.delegate = self
        tableViewManager.setup { [weak self] in
            guard let self = self else { return }
            self.reloadData()
        }
    }

    private func setupView() {
        view.backgroundColor = appearance.backgroundColor
        setNavBarBackColor(title: "",
                           statusBarBackColor: .white,
                           navBarBackColor: .white,
                           navBarTintColor: .white,
                           prefersLargeTitles: false)
        setTabBarBackColor(tabBarBackColor: .white,
                           tabBarTintColor: .white)
        navigationItem.leftBarButtonItem  = .init(title: "Отмена",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(didTappedLeftBarBtn))
        navigationItem
            .leftBarButtonItem?
            .setTitleTextAttributes([.font: FontFamily.Inter.semiBold.font(size: 14.0),
                                     .foregroundColor: Asset.mainBlack.color], for: .normal)
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
        tableView.delegate   = tableViewManager
        tableView.dataSource = tableViewManager

        tableView.contentInset = .init(top: 24.0, left: 0, bottom: 24.0, right: 0)
        tableView.separatorInset = .init(top: 0, left: 1000, bottom: 0, right: 0)
        tableView.backgroundColor = appearance.tableViewBackgroundColor
        tableView.separatorStyle = appearance.tableViewSeparatorStyle
        tableView.alwaysBounceVertical = true

        tableView.registerdequeueReusableCell(CreateDrugSimpleTFTVCell.self)
        tableView.registerdequeueReusableCell(SelectCategoryTVCell.self)
        tableView.registerdequeueReusableCell(CommentTVCell.self)
        tableView.registerdequeueReusableCell(CertificatesCell.self)
        tableView.registerdequeueReusableCell(SaveTVCell.self)

        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
    }

    @objc private func didTappedLeftBarBtn() {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateDrugTVC: CreateDrugTVManagerDelegate {
    func didTappedSelectcategoryTF(_ field: CreateDrugField) {
        let categoriesTVC = CategoriesTVC(.init(.simple))
        categoriesTVC.categorySelected = { [weak self] category in
            guard let self = self else { return }
            var newField = field
            newField.value = category
            self.viewModel.setValue(newField)
            self.reloadData()
            categoriesTVC.navigationController?.popToRootViewController(animated: true)
        }
        navigationController?.pushViewController(categoriesTVC, animated: true)
    }

    func didTappedAddBtn() {
        view.endEditing(true)
        viewModel.drugCreationProcess { [weak self] isEdited in
            guard let self = self else { return }
            self.isSuccessEdited?()
        }
    }

    func didTapOnSlideshow(_ imageSlideshow: ImageSlideshow) {
        let fullScreenController = imageSlideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .medium, color: nil)
    }

    func openPicker() {
        setupPickerView()
    }
}

extension CreateDrugTVC: UINavigationControllerDelegate {
    private func setupPickerView() {
        let configuration = Configuration()
        configuration.doneButtonTitle = "Готово"
        configuration.noImagesTitle = "Извините! Здесь нет изображений!"
        configuration.cancelButtonTitle = "Отмена"
        configuration.recordLocation = true

        let imagePickerController = ImagePickerController(configuration: configuration)
        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 8
        present(imagePickerController, animated: true, completion: nil)
    }

    fileprivate func setImages(_ images: [Image]) {
        let certificates: [Certificate] = images.compactMap { Certificate($0) }
        self.viewModel.setImages(certificates)
        self.reloadData()
    }
}

extension CreateDrugTVC: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.expandGalleryView()
    }

    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            let imgs = self.getImagesFromAssets(imgs: images)
            self.setImages(imgs)
        }
    }

    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
