//
//  UserRegisterTVManager.swift
//  Infoapteka
//
//

import UIKit
import ImageSlideshow

protocol RegisterTVManagerDelegate {
    func didTappedTF()
    func openPickerForSelectCertificates()
    func reloadData()
    func eventTF()
    func didTapOnSlideshow(_ imageSlideshow: ImageSlideshow)
    func register()
    func incorrectPhoneNumber()
    func didTappedAvatarEditBtn(_ avatarIsHave: Bool)
    func didTappedSaveBtn()
    func privacyPolicy()
}

class RegisterTVManager: NSObject {

    private var viewModel: RegisterVM
    var delegate: RegisterTVManagerDelegate?

    init(_ viewModel: RegisterVM) {
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(completion: @escaping () -> ()) {
        self.viewModel.getPages {
            completion()
        }
    }
}

extension RegisterTVManager: UITableViewDelegate {

    //MARK: - Tableview Delegate
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RegisterTVManager: UITableViewDataSource {

    //MARK: - Tableview Data source
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getFieldsCount()
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.makeFieldCell(tableView, cellForRowAt: indexPath)
    }

    private func makeFieldCell(_ tableView: UITableView,
                               cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = viewModel.getField(indexPath.row)
        var cell: UITableViewCell = UITableViewCell()
        switch field.type {
        case .title:
            cell = tableView.dequeueReusableCell(TitleTVCell.self,
                                                 indexPath: indexPath)
            (cell as? TitleTVCell)?.setTitle(self.viewModel.getTitle())
        case .phone:
            cell = tableView.dequeueReusableCell(PhoneNumberTVCell.self,
                                                 indexPath: indexPath)
            (cell as? PhoneNumberTVCell)?.setFieid(self.viewModel.getField(indexPath.row))
        case .name, .surname, .middleName, .address:
            cell = tableView.dequeueReusableCell(FullNameTVCell.self,
                                                 indexPath: indexPath)
            (cell as? FullNameTVCell)?.setup(self.viewModel, viewModel.getField(indexPath.row))
            (cell as? FullNameTVCell)?.delegate = self
        case .birthdate:
            cell = tableView.dequeueReusableCell(SelectDateTVCell.self,
                                                 indexPath: indexPath)
            (cell as? SelectDateTVCell)?.setup(viewModel, viewModel.getField(indexPath.row))
            (cell as? SelectDateTVCell)?.delegate = self
        case .certificates:
            cell = tableView.dequeueReusableCell(CertificatesCell.self,
                                                 indexPath: indexPath)
            (cell as? CertificatesCell)?.delegate = self
            (cell as? CertificatesCell)?.setup(viewModel.getCertificates(), Asset.icAddCertificate.image, field.placeholder)
        case .register:
            cell = tableView.dequeueReusableCell(RegisterTVCell.self,
                                                 indexPath: indexPath)
            (cell as? RegisterTVCell)?.delegate = self
        case .avatar:
            cell = tableView.dequeueReusableCell(AvatarTVCell.self,
                                                 indexPath: indexPath)
            (cell as? AvatarTVCell)?.delegate = self
            (cell as? AvatarTVCell)?.setup(viewModel.getAvatar() )
        case .save:
            cell = tableView.dequeueReusableCell(SaveTVCell.self,
                                                 indexPath: indexPath)
            (cell as? SaveTVCell)?.delegate = self
            (cell as? SaveTVCell)?.setup(field.placeholder)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension RegisterTVManager: CertificatesCellDelegate {
    func didTapOnSlideshow(_ imageSlideshow: ImageSlideshow) {
        self.delegate?.didTapOnSlideshow(imageSlideshow)
    }

    func removeImage(_ certificate: Certificate?) {
        self.viewModel.removeImage(certificate) { images in
            self.delegate?.reloadData()
        }
    }

    func openPicker() {
        self.delegate?.openPickerForSelectCertificates()
    }
}

extension RegisterTVManager: FullNameTVCellDelegate {
    func didFullNameTFEvent() {
        self.delegate?.eventTF()
    }
}

extension RegisterTVManager: SelectDateTVCellDelegate {
    func didTFSelectDateEvent() {
        self.delegate?.eventTF()
    }
}

extension RegisterTVManager: RegisterTVCellDelegate {
    func register() {
        self.delegate?.register()
    }

//    func incorrectPhoneNumber() {
//        self.delegate?.privacyPolicy()
//    }
    
    func privacyPolicy() {
        self.delegate?.privacyPolicy()
    }
}

extension RegisterTVManager: AvatarTVCellDelegate {
    func didTappedAvatarEditBtn(_ avatarIsHave: Bool) {
        self.delegate?.didTappedAvatarEditBtn(avatarIsHave)
    }
}

extension RegisterTVManager: SaveTVCellDelegate {
    func didTappedSubmitBtn() {
        self.delegate?.didTappedSaveBtn()
    }
}
