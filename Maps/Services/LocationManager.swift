//
//  LocationManager.swift
//  Maps
//
//  Created by Dmytro Hetman on 04.02.2023.
//

import Foundation
import MapKit


class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    let locationManager = CLLocationManager()
    var completion: ((CLLocation) -> Void)?
    
    
    public func getUserLocation(completion: @escaping (CLLocation) -> Void) {
        self.completion = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        completion?(location)
        locationManager.stopUpdatingLocation()
    }
}
