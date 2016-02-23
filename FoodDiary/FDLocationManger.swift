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
import Parse

class FDLocationManager: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    static let sharedLocation = FDLocationManager()
    var lastKnownLatitude: Float = 0
    var lastKnownLongitude: Float = 0
    var lastKnownLocation: CLLocation?
    var locationNameGuess = ""

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error: " + error.localizedDescription)
    }
    
    let placesClient = GMSPlacesClient()
    
    func getCurrentPlace()  {
        
        var likelihoodScore:Double = 0
        
        placesClient.currentPlaceWithCallback({ (placeLikelihoods, error) -> Void in
            if error != nil {
                print("Current Place error: \(error!.localizedDescription)")
                return
            }
            
            for likelihood in placeLikelihoods!.likelihoods {
                if let likelihood = likelihood as? GMSPlaceLikelihood {
                    let place = likelihood.place
                    
                    if likelihood.likelihood > likelihoodScore {
                        likelihoodScore = likelihood.likelihood
                        self.locationNameGuess = place.name
                    }
                    
                    print("likelihood score is now: \(likelihoodScore)")
                    
             // print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                }
            }
            
            if likelihoodScore < 0.8 {
                self.locationNameGuess = self.getLocationNameFromBackend()
            }
        })
        
    }
    
    func getLocationNameFromBackend() -> String {

        let locationNameSuggestions = FoodDiaryEntry.getLocationSuggestions(PFGeoPoint(location: FDLocationManager.sharedLocation.lastKnownLocation))
        
        var locationName = ""
        
        if locationNameSuggestions.count > 0 {
            locationName = locationNameSuggestions[0]
        }
        
        return locationName
        
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


