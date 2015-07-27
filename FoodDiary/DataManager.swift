//
//  DataManager.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/7/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import Foundation
import Parse

class DataManager {
    
    var foodDiaryEntryArray = [FoodDiaryEntry]()
    
    var delegate:TimelineTableViewController?
    
    func loadTimelineData () {
        foodDiaryEntryArray.removeAll(keepCapacity: false)
        
        var getTimelineData:PFQuery = PFQuery(className:"FoodDiaryEntries")
        
        /*Timeline query restraints:
        1.) Only grab non-archived images (diary entries)
        2.) Order by time of entry (most recent first)
        3.) Limit to only 50 results to improve performance
        */
        
        getTimelineData.whereKey("isVisible", equalTo: true)
        getTimelineData.whereKey("userId", equalTo: PFUser.currentUser()!)
        getTimelineData.orderByDescending("timestamp")
        getTimelineData.limit = 50
        
        getTimelineData.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
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
                            userId: object["userId"] as! PFUser)
                            // geoPoint: object["geoPoint"] as! PFGeoPointResultBlock)
                        
                        self.foodDiaryEntryArray.append(entry)
                        
                    }
                    self.delegate!.meals = self.foodDiaryEntryArray
                    self.delegate!.tableView.reloadData()
                    
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
            
        }
        
    }
    
   }

