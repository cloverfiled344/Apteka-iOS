//
//  CardAPI.swift
//  Infoapteka
//
//  
//

import UIKit
import Alamofire

final class CardAPI {
    
    func changeFavourite(_ id: Int,
                         _ isFavourite: Bool,
                         _ completion: @escaping(Bool?) -> Void) {
        switch isFavourite {
        case true:
            removeCardFromFavourite(id, completion)
        case false:
            addCardToFavourite(id, completion)
        }
    }
    
    private func addCardToFavourite(_ id: Int,
                                    _ completion: @escaping(Bool?) -> Void) {
        let path: String = Global.pathFor(key: "account")
        APIManager.instance.POST(path: "\(path)favorite/\(id)/add/") { success,
                                                                       json,
                                                                       error in
            completion(success ? true : nil)
        }
    }
    
    private func removeCardFromFavourite(_ id: Int,
                                         _ completion: @escaping(Bool?) -> Void) {
        let path: String = Global.pathFor(key: "account")
        APIManager.instance.DELETE(path: "\(path)favorite/\(id)/remove/",
                                   parameters: nil) { success,
                                                      json,
                                                      error in
            completion(success ? false : nil)
        }
    }

    func changeQuantity(_ drug: Drug,
                        _ completion: @escaping((Bool?) -> Void)) {
        let path = Global.pathFor(key: "cart")
        let state = drug.isCart ? "remove" : "add"
        APIManager.instance.POST(path: "\(path)\(drug.id ?? 0)/\(state)/",
                                 parameters: nil) { success,
                                                    json,
                                                    error in
            if drug.isCart && success {
                completion(false)
            } else if !drug.isCart && success {
                completion(true)
            } else {
                completion(drug.isCart)
            }
        }
    }
}
