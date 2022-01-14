//
//  CardVM.swift
//  Infoapteka
//
//  
//

import UIKit

final class CardVM: NSObject {
    
    // MARK: - Properties
    private var drug: Drug?
    
    // MARK: - Initialize
    init(_ drug: Drug?) {
        self.drug = drug
        super.init()
    }
    
    // MARK: - Methods
    func favouriteUnFavourite(_ drug: Drug?,
                              _ completion: @escaping(Bool?) -> Void) {
        API.cardAPI.changeFavourite(drug?.id ?? .zero,
                                    (drug?.isFavorites ?? false)) { success in
            completion(success)
        }
    }

    func changeQuantity(_ drug: Drug,
                        _ completion: @escaping(() -> Void)) {
        API.cardAPI.changeQuantity(drug) { inCart in
            self.drug?.isCart = (inCart ?? drug.isCart)
            completion()
        }
    }
    
    // MARK: - Setters
    func changeCardFavourite(_ favourite: Bool) -> Drug? {
        self.drug?.isFavorites = favourite
        return self.drug
    }
    
    // MARK: - Getters
    func getCard() -> Drug? {
        return self.drug
    }
    
    func getCardId() -> Int {
        return self.drug?.id ?? .zero
    }
}
