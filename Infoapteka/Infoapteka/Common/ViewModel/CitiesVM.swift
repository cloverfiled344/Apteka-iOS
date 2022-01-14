//
//  CitiesVM.swift
//  Infoapteka
//
//

import Foundation

enum CitiesTVType {
    case search
    case cities
}

final class CitiesVM {

    private var cities: [City] = []
    private var filteredCities: [City] = []
    private var isSearching: Bool = false
    private var title: String?
    private var type : CitiesTVType

    init(_ type: CitiesTVType) {
        self.type = type
    }
    init(_ type: CitiesTVType, _ city: City) {
        self.cities = city.districts
        self.title = city.title
        self.type = type
    }

    func getCities(_ completion: @escaping(() -> Void)) {
        guard cities.isEmpty, !isSearching else {
            completion()
            return
        }
        switch type {
        case .search:
            API.citiesAPI.searchDistricts { cities in
                self.cities = cities
                completion()
            }
        case .cities:
            API.citiesAPI.fetchCities { cities in
                self.cities = cities
                completion()
            }
        }
    }
    
    //MARK: -- getters
    func getTitle() -> String { title ?? L10n.selectCity }
    func getCitiesCount() -> Int { isSearching ? filteredCities.count : cities.count }
    func getCity(_ by: Int) -> City? { isSearching ? (filteredCities.count > by ? filteredCities[by] : nil) : (cities.count > by ? cities[by] : nil) }

    func filterCities(_ title: String, _ completion: @escaping(() -> Void)) {
        isSearching = !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        filteredCities = cities.filter { ($0.title ?? "").lowercased().contains(title.lowercased()) }
        completion()
    }
}
