//
//  FirstViewController.swift
//  Mapper
//
//  Created by Jeff Chavez on 11/3/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let locationManager = CLLocationManager()
    
    @IBOutlet var mapView : MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.mapView.delegate = self
        
        switch CLLocationManager.authorizationStatus() as CLAuthorizationStatus {
        case .Authorized:
            self.mapView.showsUserLocation = true
        case .NotDetermined:
            self.locationManager.requestAlwaysAuthorization()
        case .Restricted:
            println("Restricted")
        default:
            println("default for CLLocationManager.authorizationStatus")
        
        var longPressGesture = UILongPressGestureRecognizer(target: self, action: "didLongPress:")
        self.mapView.addGestureRecognizer(longPressGesture)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Authorized:
            self.locationManager.startUpdatingLocation()
        default:
            println("default for didChangeAuthorization")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.last as? CLLocation {
            println(location.coordinate.latitude)
        }
    }
    
    func didLongPress (gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let locationOfPress = self.mapView.convertPoint(gestureRecognizer.locationInView(self.mapView), toCoordinateFromView: self.mapView)
            var annotation = MKPointAnnotation()
            annotation.coordinate = locationOfPress
            annotation.title = "Add reminder"
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "ANNOTATION")
        annotationView.animatesDrop = true
        annotationView.canShowCallout = true
        let addReminderButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
        annotationView.rightCalloutAccessoryView = addReminderButton
        return annotationView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DETAIL_VC") as DetailViewController
        detailVC.locationManager = self.locationManager
        detailVC.selectedAnnotation =  view.annotation
        self.presentViewController(detailVC, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("inside region!")
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("outside region")
    }
}

