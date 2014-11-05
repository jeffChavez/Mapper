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
    }

    @IBAction func buttonPressed (sender: AnyObject) {
        
        var geoRegion = CLCircularRegion(center: self.selectedAnnotation.coordinate, radius: 1000.0, identifier: "TestRegion")
        self.locationManager.startMonitoringForRegion(geoRegion)
        
        NSNotificationCenter.defaultCenter().postNotificationName("REMINDER_ADDED", object: self, userInfo: ["region" : geoRegion])
        dismissViewControllerAnimated(true, completion: nil)
    }
}