//
//  DrugStoreDetailVM.swift
//  Infoapteka
//
//  
//

import UIKit

protocol DrugStoreDetailVMType {
    func getDrugStoreById(_ id: Int?, _ completion: @escaping() -> Void)
}

class DrugStoreDetailVM: DrugStoreDetailVMType {
    
    // MARK: Properties
    private var drugStore: DrugStore?
    
    var drugStoreDetail: DrugStore? {
        get  {
            return self.drugStore
        }
    }
    
    var drugStoreImagesCount: Int {
        get {
            drugStore?.images.count ?? .zero
        }
    }
    
    var drugStorePhonesCount: Int {
        get {
            drugStore?.phones.count ?? .zero
        }
    }
    
    // MARK: Methods
    func getDrugStoreById(_ id: Int?, _ completion: @escaping() -> Void) {
        API.drugStoresAPI.getDrugStore(by: id) { drugStore in
            self.drugStore = drugStore
            completion()
        }
    }
    
    // MARK: Getters
    func getDrugStorePhone(by: Int) -> String? {
        return drugStorePhonesCount > by ? drugStore?.phones[by] : nil
    }
    
    func getDrugStoreImage(by: Int) -> String? {
        return drugStoreImagesCount > by ? drugStore?.images[by] : nil
    }
}
