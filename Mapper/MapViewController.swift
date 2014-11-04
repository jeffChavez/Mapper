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
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let locationManager = CLLocationManager()
    var managedObjectContext : NSManagedObjectContext!
    var error : NSError?
    var reminderArray : [Reminder]?
    @IBOutlet var mapView : MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var longPressGesture = UILongPressGestureRecognizer(target: self, action: "didLongPress:")
        self.mapView.addGestureRecognizer(longPressGesture)
        
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
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addReminder:", name: "REMINDER_ADDED", object: nil)
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Reminder")
        var error : NSError?
        if let reminders = self.managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [Reminder] {
            if reminders.isEmpty {
                self.reminderArray = self.managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [Reminder]
            } else {
                self.reminderArray = reminders
            }
        }
        println(self.reminderArray![0].identifier)
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
        }
    }
    
    func didLongPress (gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let locationOfPress = self.mapView.convertPoint(gestureRecognizer.locationInView(self.mapView), toCoordinateFromView: self.mapView)
            var annotation = MKPointAnnotation()
            annotation.coordinate = locationOfPress
            annotation.title = "Add reminder"
            self.mapView.addAnnotation(annotation)
            println("pressed")
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
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func addReminder (notification: NSNotification) {
        let userInfo = notification.userInfo!
        let geoRegion = userInfo["region"] as CLCircularRegion
        
        var regionToSave = NSEntityDescription.insertNewObjectForEntityForName("Reminder", inManagedObjectContext: self.managedObjectContext) as Reminder
        regionToSave.identifier = geoRegion.identifier
        regionToSave.radius = geoRegion.radius
        regionToSave.coordinateX = geoRegion.center.latitude
        regionToSave.coordinateY = geoRegion.center.longitude
        regionToSave.date = NSDate()
        self.managedObjectContext.save(&self.error)
        
        let overlay = MKCircle(centerCoordinate: geoRegion.center, radius: geoRegion.radius)
        self.mapView.addOverlay(overlay)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.5)
        
        return renderer
    }
}