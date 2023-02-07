import MapKit
#if canImport(GoogleMaps)
import GoogleMaps
#endif

protocol UniversalMapProvider {
    
    var universalMapConfiguration: UniversalMapService.Configuration { get set }
    var needLongPressGesture: Bool { get }
    
    init()
    
    func addPin(with title: String, to coordinate: CLLocationCoordinate2D)
    func centerUserLocation()
    
}

extension MKMapView: UniversalMapProvider {
    
    var needLongPressGesture: Bool { true }
    
    var universalMapConfiguration: UniversalMapService.Configuration {
        get {
            .init(
                mapProvider: .apple,
                mapType:
                    self.mapType == .standard || self.mapType == .mutedStandard ? .normal :
                    self.mapType == .hybrid || self.mapType == .hybridFlyover ? .hybrid :
                                    .satellite
            )
        }
        set {
            switch newValue.mapType {
            case .normal: self.mapType = .standard
            case .satellite: self.mapType = .satellite
            case .hybrid: self.mapType = .hybrid
            }
        }
    }
    
    func addPin(with title: String, to coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = coordinate
        
        addAnnotation(annotation)
    }
    
    func centerUserLocation() {
        LocationManager.shared.getUserLocation { [unowned self] location in
            showsUserLocation = true
            self.setCamera(MKMapCamera(lookingAtCenter: location.coordinate, fromEyeCoordinate: location.coordinate, eyeAltitude: CLLocationDistance(CLongDouble(5000))), animated: true)

        }
    }
    
    
}

#if canImport(GoogleMaps)
extension GMSMapView: UniversalMapProvider {
    
    var needLongPressGesture: Bool { false }
    
    var universalMapConfiguration: UniversalMapService.Configuration {
        get {
            .init(mapProvider: .google,
                  mapType:
                    self.mapType == .normal ? .normal :
                    self.mapType == .hybrid ? .hybrid :
                    .satellite
            )
        }
        set {
            switch newValue.mapType {
            case .normal: self.mapType = .normal
            case .satellite: self.mapType = .satellite
            case .hybrid: self.mapType = .hybrid
            }
        }
    }
    
    func addPin(with title: String, to coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.title = title
        marker.map = self
    }
    
    func centerUserLocation() {
        LocationManager.shared.getUserLocation { [unowned self] location in
            isMyLocationEnabled = true
            self.animate(toLocation: location.coordinate)
            camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15)
            
        }
    }
    
    
}
#endif
