//
//  FoodDiaryEntry+Queries.swift
//  FoodDiary
//
//  Created by Chris Clark on 11/16/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import Foundation
import Parse

extension FoodDiaryEntry {
    static func getRecentFoodDiaryEntryPFObjectsWithWhereKey(whereString: String) -> [AnyObject] {
        let foodDiaryEntries:PFQuery = PFQuery(className:"FoodDiaryEntries")
        foodDiaryEntries.whereKey("userId", equalTo: PFUser.currentUser()!)
        foodDiaryEntries.orderByDescending("timestamp")
        foodDiaryEntries.limit = 10
        
        let entries = foodDiaryEntries.findObjects()
        
        return entries!
    }
    
    static func getRecentFoodDiaryEntryPFObjects() -> [AnyObject] {
        let getRecentFoodDiaryEntries:PFQuery = PFQuery(className:"FoodDiaryEntries")
        getRecentFoodDiaryEntries.whereKey("userId", equalTo: PFUser.currentUser()!)
        getRecentFoodDiaryEntries.orderByDescending("timestamp")
        getRecentFoodDiaryEntries.limit = 10
        
        let entries = getRecentFoodDiaryEntries.findObjects()
        
        return entries!
    }
    
    func getRecentFoodDiaryEntries() -> [FoodDiaryEntry] {
        let fetchedObjects = FoodDiaryEntry.getRecentFoodDiaryEntryPFObjects()
        var entries = [FoodDiaryEntry]()
        for fetchedObject in fetchedObjects {
            let entry = FoodDiaryEntry(fetchedObject: fetchedObject as! PFObject)
            entries.append(entry)
        }
        
        
        return entries
    }
    
    func getNearbyFoodDiaryEntries() -> [FoodDiaryEntry] {
        let geoPoint = self.location
        let nearbyMeals:PFQuery = PFQuery(className:"FoodDiaryEntries")
        nearbyMeals.whereKey("location", nearGeoPoint: geoPoint, withinMiles: 0.1)
        let fetchedObjects = nearbyMeals.findObjects()
        var entries = [FoodDiaryEntry]()
        for fetchedObject in fetchedObjects! {
            let entry = FoodDiaryEntry(fetchedObject: fetchedObject as! PFObject)
            entries.append(entry)
        }
        
        return entries
    }
    
    static func getLocationSuggestions(geoPoint: PFGeoPoint) -> [String] {
        let nearbyLocations:PFQuery = PFQuery(className:"FoodDiaryEntries")
        nearbyLocations.whereKey("location", nearGeoPoint: geoPoint, withinMiles: 0.04)
        nearbyLocations.limit = 10
        nearbyLocations.whereKey("locationName", notEqualTo: "")
        nearbyLocations.selectKeys(["locationName"])
        
        let fetchedObjects = nearbyLocations.findObjects()
        var entries = [String]()
        for fetchedObject in fetchedObjects! {
            let entry = fetchedObject
            
            if entries.count > 0 {
                
                let nameForConsideration = fetchedObject["locationName"] as! String
                
                if entries.contains(nameForConsideration) {
                    print("Location already in array.")
                } else {
                    entries.append(entry as! String)
                }
                
            }
        }
        return entries
    }
    
    func getLocationName() -> String {
        return self.locationName
    }
    
    /*
    
    static func getMealSuggestions() -> [Meal] {
    let geoPoint = self.location
    let nearbyMeals:PFQuery = PFQuery(className:"FoodDiaryEntries")
    nearbyMeals.whereKey("location", nearGeoPoint: geoPoint, withinMiles: 0.1)
    //TODO: Get +/- 3 hours as a condition. Issue is need to extract "time part" only irrespective of day.
    let fetchedObjects = nearbyMeals.findObjects()
    var entries = [FoodDiaryEntry]()
    for fetchedObject in fetchedObjects! {
    let entry = FoodDiaryEntry(fetchedObject: fetchedObject as! PFObject)
    entries.append(entry)
    }
    
    return entries
    }
    
    */
    
}


