//
//  MapSettingsViewController.swift
//  Maps
//
//  Created by Dmytro Hetman on 21.10.2022.
//

import UIKit

class MapSettingsViewController: UIViewController {

    
    @IBOutlet private weak var mapProviderControl: UISegmentedControl!
    @IBOutlet private weak var mapTypeControl: UISegmentedControl!
    
    weak var delegate: UniversalMapViewController?
    
    var mapSettings: UniversalMapService.Configuration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapProviderControl.selectedSegmentIndex = mapSettings?.mapProvider.rawValue ?? 0
        mapTypeControl.selectedSegmentIndex = mapSettings?.mapType.rawValue ?? 0
        
    }
    
    @IBAction func mapProviderSwitch(_ sender: UISegmentedControl) {
        delegate?.updateMapProvider(by: sender.selectedSegmentIndex)
    }
    
    
    @IBAction func mapTypeSwitch(_ sender: UISegmentedControl) {
        delegate?.updateMapType(by: sender.selectedSegmentIndex)
    }
    
    
    
    

}
