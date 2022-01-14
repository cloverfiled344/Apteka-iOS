//
//  LocationService.swift
//  Infoapteka
//
//  
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func didUpdate(location: CLLocation)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    weak var delegate: LocationServiceDelegate?
    
    var locationManager: CLLocationManager
    var lastLocation: CLLocation?
    
    var pendingStart = false
    
    override init() {
        
        locationManager = CLLocationManager()
        locationManager.showsBackgroundLocationIndicator = true
        
        super.init()
        
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        }
    }
    
    func startUpdates() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            pendingStart = true
        default:
            locationManager.requestAlwaysAuthorization()
            pendingStart = true
        }
    }
    
    func stopUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            if pendingStart {
                locationManager.startUpdatingLocation()
            }
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            delegate?.didUpdate(location: location)
            lastLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}
