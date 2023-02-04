//
//  UniversalMapService.swift
//  L2_project
//
//  Created by Ihor Malovanyi on 17.10.2022.
//

import MapKit
#if canImport(GoogleMaps)
import GoogleMaps
#endif

protocol UniversalMapServiceDelegate: AnyObject {
    
    func mapView(_ mapView: UniversalMapProvider, didLongPressAt coordinate: CLLocationCoordinate2D)
    
}

final class UniversalMapService: NSObject, CLLocationManagerDelegate {
    
    weak var delegate: UniversalMapServiceDelegate?
    
    private(set) var container = UIView()
    private(set) var mapView: UniversalMapProvider!
    
    init(_ defaultType: UniversalMapProvider.Type = MKMapView.self) {
        super.init()
        
        switchProvider(to: defaultType)
    }
    
    func switchProvider(to provider: UniversalMapProvider.Type) {
        let lastConfiguration = mapView?.universalMapConfiguration
        
        container.subviews.forEach { $0.removeFromSuperview() }
        mapView = provider.init()
        
        if let lastConfiguration = lastConfiguration {
            mapView.universalMapConfiguration.mapType = lastConfiguration.mapType
        }
        
        if let mapView = mapView as? UIView {
            container.addSubview(mapView)
            mapView.frame = container.bounds
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            if self.mapView.needLongPressGesture {
                mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(tapOnMap)))
            } else {
                (mapView as? GMSMapView)?.delegate = self
            }
        }
    }
    
    func showCurrentLocation(of provider: UniversalMapProvider.Type) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
        if mapView.universalMapConfiguration.mapProvider == .apple {
            guard let mapView = mapView as? MKMapView else { return }
            mapView.setRegion(region, animated: true)
        } else {
            guard let mapView = mapView as? GMSMapView else { return }
            mapView
        }
    }
    
    func switchMapType(to type: Configuration.MapType) {
        mapView.universalMapConfiguration.mapType = type
    }
    
    func addPin(with title: String, to coordinate: CLLocationCoordinate2D) {
        mapView.addPin(with: title, to: coordinate)
    }
    
    struct Configuration {
        
        enum MapProvider: Int {
            
            case apple
            case google
            
        }
        
        enum MapType: Int {
            
            case normal
            case satellite
            case hybrid
            
        }
        
        var mapProvider: MapProvider = .apple
        var mapType: MapType = .normal
        
    }
    
    @objc private func tapOnMap(_ recognizer: UILongPressGestureRecognizer) {
        guard let mapView = mapView as? MKMapView else { return }
        guard recognizer.state == .ended else { return }
        
        let touchLocation = recognizer.location(in: mapView)
        let coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        
        delegate?.mapView(mapView, didLongPressAt: coordinate)
    }
    
}

extension UniversalMapService: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        delegate?.mapView(mapView, didLongPressAt: coordinate)
    }
    
}
