//
//  CreateDrugVM.swift
//  Infoapteka
//
//

import Foundation
import Alamofire

final class CreateDrugVM {

    private var drugForUpdate: Drug?
    private var showType: CreateDrugVCShowType
    private var fields: [CreateDrugField] = []

    init() { self.showType = .create }

    init(_ drugForUpdate: Drug) {
        self.drugForUpdate = drugForUpdate
        self.showType = .edit
    }
    
    func getFields(_ completion: @escaping(() -> Void)) {
        API.createDrugAPI.getFields(drugForUpdate) { fields in
            self.fields = fields
            completion()
        }
    }

    func drugCreationProcess(_ completion: @escaping ((Bool) -> Void)) {

        switch showType {
        case .create:
            let errorMessage: String = checkEmptyFields()
            guard errorMessage.isEmpty else {
                BannerTop.showToast(message: "Заполните следующие поля:\(errorMessage)", and: .systemRed)
                completion(false)
                return
            }

            let parameters: Parameters = [
                "category"   : getCategoryID(.category),
                "name"       : getString(.name),
                "instruction_txt": getString(.desc),
                "price"          : Int(getString(.price)) ?? 0
            ]
            drugCreate(parameters, getImages(), completion)
        case .edit:
            let checkFieldsForUpdating = checkFieldsForUpdating()
            let isEdited     = checkFieldsForUpdating.0
            let parameters   = checkFieldsForUpdating.1

            if let image = fields.filter({ $0.type == .images }).first {
                let imgsIsChanged = checkImages(image).0
                let images = checkImages(image).1
                if isEdited || imgsIsChanged {
                    drugUpdate(parameters, images, completion)
                } else {
                    completion(true)
                }
            } else if isEdited {
                drugCreate(parameters, [], completion)
            } else { completion(true) }
        }
    }

    private func drugCreate(_ parameters: Parameters,
                            _ images: [Certificate],
                            _ completion: @escaping ((Bool) -> Void)) {
        API.createDrugAPI.drugCreate(parameters, images, completion)
    }

    private func drugUpdate(_ parameters: Parameters,
                            _ images: [Certificate],
                            _ completion: @escaping ((Bool) -> Void)) {
        guard let drugID = drugForUpdate?.id else {
            BannerTop.showToast(message: "Данный объект не найден", and: .systemRed)
            completion(false)
            return
        }
        API.createDrugAPI.drugUpdate(drugID, parameters, images, completion)
    }


    var numberOfRowsInSection: Int {
        get { fields.count }
    }
    
    func setValue(_ field: CreateDrugField) {
        fields.indices.forEach { fields[$0].type == field.type ? (fields[$0].value = field.value) : nil }
    }

    func getField(_ by: Int) -> CreateDrugField {
        fields.count > by ? fields[by] : .init(placeholder: "", type: .name)
    }

    func getImages() -> [Certificate] {
        fields.filter { $0.type == .images }.first?.value as? [Certificate] ?? []
    }

    func setImages(_ images: [Certificate]) {
        fields.indices.forEach {
            if fields[$0].type == .images {
                if var imgs = fields[$0].value as? [Certificate] {
                    imgs.append(contentsOf: images)
                    fields[$0].value = imgs
                } else {
                    fields[$0].value = images
                }
            }
        }
    }

    func removeImage(_ certificate: Certificate?,
                     _ complation: @escaping ([Certificate]) -> ()) {
        var certificates: [Certificate] = []
        fields.indices.forEach {
            fields[$0].type == .images ? (certificates = fields[$0].value as? [Certificate] ?? []) : nil
        }
        certificates.removeAll {
            if let currentImage = $0.image, let image = certificate?.image  {
                return currentImage.id == image.id
            } else {
                return $0.id == certificate?.id ?? 0
            }
        }
        fields.indices.forEach {
            fields[$0].type == .images ? (fields[$0].value = certificates) : nil
        }
        complation(certificates)
    }

    fileprivate func checkEmptyFields() -> String {
        var errorMessage: String = ""
        fields.forEach {
            switch $0.type {
            case .name, .desc:
                if ($0.value as? String == nil) || (($0.value as? String)?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)  {
                    errorMessage.append(" \($0.type.rawValue)")
                }
            case .price:
                if ($0.value as? String == nil) || (($0.value as? String)?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                    errorMessage.append(" \($0.type.rawValue)")
                }
            case .category:
                if ($0.value as? Category)?.id == nil || ($0.value as? Category)?.id == 0 {
                    errorMessage.append(" \($0.type.rawValue)")
                }
            case .addDrug, .images: break
            }
        }
        return errorMessage
    }

    fileprivate func checkFieldsForUpdating() -> (Bool, Parameters) {
        var isEdited: Bool = false
        var parameters: Parameters = [:]
        fields.forEach {
            switch $0.type {
            case .category:
                let status = checkCategory(drugForUpdate?.сategory, $0)
                parameters["category"] = status.1
                if let _ = status.1, status.0 {
                    isEdited = true
                }
            case .name:
                let status = checkString(drugForUpdate?.name, $0)
                parameters["name"] = status.1
                if let _ = status.1, status.0 {
                    isEdited = true
                }
            case .desc:
                let status = checkString(drugForUpdate?.desc, $0)
                parameters["instruction_txt"] = status.1
                if let _ = status.1, status.0 {
                    isEdited = true
                }
            case .price:
                let status = checkInt(drugForUpdate?.price, $0)
                parameters["price"] = Int(status.1 ?? 0)
                if let _ = status.1, status.0 {
                    isEdited = true
                }
            case .images:
                let images = ($0.value as? [Certificate])?.filter { $0.url != nil || !($0.url?.isEmpty ?? true) }
                parameters["images"] = images?.compactMap { $0.id} ?? []
                if (drugForUpdate?.images.count ?? 0) != (images?.count ?? 0) {
                    isEdited = true
                }
            case .addDrug: break
            }
        }
        return (isEdited, parameters)
    }

    fileprivate func checkCategory(_ category: Category?, _ field: CreateDrugField) -> (Bool, Int?) {
        guard let newCategory = field.value as? Category, let pCategory = category else {
            return (false, nil)
        }
        return ((newCategory.id ?? 0) != (pCategory.id ?? 0), newCategory.id)
    }

    fileprivate func checkInt(_ int: Int?, _ field: CreateDrugField) -> (Bool, Int?) {
        guard let strValue = field.value as? String, let intValue = Int(strValue), intValue > 0,
              let pIntValue = int, intValue > 0 else {
            return (false, nil)
        }
        return ((intValue != pIntValue), intValue)
    }

    fileprivate func checkString(_ str: String?, _ field: CreateDrugField) -> (Bool, String?) {
        guard let string = field.value as? String, !string.isEmpty,
              let pString = str, !pString.isEmpty else {
            return ((field.value as? String ?? "") != (str ?? ""), (field.value as? String) ?? "")
        }
        return ((string != pString), string)
    }

    fileprivate func checkImages(_ field: CreateDrugField) -> (Bool, [Certificate]) {
        guard let images = field.value as? [Certificate], !images.isEmpty,
              let pImages = drugForUpdate?.images else {
            return (false, [])
        }
        //        let addedCertificates = certificates.filter({ $0.url == nil || ($0.url?.isEmpty ?? true) })
        return ((images.count != pImages.count), images)
    }

    func getString(_ type: CreateDrugFieldType) -> String {
        return (fields.filter { $0.type == type }.first?.value as? String ?? "")
    }

    func getCategoryID(_ type: CreateDrugFieldType) -> Int {
        return (fields.filter { $0.type == type }.first?.value as? Category)?.id ?? 0
    }
}
