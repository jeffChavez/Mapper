//
//  SecondViewController.swift
//  Mapper
//
//  Created by Jeff Chavez on 11/3/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController {

    var locationManager : CLLocationManager!
    var selectedAnnotation : MKAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed (sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
        var geoRegion = CLCircularRegion(center: self.selectedAnnotation.coordinate, radius: 100.0, identifier: "TestRegion")
        self.locationManager.startMonitoringForRegion(geoRegion)
        
    }
    
    
}

