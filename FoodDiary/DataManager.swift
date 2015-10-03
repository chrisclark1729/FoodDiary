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
    var otherDinersArray: [String] = []
    
    var delegate:TimelineTableViewController?
    
    func loadTimelineData () {
        foodDiaryEntryArray.removeAll(keepCapacity: false)
        
        let getTimelineData:PFQuery = PFQuery(className:"FoodDiaryEntries")
        
        /*Timeline query restraints:
        1.) Only grab non-archived images (diary entries)
        2.) Order by time of entry (most recent first)
        3.) Limit to only 50 results to improve performance
        */
        
        getTimelineData.whereKey("isVisible", equalTo: true)
        getTimelineData.whereKey("userId", equalTo: PFUser.currentUser()!)
        getTimelineData.orderByDescending("timestamp")
        getTimelineData.limit = 25
        
        getTimelineData.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                     //   if object.objectForKey("imgURL") != nil {
                        let entry = FoodDiaryEntry(mealID: object.objectId!,
                            mealName: object["mealName"] as! String,
                            timestamp: object["timestamp"] as! NSDate,
                            locationName: object["locationName"] as! String,
                            imgURL: object["imageFile"],
                            calories: object["calories"] as! Float,
                            gramsCarbs: object["gramsCarbs"] as! Float,
                            gramsProtein: object["gramsProtein"] as! Float,
                            gramsFat: object["gramsFat"] as! Float,
                            gramsFiber: object["gramsFiber"] as! Float,
                            gramsSaturatedFat: object["gramsSaturatedFat"] as! Float,
                            enjoymentScore: object["enjoymentScore"] as! Float,
                            healthScore: object["healthScore"] as! Float,
                            mood: object["mood"] as! String,
                            energyLevel: object["energyLevel"] as! Float,
                            timezone: object["timezone"] as! String,
                            isVisible: object["isVisible"] as! Bool,
                            userId: object["userId"] as! PFUser,
                          //  diners: self.otherDinersArray,
                            location: object["location"] as! PFGeoPoint)
                        entry.toPFObject = object
                        self.foodDiaryEntryArray.append(entry)
                   //     }
                    }
                    self.delegate!.meals = self.foodDiaryEntryArray
                    self.delegate!.tableView.reloadData()
                    
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            
        }
        
    }
    
   }

