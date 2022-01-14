//
//  CreateDrugTVManager.swift
//  Infoapteka
//
//

import UIKit
import ImageSlideshow

protocol CreateDrugTVManagerDelegate {
    func didTappedAddBtn()
    func didTappedSelectcategoryTF(_ field: CreateDrugField)
    func didTapOnSlideshow(_ imageSlideshow: ImageSlideshow)
    func openPicker()
    func reloadData()
}

class CreateDrugTVManager: NSObject {

    // MARK: UI Components
    private var viewModel: CreateDrugVM
    var delegate: CreateDrugTVManagerDelegate?

    init(_ viewModel: CreateDrugVM) {
        self.viewModel = viewModel
    }

    func setup(complation: @escaping () -> ()) {
        viewModel.getFields(complation)
    }
}

extension CreateDrugTVManager: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        makeFieldCell(tableView, cellForRowAt: indexPath)
    }

    private func makeFieldCell(_ tableView: UITableView,
                               cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = viewModel.getField(indexPath.row)
        var cell: UITableViewCell = UITableViewCell()
        switch field.type {
        case .category:
            cell = tableView.dequeueReusableCell(SelectCategoryTVCell.self,
                                                 indexPath: indexPath)
            (cell as? SelectCategoryTVCell)?.setup(viewModel, field)
            (cell as? SelectCategoryTVCell)?.delegate = self
        case .name, .price:
            cell = tableView.dequeueReusableCell(CreateDrugSimpleTFTVCell.self,
                                                 indexPath: indexPath)
            (cell as? CreateDrugSimpleTFTVCell)?.setup(viewModel, field)
        case .desc:
            cell = tableView.dequeueReusableCell(CommentTVCell.self,
                                                 indexPath: indexPath)
            (cell as? CommentTVCell)?.setup(viewModel, field)
        case .images:
            cell = tableView.dequeueReusableCell(CertificatesCell.self,
                                                 indexPath: indexPath)
            (cell as? CertificatesCell)?.delegate = self
            (cell as? CertificatesCell)?.setup(viewModel.getImages(), Asset.icAddImage.image,  field.placeholder)
        case .addDrug:
            cell = tableView.dequeueReusableCell(SaveTVCell.self,
                                                 indexPath: indexPath)
            (cell as? SaveTVCell)?.delegate = self
            (cell as? SaveTVCell)?.setup(field.placeholder)
        }
        return cell
    }
}

extension CreateDrugTVManager: CertificatesCellDelegate {
    func openPicker() {
        delegate?.openPicker()
    }

    func removeImage(_ certificate: Certificate?) {
        viewModel.removeImage(certificate) { [weak self] images in
            guard let self = self else { return }
            self.delegate?.reloadData()
        }
    }

    func didTapOnSlideshow(_ imageSlideshow: ImageSlideshow) {
        delegate?.didTapOnSlideshow(imageSlideshow)
    }
}

extension CreateDrugTVManager: SaveTVCellDelegate {
    func didTappedSubmitBtn() {
        delegate?.didTappedAddBtn()
    }
}

extension CreateDrugTVManager: SelectCategoryTVCellDelegate {
    func didTappedTF(_ field: CreateDrugField) {
        delegate?.didTappedSelectcategoryTF(field)
    }
}
