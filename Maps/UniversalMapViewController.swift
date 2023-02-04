//
//  ViewController.swift
//  Maps
//
//  Created by Dmytro Hetman on 19.10.2022.
//

import UIKit

class UniversalMapViewController: UIViewController {

    private var mapSerivce = UniversalMapService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.insertSubview(mapSerivce.container, at: 0)
        self.mapSerivce.container.frame = view.bounds
        self.mapSerivce.container.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }


}

