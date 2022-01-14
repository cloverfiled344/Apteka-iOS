//
//  API.swift
//  Infoapteka
//
//

import Foundation

final class API {
    static let onboardingAPI  =  OnboardingAPI()
    static let cabinetAPI     =  CabinetAPI()
    static let registerAPI    =  RegisterAPI()
    static let helpAPI        =  HelpResultAPI()
    static let aboutAPI       =  AboutCompanyResultAPI()
    static let citiesAPI      =  CitiesAPI()
    static let authAPI        =  AuthAPI()
    static let hintsAPI       =  HintsAPI()
    static let categoriesAPI  =  CategoriesAPI()
    static let homeAPI        =  HomeAPI()
    static let drugResultAPI  =  FavouritesAPI()
    static let drugSearchAPI  =  DrugSearchAPI()
    static let filterAPI      =  FilterAPI()
    static let basketAPI      =  BasketAPI()
    static let cardAPI        =  CardAPI()
    static let drugDetailAPI  =  DrugDetailAPI()
    static let mydrugsAPI     =  MyDrugsAPI()
    static let checkoutAPI    = CheckoutAPI()
    static let createDrugAPI  = CreateDrugAPI()
    static let notificationsAPI = NotificationsAPI()
    static let orderHistoryAPI  = OrderHistoryAPI()
    static let drugStoresAPI = DrugStoreAPI()
    static let appSettingAPI = AppSettingAPI()
}

