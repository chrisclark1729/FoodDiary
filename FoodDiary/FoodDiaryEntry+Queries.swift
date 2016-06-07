//
//  FoodDiaryEntry+Queries.swift
//  FoodDiary
//
//  Created by Chris Clark on 11/16/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import Foundation
//import Parse

extension FoodDiaryEntry {
    
    static func getRecentFoodDiaryEntryPFObjects() -> [AnyObject] {
        let getRecentFoodDiaryEntries:PFQuery = PFQuery(className:"FoodDiaryEntries")
       // getRecentFoodDiaryEntries.whereKey("userId", equalTo: PFUser.currentUser()!)
        getRecentFoodDiaryEntries.whereKey("userId", equalTo: "Z66C62Ev7M")
        getRecentFoodDiaryEntries.orderByDescending("timestamp")
        getRecentFoodDiaryEntries.limit = 10
        
        do {
            let entries = try getRecentFoodDiaryEntries.findObjects()
            
            return entries
        } catch let error as NSError {
            print(error.localizedDescription)
        }
       return [AnyObject]()
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
    
    func getNearbyFoodDiaryEntries(distance: Double) -> [FoodDiaryEntry] {
        let geoPoint = self.location
        let nearbyMeals:PFQuery = PFQuery(className:"FoodDiaryEntries")
        nearbyMeals.whereKey("location", nearGeoPoint: geoPoint, withinMiles: distance)
        do {
            let fetchedObjects = try nearbyMeals.findObjects()
            var entries = [FoodDiaryEntry]()
            for fetchedObject in fetchedObjects {
                let entry = FoodDiaryEntry(fetchedObject: fetchedObject)
                entries.append(entry)
            }
            
            return entries
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return [FoodDiaryEntry]()
    }
    
     func getNearbyFoodDiaryEntriesPFObjects(distance: Double) -> [PFObject] {
        let geoPoint = self.location
        let nearbyMeals:PFQuery = PFQuery(className:"FoodDiaryEntries")
        nearbyMeals.whereKey("location", nearGeoPoint: geoPoint, withinMiles: distance)
        nearbyMeals.whereKey("userId", equalTo: "Z66C62Ev7M")
       // nearbyMeals.whereKey("userId", equalTo: PFUser.currentUser()!)
        
        do {
            let fetchedObjects = try nearbyMeals.findObjects()
            /*
            var entries = [FoodDiaryEntry]()
            for fetchedObject in fetchedObjects! {
            let entry = FoodDiaryEntry(fetchedObject: fetchedObject as! PFObject)
            entries.append(entry)
            }
            */
            return fetchedObjects 
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return [PFObject]()
    }
    
    func isDinerNameSelected(dinerName: String) -> Bool {
        for diner in self.diners {
            if diner.name == dinerName {
                return true
            }
        }
        return false
    }
    
    func getDinerSuggestions() -> [String] {
        var dinerNameSuggestions = [String]()
        let dinerSuggestions:PFQuery = PFQuery(className: "FoodDiaryEntryDiners")
        dinerSuggestions.whereKey("foodDiaryEntryId", containedIn: self.getNearbyFoodDiaryEntriesPFObjects(1.0))
        do {
            let fetchedObjects = try dinerSuggestions.findObjects()
            for fetchedObject in fetchedObjects {
                let entry = fetchedObject
                if dinerNameSuggestions.count > 0 {
                    let nameForConsideration = fetchedObject["dinerName"] as! String
                    
                    if dinerNameSuggestions.contains(nameForConsideration) {
                        print("\(entry["dinerName"]) already in suggestions array.")
                    } else if self.isDinerNameSelected(nameForConsideration) {
                        print("\(nameForConsideration) is already selected.")
                    }
                    else {
                        dinerNameSuggestions.append(entry["dinerName"] as! String)
                    }
                    
                } else {
                    dinerNameSuggestions.append(entry["dinerName"] as! String)
                }
            }
            
            return dinerNameSuggestions
        } catch let error as NSError {
            print(error.localizedDescription)
        }
       return [String]()
    }
    
    func getTagSuggestions() -> [String] {
        var tagSuggestions = [String]()
        let tagSuggestionsQuery:PFQuery = PFQuery(className: "FoodDiaryTags")
        tagSuggestionsQuery.whereKey("foodDiaryEntryId", containedIn: self.getNearbyFoodDiaryEntriesPFObjects(5.0))
        do {
            let fetchedObjects = try tagSuggestionsQuery.findObjects()
            for fetchedObject in fetchedObjects {
                let entry = fetchedObject
                if tagSuggestions.count > 0 {
                    let tagForConsideration = fetchedObject["foodDiaryTag"] as! String
                    
                    if tagSuggestions.contains(tagForConsideration) {
                        print("\(entry["foodDiaryTag"]) already in array.")
                    } else {
                        tagSuggestions.append(entry["foodDiaryTag"] as! String)
                    }
                } else {
                    tagSuggestions.append(entry["foodDiaryTag"] as! String)
                }
            }
            
            return tagSuggestions
 
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return [String]()
            }
    
    static func getLocationSuggestions(geoPoint: PFGeoPoint) -> [String] {
        let nearbyLocations:PFQuery = PFQuery(className:"FoodDiaryEntries")
        nearbyLocations.whereKey("location", nearGeoPoint: geoPoint, withinMiles: 0.04)
        nearbyLocations.limit = 10
        nearbyLocations.whereKey("locationName", notEqualTo: "")
        nearbyLocations.orderByDescending("timestamp")
        nearbyLocations.selectKeys(["locationName"])
        
        do {
            let fetchedObjects = try nearbyLocations.findObjects()
            var entries = [String]()
            for fetchedObject in fetchedObjects {
                print(fetchedObject["locationName"])
                let entry = fetchedObject
                if entries.count > 0 {
                    let nameForConsideration = fetchedObject["locationName"] as! String
                    
                    if entries.contains(nameForConsideration) {
                        print("\(entry["locationName"]) already in array.")
                    } else {
                        entries.append(entry["locationName"] as! String)
                    }
                } else {
                    entries.append(entry["locationName"] as! String)
                }
            }
            
            return entries
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return [String]()
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


