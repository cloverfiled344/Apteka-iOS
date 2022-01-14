//
//  BasketVM.swift
//  Infoapteka
//
//

import Foundation

final class BasketVM {

    private var _basket: Basket?

    func getBasket(_ completion: @escaping(() -> Void)) {
        API.basketAPI.getBasket { basket in
            self._basket = basket
            completion()
        }
    }

    var basket: Basket? {
        get { return _basket }
    }

    var numberOfRowsInSection: Int {
        get { return _basket?.carts.count ?? 0 }
    }

    func getCart(_ by: Int) -> Cart? {
        numberOfRowsInSection > by ? _basket?.carts[by] : nil
    }

    func deleteCart(_ cart: Cart,
                    _ completion: @escaping(() -> Void)) {
        API.basketAPI.deleteCart(cart) { success in
            guard let basket = self._basket else { return }
            success ? self._basket?.carts.removeAll { $0.id == cart.id } : nil
            self._basket?.totalCartItems = (basket.totalCartItems ?? 0) - 1
            self._basket?.totalCart = (basket.totalCart ?? 0) - (cart.drug?.price ?? 0)
            completion()
        }
    }

    func changeQuantity(_ cart: Cart,
                        _ quantity: Int,
                        _ completion: @escaping(() -> Void)) {
        API.basketAPI.changeQuantity(cart, quantity) { success in
            guard let basket = self._basket else { return }

            guard let index = basket.carts.firstIndex(where: { $0.id == cart.id }),
                  basket.carts.count > index else { return }

            self._basket?.carts[index].quantity = quantity

            let changedQuantity = quantity - (cart.quantity ?? 0)
            self._basket?.totalCartItems = (basket.totalCartItems ?? 0) + (changedQuantity)
            self._basket?.totalCart = (basket.totalCart ?? 0) + (changedQuantity * (cart.drug?.price ?? 0))
            completion()
        }
    }

    func changeFavourite(_ cart: Cart,
                         _ isFavourite: Bool,
                         _ completion: @escaping((Bool) -> Void)) {
        guard let drug = cart.drug else { completion(false); return }
        API.basketAPI.changeFavourite(drug, isFavourite) { success in
            guard let cartIndex = self._basket?.carts.firstIndex(where: { $0.id == cart.id }),
                  (self._basket?.carts.count ?? 0) > cartIndex else { return }
            self._basket?.carts[cartIndex].drug?.isFavorites = isFavourite
            completion(success)
        }
    }
}
