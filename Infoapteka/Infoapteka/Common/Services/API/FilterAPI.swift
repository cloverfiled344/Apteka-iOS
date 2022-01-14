//
//  FilterAPI.swift
//  Infoapteka
//
//

import Foundation

final class FilterAPI {

    func getFilters(_ completion: @escaping(([SearchFilter]) -> Void)) {
        completion([
            .init(1, false, .maxPrice),
            .init(2, false, .minPrice),
            .init(3, false, .filterAlphabeticallyByAz),
            .init(4, false, .filterAlphabeticallyByZa),
            .init(5, false, .newFirst),
            .init(6, false, .oldFirst),
            .init(7, false, .bestseller)
        ])
    }
}
