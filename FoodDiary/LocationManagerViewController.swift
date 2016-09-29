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
    var lastKnownLatitude: Float = 0
    var lastKnownLongitude: Float = 0
    var lastKnownLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      //  var locValue:CLLocationCoordinate2D = manager.location.coordinate
        
        self.lastKnownLocation = manager.location
        print("Location Found")
        self.locationManager.stopUpdatingLocation()
    }
    
    func refreshLocation() {
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error: " + error.localizedDescription)
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


