//
//  UniversalMapViewController.swift
//  Maps
//
//  Created by Dmytro Hetman on 19.10.2022.
//

import UIKit
import MapKit
#if canImport(GoogleMaps)
import GoogleMaps
#endif

class UniversalMapViewController: UIViewController, UniversalMapSettings {

    private var mapSerivce = UniversalMapService()
    
    var settingsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground
        button.tintColor = .systemGray
        button.layer.cornerRadius = 5
        button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        return button
    }()
    
    var centerCameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground
        button.tintColor = .systemGray
        button.layer.cornerRadius = 5
        button.setImage(UIImage(systemName: "location.circle"), for: .normal)
        return button
    }()
    
    var mapTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 2.0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 5
        textField.placeholder = "Search here"
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureMap()

    }
    
    
    
    
    func configureMap() {
        view.addSubview(mapSerivce.container)
        view.addSubview(mapTextField)
        
        mapSerivce.container.frame = view.bounds
        mapSerivce.container.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        if let mapView = mapSerivce.mapView as? MKMapView {
            mapView.showsUserLocation = true
        }
        let settingsButton = self.settingsButton
        settingsButton.addTarget(self, action: #selector(showSettingsMenu(_:)), for: .touchUpInside)
        view.addSubview(settingsButton)
        
        let centerCameraButton = self.centerCameraButton
        centerCameraButton.addTarget(self, action: #selector(centerCurrentLocation(_:)), for: .touchUpInside)
        view.addSubview(centerCameraButton)
        
        NSLayoutConstraint.activate([
            mapTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            mapTextField.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            mapTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            mapTextField.heightAnchor.constraint(equalToConstant: 44),
            settingsButton.topAnchor.constraint(equalTo: mapTextField.bottomAnchor, constant: CGFloat(50)),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CGFloat(-14)),
            settingsButton.widthAnchor.constraint(equalToConstant: CGFloat(40)),
            settingsButton.heightAnchor.constraint(equalToConstant: CGFloat(40)),
            centerCameraButton.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: CGFloat(10)),
            centerCameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CGFloat(-14)),
            centerCameraButton.widthAnchor.constraint(equalToConstant: CGFloat(40)),
            centerCameraButton.heightAnchor.constraint(equalToConstant: CGFloat(40))
        ])
        
        
    }
    
    
    
    
    @objc func showSettingsMenu(_ sender: UIButton) {
        let settingsViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapSettingsViewController") as! MapSettingsViewController
        settingsViewController.mapSettings = mapSerivce.mapView.universalMapConfiguration
        settingsViewController.delegate = self
        if let sheet = settingsViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.preferredCornerRadius = view.frame.size.width * 0.05
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(settingsViewController, animated: true)
    }
    
    @objc func centerCurrentLocation(_ sender: UIButton) {
        if LocationManager.shared.locationManager.authorizationStatus == .denied {
            DispatchQueue.main.async { [unowned self] in
                self.present(mapSerivce.disableLocationFeatures(), animated: true)
            }
            
            return
        }
        mapSerivce.centerUserLocation()
    }
    
    func moveMapCamera(at cordinate: CLLocationCoordinate2D, animated: Bool = false) {
        let camera = MKMapCamera()
        camera.centerCoordinate = cordinate
        camera.pitch = 0
        camera.altitude = 9000
        if let map = mapSerivce.mapView as? MKMapView {
            map.setCamera(camera, animated: animated)
        }

    }
    
    func updateMapProvider(by index: Int) {
        self.mapSerivce.switchProvider(to: index == 0 ? MKMapView.self : GMSMapView.self)
    }
    
    func updateMapType(by segmentIndex: Int) {
        self.mapSerivce.switchMapType(to: .init(rawValue: segmentIndex) ?? .normal)
    }
    
    
}



protocol UniversalMapSettings {
    func updateMapProvider(by segmentIndex: Int)
    func updateMapType(by segmentIndex: Int)
}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


//                    let restrictedLocationAlert = UIAlertController(title: "Alert", message: "Provide location to see where you are", preferredStyle: .alert)
//                    restrictedLocationAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                        switch action.style {
//                        case .default:
//                            print("OK")
//
//                        case .cancel:
//                            print("cancel")
//                        case .destructive:
//                            print("des")
//                        @unknown default:
//                            fatalError("Something unknown happend")
//                        }
//                    }))
//                    DispatchQueue.main.async { [unowned self] in
//                        self.present(restrictedLocationAlert, animated: true)
//                    }
