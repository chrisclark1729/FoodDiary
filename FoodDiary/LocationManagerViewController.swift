//
//  LocationManagerViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 7/26/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationManagerViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    static let sharedLocation = LocationManagerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        
        var lat = locValue.latitude
        var lon = locValue.longitude
        
    }
    
    func refreshLocation() {
        
        self.locationManager.startUpdatingLocation()
        
        
        self.locationManager.stopUpdatingLocation()
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!)
    {
        println("Error: " + error.localizedDescription)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


