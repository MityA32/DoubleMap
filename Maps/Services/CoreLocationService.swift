//
//  CoreLocationService.swift
//  Maps
//
//  Created by Dmytro Hetman on 24.10.2022.
//

import CoreLocation
import Foundation

class CoreLocationService: NSObject, CLLocationManagerDelegate {
    
    static let shared = CoreLocationService()
    
    let manager = CLLocationManager()
    var completion: ((CLLocation) -> Void)?
    
    func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
        self.completion = completion
    }
    
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        <#code#>
//    }
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        checkLocationAuthorization()
//    }
}
