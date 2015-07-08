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
    
    var timelineFoodDiaryData:NSMutableArray! = NSMutableArray()
    
    var delegate:TimelineTableViewController?
    
    func loadTimelineData () {
        timelineFoodDiaryData.removeAllObjects()
        
        var getTimelineData:PFQuery = PFQuery(className:"FoodDiaryEntries")
        
        getTimelineData.orderByDescending("timestamp")
        getTimelineData.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                
            var foodDiaryEntryArray = [FoodDiaryEntry]()
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        println(object.objectId)
                        println(object["mood"])
                        println(object["calories"])
                        var entry = FoodDiaryEntry(mealID: object.objectId!,
                            mealName: object["mealName"] as! String,
                            timestamp: object["timestamp"] as! NSDate,
                            locationName: object["locationName"] as! String,
                            ingredients: "To fix",
                            imgURL: object["imageFile"],
                            calories: object["calories"] as! Int,
                            gramsCarbs: object["gramsCarbs"] as! Int,
                            gramsProtein: object["gramsProtein"] as! Int,
                            gramsFat: object["gramsFat"] as! Int,
                            enjoymentScore: object["enjoymentScore"] as! Int,
                            healthScore: object["healthScore"] as! Int,
                            mood: object["mood"] as! String,
                            energyLevel: object["energyLevel"] as! Int,
                            otherPeople: object["otherDiners"] as! String,
                            notes: object["Notes"] as! String,
                            timezone: object["timezone"] as! String)
                        
                        foodDiaryEntryArray.append(entry)
                    
                    }
                self.delegate!.meals = foodDiaryEntryArray
                self.delegate!.tableView.reloadData()
                    
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }

            
             
    }

    }
    
    
    /*
    let eggsAndBaconAndOatmeal = FoodDiaryEntry(mealID: 1, mealName: "Eggs & Bacon & Oatmeal", timestamp:"2015-06-06 09:28:00", location:"Home", ingredients: "3 eggs, 3 pieces bacon, 1 tbsp grapeseed oil, 1/2 cup oatmeal", imgURL:"https://s3-us-west-1.amazonaws.com/trust-buds/meal-photos/chris-clark/IMG_20150607_101616.jpg", calories:675, gramsCarbs:2, gramsProtein:36, gramsFat:35, enjoymentScore:5, healthScore:4, mood:"Relaxed", energyLevel:3, otherPeople:"", notes:"")
    
    
    let toast = FoodDiaryEntry(mealID: 2, mealName: "Toast & Coffee", timestamp:"2015-06-06 12:28:00", location:"The Mill", ingredients: "Toast, Butter, Jam, Coffee", imgURL:"https://s3-us-west-1.amazonaws.com/trust-buds/meal-photos/chris-clark/the-mill-10.jpg", calories:375, gramsCarbs:80, gramsProtein:8, gramsFat:3, enjoymentScore:4, healthScore:1, mood:"Anxious", energyLevel:4, otherPeople:"Alex", notes:"Could have skipped toast and just enjoyed time with Alex instead.")
    
    let chickenHash = FoodDiaryEntry(mealID: 3, mealName: "Chicken Hash", timestamp:"2015-06-06 19:28:00",  location:"Sprig", ingredients: "Chicken, Sweet Potato, Eggs, Kale", imgURL:"https://s3-us-west-1.amazonaws.com/trust-buds/meal-photos/chris-clark/IMG_20150606_143020.png", calories:570, gramsCarbs:80, gramsProtein:8, gramsFat:3, enjoymentScore:4, healthScore:5, mood:"Happy", energyLevel:4, otherPeople:"Carly", notes:"")

    
    func getFoodDiaryEntries() ->[FoodDiaryEntry] {
        
        var foodDiaryEntryArray = [FoodDiaryEntry]()
        
        foodDiaryEntryArray.append(eggsAndBaconAndOatmeal)
        foodDiaryEntryArray.append(toast)
        foodDiaryEntryArray.append(chickenHash)
        
        return foodDiaryEntryArray
    }
*/

    
}

