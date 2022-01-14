//
//  MyProductVM.swift
//  Infoapteka
//
//  
//

import UIKit

final class MyDrugsVM {
    
    // MARK: Properties
    private var _myProductsResult: DrugResult?
    private var _drug     : Drug?
    private var _isLoading: Bool = false
    
    var myDrugsResult: DrugResult {
        get {
            return self._myProductsResult ?? .init(map: .init(mappingType: .fromJSON, JSON: [:]))
        }
        set { self._myProductsResult = newValue }
    }
    
    var myDrugsCount: Int {
        get { return myDrugsResult.results.count }
    }

    var drug: Drug? {
        get { return _drug }
    }
    
    var isLoading: Bool {
        set { self._isLoading = newValue }
        get { return self._isLoading }
    }
    
    // MARK: Fetch Data
    func fetchData(_ completion: @escaping() -> Void) {
        _isLoading = false
        API.mydrugsAPI.getMyDrug { drugResult in
            self._myProductsResult = drugResult
            completion()
        }
    }
    
    func paginateDrugs(_ completion: @escaping() -> Void) {
        _isLoading = true
        guard let page = _myProductsResult?.next else {
            _isLoading = false
            completion()
            return
        }
        API.mydrugsAPI.paginateDrugs(page) { myProductResult in
            let totalResultsCounnt = self._myProductsResult?.results.count ?? 0 + myProductResult.results.count
            if let count = self._myProductsResult?.count, count >= totalResultsCounnt,
               self._myProductsResult?.next != nil {
                self._myProductsResult?.results.append(contentsOf: myProductResult.results)
                self._myProductsResult?.next = myProductResult.next
            } else {
                self._myProductsResult = myProductResult
            }
            completion()
        }
    }

    func getDrug(_ byID: Int,
                 _ completion: @escaping() -> Void) {
        API.mydrugsAPI.getDrug(byID) { _drug in
            self._drug = _drug
            completion()
        }
    }
    
    // MARK: Remove Drug
    func removeDrug(_ id: Int, _ completion: @escaping((Bool) -> Void)) {
        API.mydrugsAPI.removeDrug(id) { success in
            completion(success)
        }
    }
    
    // MARK: Getters
    func getDrug(by: Int) -> Drug? {
        return myDrugsCount > by ? myDrugsResult.results[by] : nil
    }
    
    func removeDrugFromMyProducts(_ drug: Drug) {
        myDrugsResult.results.removeAll { $0.id ?? 0 == drug.id ?? 0 }
    }
    
    func isPaginationNeeded(_ indexPath: IndexPath) -> Bool {
        return (indexPath.row == myDrugsCount - 1 && _myProductsResult?.next != nil) && !_isLoading && (_myProductsResult?.count ?? 0) > myDrugsCount
    }
}
