//
//  HomeAPI.swift
//  Infoapteka
//
//  
//

import UIKit
import ObjectMapper
import Alamofire

final class HomeAPI {

    func fetchHomePage(_ completion: @escaping(([ImageBanner], [Instruction], DrugResult) -> Void)) {
        let pathForBanners = Global.pathFor(key: "info-banner")
        var homePage: (banners: [ImageBanner],
                       instructions: [Instruction],
                       drugResult: DrugResult) = ([], [], .init(map: .init(mappingType: .fromJSON, JSON: [:])))

        APIManager.instance.GET(path: pathForBanners) { [weak self] success,
                                                                    json,
                                                                    error in
            guard let self = self else { return }
            homePage.banners      = Mapper<ImageBanner>().mapArray(JSONObject: json.arrayObject) ?? []
            homePage.instructions = self.getInstructions()

            self.paginateDrugs(1, true) { drugResult in
                homePage.drugResult = drugResult
                completion(homePage.banners, homePage.instructions, homePage.drugResult)
            }
        }
    }
    
    private func getInstructions() -> [Instruction] {
        return [Instruction(image: Asset.icHomeMap.image,
                            title: "Карта аптек",
                            subtitle: "Можете найти информацию о местных аптеках",
                            link: "", type: .map),
                Instruction(image: Asset.icHomeDelivery.image,
                            title: "Доставка",
                            subtitle: "Заказывайте онлайн с доставкой домой",
                            link: "", type: .delivery),
                Instruction(image: Asset.icHomeOrder.image,
                            title: "Как оформить",
                            subtitle: "Пошаговая инструкция покупки товара",
                            link: "", type: .instructDelivery)]
    }

    func paginateDrugs(_ page: Int,
                       _ withAnimation: Bool = false,
                       _ completion: @escaping((DrugResult) -> Void)) {
        let pathForDrugsHits = Global.pathFor(key: "drug-list")
        APIManager.instance.GET(withAnimation: withAnimation,
                                path: "\(pathForDrugsHits)?page=\(page)&filter=is_hit") { [weak self] success,
                                                                                        json,
                                                                                        error in
            guard self != nil,
                  let drugResult = Mapper<DrugResult>().map(JSONObject: json.dictionaryObject) else {
                completion(.init(map: .init(mappingType: .fromJSON, JSON: [:])))
                return
            }
            completion(drugResult)
        }
    }
}
