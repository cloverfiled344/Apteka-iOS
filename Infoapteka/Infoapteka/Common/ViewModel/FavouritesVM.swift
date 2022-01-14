//
//  FavouritesVM.swift
//  Infoapteka
//
//  
//

import UIKit

final class FavouritesVM {
    
    private var _drugResult: DrugResult?
    private var _isLoading     : Bool = false
    
    // MARK: Fetch Data (Methods)
    func getFavourties(_ withAnimation: Bool,
                       _ completion: @escaping() -> Void) {
        API.drugResultAPI.getFavourites(_drugResult?.next, withAnimation) { [weak self] drugResult, error in
            guard let self = self, let drugResult = drugResult, error == nil else {
                self?._isLoading = false
                return
            }
            let totalResultsCounnt = self._drugResult?.results.count ?? 0 + drugResult.results.count
            if let count = self._drugResult?.count, count >= totalResultsCounnt,
               self._drugResult?.next != nil {
                self._drugResult?.results.append(contentsOf: drugResult.results)
                self._drugResult?.next = drugResult.next
            } else {
                self._drugResult = drugResult
            }
            completion()
        }
    }

    func removeDrug(_ drug: Drug?,
                    _ completion: @escaping () -> Void) {
        guard let drug = drug else { return }
        _drugResult?.results.removeAll { $0.id == drug.id && !drug.isFavorites }
        completion()
    }

    // MARK: Getters
    var drugResult: DrugResult {
        set { self._drugResult = newValue}
        get { return self._drugResult ?? .init(map: .init(mappingType: .fromJSON, JSON: [:])) }
    }
    
    func getDrug(_ by: Int) -> Drug? {
        let resultsCount: Int = self._drugResult?.results.count ?? 0
        return resultsCount > by ? self._drugResult?.results[by] : nil
    }
    
    func getDrugsCount() -> Int {
        return self._drugResult?.results.count ?? 0
    }

    var isLoading: Bool {
        set { self._isLoading = newValue }
        get { return self._isLoading }
    }

    func isPaginationNeeded(_ indexPath: IndexPath) -> Bool {
        return (indexPath.row == getDrugsCount() - 1 && _drugResult?.next != nil) && !_isLoading && (_drugResult?.count ?? 0) > getDrugsCount()
    }
}
