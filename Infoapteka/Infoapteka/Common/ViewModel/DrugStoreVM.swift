//
//  DrugStoreVM.swift
//  Infoapteka
//
//  
//

import UIKit

protocol DrugStoreVMType {
    func fetchData(_ completion: @escaping(() -> Void))
    func paginateDrugStores(_ completion: @escaping(() -> Void))
}

class DrugStoreVM: DrugStoreVMType {
    
    // MARK: Properties
    private var _drugStoreResult: DrugStoreResult?
    private var _isLoading      : Bool = false
    private var _drugStoreShowStates: [DrugStoreCVShowStates] = [.list, .map]
    
    var drugStoreResult: DrugStoreResult {
        get { return _drugStoreResult ?? .init(map: .init(mappingType: .fromJSON, JSON: [:])) }
        set { _drugStoreResult = newValue }
    }
    
    var drugStoresCount: Int {
        get { return _drugStoreResult?.results.count ?? .zero }
    }
    
    var isLoading: Bool {
        set { self._isLoading = newValue }
        get { return self._isLoading }
    }
    
    var drugStoreShowStates: [DrugStoreCVShowStates] {
        set { self._drugStoreShowStates = newValue }
        get { return self._drugStoreShowStates }
    }
    
    // MARK: Methods
    func fetchData(_ completion: @escaping (() -> Void)) {
        _isLoading = false
        _drugStoreResult?.next = 0
        API.drugStoresAPI.getDrugStores { result in
            self._drugStoreResult = result
            completion()
        }
    }
    
    func paginateDrugStores(_ completion: @escaping (() -> Void)) {
        _isLoading = true
        guard let page = _drugStoreResult?.next else {
            _isLoading = false
            completion()
            return
        }
        API.drugStoresAPI.paginateDrugs(page) { drugStoreResult in
            let totalResultsCounnt = self._drugStoreResult?.results.count ?? 0 + drugStoreResult.results.count
            if let count = self._drugStoreResult?.count, count >= totalResultsCounnt,
               self._drugStoreResult?.next != nil {
                self._drugStoreResult?.results.append(contentsOf: drugStoreResult.results)
                self._drugStoreResult?.next = drugStoreResult.next
            } else {
                self._drugStoreResult = drugStoreResult
            }
            completion()
        }
    }
    
    // MARK: Getters
    func getDrugStore(by: Int) -> DrugStore? {
        let resultCount: Int = _drugStoreResult?.results.count ?? .zero
        return resultCount > by ? drugStoreResult.results[by] : nil
    }
    
    func isPaginationNeeded(_ indexPath: IndexPath) -> Bool {
        return (indexPath.row == drugStoresCount - 1  && self._drugStoreResult?.next != nil) && !_isLoading && (drugStoreResult.count ?? 0) > drugStoresCount
    }
    
    func getDrugStoreId(by: Int) -> Int? {
        return getDrugStore(by: by)?.id
    }
}
