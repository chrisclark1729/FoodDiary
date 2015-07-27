//
//  FoodDiaryEntry+UpdateData.swift
//  FoodDiary
//
//  Created by Chris Clark on 7/14/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import Foundation
import UIKit
import Parse

extension FoodDiaryEntry {
    
    func save() {
        var query = PFQuery(className:"FoodDiaryEntries")
        query.getObjectInBackgroundWithId(self.mealID) {
            (FoodDiaryEntry: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let entry = FoodDiaryEntry {
                entry["mealName"] = self.mealName
                entry["locationName"] = self.locationName
                entry["timestamp"] = self.timestamp
                entry["locationName"] = self.locationName
                entry["ingredients"] = self.ingredients
                entry["calories"] = self.calories
                entry["gramsFat"] = self.gramsFat
                entry["gramsCarbs"] = self.gramsCarbs
                entry["gramsProtein"] = self.gramsProtein
                entry["gramsFiber"] = self.gramsFiber
                entry["enjoymentScore"] = self.enjoymentScore
                entry["healthScore"] = self.healthScore
                entry["mood"] = self.mood
                entry["energyLevel"] = self.energyLevel
                entry["otherPeople"] = self.otherPeople
                entry["notes"] = self.notes
                entry["timezone"] = self.timezone
                entry["isVisible"] = self.isVisible
                entry["userID"] = PFUser.currentUser()
                entry["location"] = PFGeoPoint()
                
                entry.saveInBackground()
                entry.fetch()
            }
        }
    }
    
    func loadData() {
      //  timelineFoodDiaryData.removeAllObjects()
        
        var getTimelineData:PFQuery = PFQuery(className:"FoodDiaryEntries")
        
        /*Timeline query restraints:
        1.) Only grab non-archived images (diary entries)
        2.) Order by time of entry (most recent first)
        3.) Limit to only 50 results to improve performance
        */
        
        getTimelineData.whereKey("isVisible", equalTo: true)
        getTimelineData.orderByDescending("timestamp")
        getTimelineData.limit = 50
        
        getTimelineData.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects 
                
                var foodDiaryEntryArray = [FoodDiaryEntry]()
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        // println(object.objectId)
                        var entry = FoodDiaryEntry(mealID: object.objectId!,
                            mealName: object["mealName"] as! String,
                            timestamp: object["timestamp"] as! NSDate,
                            locationName: object["locationName"] as! String,
                            ingredients: object["ingredients"] as! String,
                            imgURL: object["imageFile"],
                            calories: object["calories"] as! Int,
                            gramsCarbs: object["gramsCarbs"] as! Int,
                            gramsProtein: object["gramsProtein"] as! Int,
                            gramsFat: object["gramsFat"] as! Int,
                            gramsFiber: object["gramsFiber"] as! Int,
                            enjoymentScore: object["enjoymentScore"] as! Int,
                            healthScore: object["healthScore"] as! Int,
                            mood: object["mood"] as! String,
                            energyLevel: object["energyLevel"] as! Int,
                            otherPeople: object["otherDiners"] as! String,
                            notes: object["Notes"] as! String,
                            timezone: object["timezone"] as! String,
                            isVisible: object["isVisible"] as! Bool,
                            userId: object["userId"] as! PFUser,
                            location: object["geoPoint"] as! PFGeoPoint)
                        
                        foodDiaryEntryArray.append(entry)
                        
                    }
                    
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
            
            
            }
 
    }
}