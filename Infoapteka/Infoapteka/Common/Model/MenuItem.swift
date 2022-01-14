//
//  MenuItem.swift
//  Infoapteka
//
//

import UIKit

struct MenuItem {
    var icon                : UIImage
    var moderationStatus    : ModerationStatus? = .none
    var type                : MenuItem

    enum MenuItem: String {
        case profile            = "Профиль"
        case myGoods            = "Мои товары"
        case historyOfOrders    = "История заказов"
        case aboutCompany       = "О компании"
        case help               = "Помощь"
        case programRules       = "Правила программы"
        case signIn             = "Войти"
        case signOut            = "Выйти из аккаунта"
    }
}
