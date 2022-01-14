//
//  Enums.swift
//  Infoapteka
//
//

import UIKit

enum CheckErrorVCShowType {
    case network
    case server
}

enum CheckErrorVCDismissType {
    case root
    case dismiss
    case pop
}

enum DrugStoreCVShowStates {
    case list
    case map
}

// MARK: User Options Page
//= "Продавец"
// = "Покупатель"
enum UserOptionsType: String {
    case Клиент
    case Продавец
}

// MARK: Auth Page
enum UserRegisterType {
    case phoneNumber
    case name
    case surname
    case patronymic
    case city
    case address
    case birthDay
    case certificates
}

// MARK: Menu Page
enum MenuType {
    case profile
    case orderHistory
    case aboutCompany
    case help
    case appRule
    case logout
}

// MARK: AboutCompany Page
enum AboutCompanyType {
    case desc
    case phones
    case emailAddress
    case socialMedia
    case map
}

enum ModerationStatus: String {
    case rejected
    case waiting
    case activated

    var title: String {
        get {
            switch self {
            case .rejected : return "Отклонено"
            case .waiting  : return "Ожидание"
            case .activated: return "Активировано"
            }
        }
    }
}

enum RegisterFieldType: String {
    case phone = "Номер телефона"
    case name = "Имя*"
    case surname = "Фамилия*"
    case middleName = "Отчество"
    case birthdate = "Дата рождения*"
    case address = "Адрес*"
    case certificates = "Сертификаты"
    case title
    case register
    case avatar
    case save
}

enum InstructionType {
    case map
    case delivery
    case instructDelivery
}

enum DrugStatus: String {
    case rejected
    case on_moderation
    case approved

    var title : String {
        switch self {
        case .rejected:
            return "Не одобрено"
        case .on_moderation:
            return "На модерации"
        case .approved:
            return "Одобрено"
        }
    }
    var color: UIColor {
        switch self {
        case .rejected: return Asset.secondaryRed.color
        case .on_moderation: return Asset.orange.color
        case .approved: return .clear
        }
    }
}

enum CategoryCellType {
    case superParent
    case parent
    case seeAll
    case category
}


enum CheckoutFieldType: String {
    case name = "Имя*"
    case surname = "Фамилия*"
    case phones  = "Номер телефона*"
    case district = "Выбор города*"
    case deliveryAddress = "Адрес доставки"
    case comment          = "Комментарий к заказу"
    case paymentSelection = "Выбор оплаты"
}

enum CreateDrugFieldType: String {
    case category = "Выбор категории"
    case name  = "Название товара*"
    case price = "Цена товара (сом)"
    case desc     = "Описание товара"
    case images   = "Фото товара"
    case addDrug  = "Добавить товар"
}

enum NotifType: String {
    case accountApproved = "account_approved"
    case accountRejected = "account_rejected"

    case drugApproved = "drug_approved"
    case drugRejected = "drug_rejected"

    case orderProcessed = "order_processed"
    case orderDelivered = "order_delivered"
}

enum RegisterVCShowType {
    case register
    case editProfile
}

enum CategorySelectType {
    case search
    case simple
}

enum SearchFilterType: String, Codable {
    case maxPrice                   = "По цене макс"
    case minPrice                   = "По цене мин"
    case filterAlphabeticallyByAz   = "По алфавиту А-я"
    case filterAlphabeticallyByZa   = "По алфавиту Я-а"
    case newFirst                   = "Сначала новые"
    case oldFirst                   = "Сначала старые"
    case bestseller                 = "Хит продаж"
}

enum DrugSearchVCShowType {
    case search
    case ownerProfile
}

enum DrugDetailCellType {
    case slideShow
    case desc
    case instruction
    case drugs
}

enum CreateDrugVCShowType {
    case create
    case edit
}

enum AnnotationIdentifier: String {
    case LocationAnnotation
    case UserAnnotation
}

enum CollectionType: String {
    case grid
    case list
}

enum DrugDetailBasketPushType {
    case preOrder
    case purchase
}

enum AnimateViewTo {
    case toFavorite
    case toBasket
}

enum InfoaptekaNavBarField: String {
    case logoIV
    case searchHintTF = "Поиск"
    case searchTF = "Поиск "
    case notificationBtn
}

enum PersistantKeys {
    static let isSeenOnboarding = "kIsSeenOnboarding"
    static let token            = "kToken"
    static let deviceToken      = "kDeviceToken"
    static let appBadgeCount    = "kBadgeCount"
    static let isLoggedIn       = "kIsLoggedIn"
    static let searchFilter     = "kSearchFilter"
    static let collectionType   = "kCollectionType"
    static let favouritesCount  = "kFavouritesCount"
    static let basketCount      = "kBasketCount"
    static let remotePushType   = "kRemotePushType"
    static let remotePushObjectID = "kRemotePushObjectID"
}

enum OrderStatus: String {
    case paid
    case not_paid_payment_restricted
    case not_paid_payment_allowed
    case delivered
    case reject

    var title : String? {
        switch self {
        case .paid: return "Оплачен"
        case .not_paid_payment_restricted, .not_paid_payment_allowed: return "Не оплачен"
        case .delivered: return "Доставлен"
        case .reject: return "Отменен"
        }
    }

    var color : UIColor? {
        switch self {
        case .paid: return Asset.mainBlue.color
        case .not_paid_payment_restricted, .not_paid_payment_allowed: return Asset.secondaryRed.color
        case .delivered: return Asset.mainGreen.color
        case .reject: return Asset.orange.color
        }
    }
}

enum AboutCompanyFieldType: String {
    case title       = ""
    case phones      = "Наши телефоны:"
    case email       = "Email:"
    case address     = "Наш адрес:"
    case socialMedia = "Мы в социальных сетях:"
}
