//
//  DrugStoreAPI.swift
//  Infoapteka
//
//  
//

import UIKit
import ObjectMapper

class DrugStoreAPI {
    
    // MARK: DrugStoreAddresses
    fileprivate let locationService = LocationService()
    
    func getDrugStores(_ completion: @escaping((DrugStoreResult) -> Void)) {

        var drugStoreResult: (DrugStoreResult) = (.init(map: .init(mappingType: .fromJSON, JSON: [:])))
        paginateDrugs(1, true) { result in
            drugStoreResult = result
            completion(drugStoreResult)
        }
    }
    
    func paginateDrugs(_ page: Int,
                       _ withAnimation: Bool = false,
                       _ completion: @escaping((DrugStoreResult) -> Void)) {
        self.locationService.startUpdates()
        var path = Global.pathFor(key: "info")

        if let latitude = locationService.locationManager.location?.coordinate.latitude,
           let longitude = locationService.locationManager.location?.coordinate.longitude {
            path.append("branch/?lat\(latitude)&lng=\(longitude)")
        }
        else {
            path.append("branch/")
        }
        
        APIManager.instance.GET(withAnimation: withAnimation, path: path) { [weak self] success, json, error in
            self?.locationService.stopUpdates()
            guard self != nil , let drugStoreResult = Mapper<DrugStoreResult>().map(JSONObject: json.dictionaryObject) else {
                completion(.init(map: .init(mappingType: .fromJSON, JSON: [:])))
                return
            }
            completion(drugStoreResult)
        }
    }
    
    // MARK: DrugStoreDetail
    func getDrugStore(by id: Int?, _ completion: @escaping((DrugStore) -> Void)) {
        
        self.locationService.startUpdates()
        var path = Global.pathFor(key: "info")
        
        if let latitude = locationService.locationManager.location?.coordinate.latitude,
           let longitude = locationService.locationManager.location?.coordinate.longitude,
           let id = id{
            path.append("branch/\(id)/?lat\(latitude)&lng=\(longitude)")
        }
        else {
            path.append("branch/\(id ?? .zero)")
        }
        
        APIManager.instance.GET(path: path) { [weak self] success, json, error in
            self?.locationService.stopUpdates()
            guard self != nil, let drugStore = Mapper<DrugStore>().map(JSONObject: json.dictionaryObject) else {
                completion(.init(map: .init(mappingType: .fromJSON, JSON: [:])))
                return 
            }
            completion(drugStore)
            
        }
    }
}
