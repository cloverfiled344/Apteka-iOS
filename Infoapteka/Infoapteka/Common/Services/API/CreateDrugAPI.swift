//
//  CreateDrugAPI.swift
//  Infoapteka
//
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

final class CreateDrugAPI {

    func getFields(_ drugForUpdate: Drug?,
                   _ completion: @escaping(([CreateDrugField]) -> Void)) {
        guard let drugForUpdate = drugForUpdate else {
            completion([
                .init(placeholder: "Категория", type: .category),
                .init(placeholder: "Введите название", type: .name),
                .init(placeholder: "Введите текст", type: .desc),
                .init(placeholder: "Введите цену", type: .price),
                .init(placeholder: "Размер файла не должен превышать 2мб. \nФормат файлов JPG \nКоличество загружаемых файлов минимум 4шт, \nмаксимум 8 шт.", type: .images),
                .init(placeholder: "Добавить товар", type: .addDrug),
            ])
            return
        }
        completion([
            .init(placeholder: "Категория", type: .category, value: drugForUpdate.сategory ),
            .init(placeholder: "Введите название", type: .name, value: drugForUpdate.name),
            .init(placeholder: "Введите текст", type: .desc, value: drugForUpdate.desc),
            .init(placeholder: "Введите цену", type: .price, value: "\(drugForUpdate.price ?? 0)"),
            .init(placeholder: "Размер файла не должен превышать 2мб. \nФормат файлов JPG \nКоличество загружаемых файлов минимум 4шт, \nмаксимум 8 шт.", type: .images, value: drugForUpdate.images.compactMap { Certificate(JSON: $0.toJSON()) }),
            .init(placeholder: "Обновить товар", type: .addDrug),
        ])
    }

    func drugCreate(_ parameters: Parameters,
                    _ images: [Certificate],
                    _ completion: @escaping((Bool) -> Void)) {
        let path = Global.pathFor(key: "create-drug")
        APIManager.instance.POST(path: path, parameters: parameters) {  [weak self] isCreated,
                                                                                    json,
                                                                                    error in
            guard let self = self else { return }
            self.uploadImagesProcess(isCreated, json, images, completion)
        }
    }

    func drugUpdate(_ drugID: Int,
                    _ parameters: Parameters,
                    _ images: [Certificate],
                    _ completion: @escaping((Bool) -> Void)) {
        let path = Global.pathFor(key: "create-drug")
        APIManager.instance.PUT(path: "\(path)\(drugID)/", parameters: parameters) {  [weak self] isCreated,
                                                                                                  json,
                                                                                                  error in
            guard let self = self else { return }
            self.uploadImagesProcess(isCreated, json, images, completion)
        }
    }

    func uploadImagesProcess(_ isCreated: Bool,
                             _ json: JSON,
                             _ images: [Certificate],
                             _ completion: @escaping((Bool) -> Void)) {
        guard !images.isEmpty else {
            completion(isCreated)
            return
        }

        guard let drug = Mapper<Drug>().map(JSONObject: json.dictionaryObject) else {
            completion(isCreated)
            return
        }

        if !images.isEmpty {
            let data: [Data] = images
                .compactMap { $0.image?.image?.jpegData(compressionQuality: 0.5) }
            guard !data.isEmpty else {
                completion(true)
                return
            }
            self.uploadImages(drug, data) { isImagesUploaded in
                if isImagesUploaded && isCreated {
                    completion(true)
                } else if isCreated {
                    completion(true)
                } else { completion(false) }
            }
        } else {
            completion(isCreated)
        }
    }

    fileprivate func uploadImages(_ drug: Drug,
                                  _ data: [Data],
                                  _ completion: @escaping((Bool) -> Void)) {
        let path = Global.pathFor(key: "create-drug-image")
        guard let drugId = drug.id else {
            completion(false)
            return
        }
        APIManager.instance.uploadData(true,
                                       "\(path)\(drugId)/",
                                       data,
                                       .post,
                                       "image") { success,
                                                  json,
                                                  error in
            completion(success)
        }
    }
}
