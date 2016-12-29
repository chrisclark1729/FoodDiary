//
//  DataManager.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/7/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import Foundation
//import Parse

class DataManager {
    
    var foodDiaryEntryArray = [FoodDiaryEntry]()
    var otherDinersArray: [String] = []
    var delegate:TimelineTableViewController?
    
    func loadTimelineData () {
        foodDiaryEntryArray.removeAll(keepingCapacity: false)
        
        let getTimelineData:PFQuery = PFQuery(className:"FoodDiaryEntries")
        
        /*Timeline query restraints:
        1.) Only grab non-archived images (diary entries)
        2.) Order by time of entry (most recent first)
        3.) Limit to only 20 results to improve performance
        */
        
        getTimelineData.whereKey("isVisible", equalTo: true)
        getTimelineData.whereKey("userId", equalTo: PFUser.current()!)
        getTimelineData.order(byDescending: "timestamp")
        getTimelineData.limit = 20
        
        getTimelineData.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                
                if let objects = objects {
                    for object in objects {
                        let entry = FoodDiaryEntry(fetchedObject: object)
                        self.foodDiaryEntryArray.append(entry)
                    }
                    self.delegate!.meals = self.foodDiaryEntryArray
                    self.delegate!.tableView.reloadData()
                    
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.localizedDescription)")
            }
            
        }
    }
   }

