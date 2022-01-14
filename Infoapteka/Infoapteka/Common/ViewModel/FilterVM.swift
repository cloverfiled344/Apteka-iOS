//
//  FilterVM.swift
//  Infoapteka
//
//

import Foundation

final class FilterVM {

    private var filters: [SearchFilter] = []

    func getFilters(_ completion: @escaping(() -> Void)) {
        API.filterAPI.getFilters { filters in
            self.filters = filters
            completion()
        }
    }

    //MARK: -- getters
    func getTitle() -> String {
        return L10n.sort
    }

    func getFiltersCount() -> Int {
        self.filters.count
    }

    func getFilter(_ by: Int) -> SearchFilter? {
        filters.count > by ? filters[by] : nil
    }

    func selectFilter(_ by: Int) {
        filters.indices.forEach { filters[$0].isSelected = false }
        filters.count > by ? filters[by].isSelected = true : nil
    }

    func selectFilter(_ searchFilter: SearchFilter) {
        if filters.filter({ $0.id == searchFilter.id }).isEmpty {
            filters.append(searchFilter)
        } else {
            filters.indices.forEach { filters[$0].isSelected = (filters[$0].id == searchFilter.id) ? true : false }
        }
    }

    func getSelectedFilter(_ by: Int) -> SearchFilter? {
        filters.filter { $0.isSelected }.first
    }
}
