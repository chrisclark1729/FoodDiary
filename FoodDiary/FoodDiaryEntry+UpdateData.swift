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
            //TODO: Fix this logic. It's ugly.
            if error != nil {
                println(error)
            } else if let entry = FoodDiaryEntry {
                entry["mealName"] = self.mealName
                entry["locationName"] = self.locationName
                entry["timestamp"] = self.timestamp
                entry["locationName"] = self.locationName
                entry["calories"] = self.calories
                entry["gramsFat"] = self.gramsFat
                entry["gramsCarbs"] = self.gramsCarbs
                entry["gramsProtein"] = self.gramsProtein
                entry["gramsFiber"] = self.gramsFiber
                entry["enjoymentScore"] = self.enjoymentScore
                entry["healthScore"] = self.healthScore
                entry["mood"] = self.mood
                entry["energyLevel"] = self.energyLevel
                entry["timezone"] = self.timezone
                entry["isVisible"] = self.isVisible
                entry["userID"] = PFUser.currentUser()
                
                // WARNING: Do **NOT** Update Location during editing. This will overwrite geoLocation Data.
                
                entry.saveInBackground()
                
                
                var fetchedDiners = self.getDiners()
                
                for diner in fetchedDiners {
                    diner.delete()
                }
                
                for diner in self.diners {
                    var foodDiaryEntryDiner:PFObject = PFObject(className:"FoodDiaryEntryDiners")
                    
                    foodDiaryEntryDiner["dinerName"] = diner.name
                    foodDiaryEntryDiner["foodDiaryEntryId"] = FoodDiaryEntry
                    
                    foodDiaryEntryDiner.save()
                    
                }
                
                
                entry.fetch()
            }
            
            var fetchedNotes = self.getNotes()
            
            for note in fetchedNotes {
                note.delete()
            }
            
            for note in self.notes {
                var foodDiaryEntryTag:PFObject = PFObject(className:"FoodDiaryTags")
                
                foodDiaryEntryTag["foodDiaryTag"] = note.note
                foodDiaryEntryTag["foodDiaryEntryId"] = FoodDiaryEntry
                
                foodDiaryEntryTag.save()
            }
            
        }
    }
    
    
    
    func loadData() {
        //  timelineFoodDiaryData.removeAllObjects()
        
        var getTimelineData:PFQuery = PFQuery(className:"FoodDiaryEntries")
        
        /*Timeline query restraints:
        1.) Only grab non-archived images (diary entries)
        2.) Order by time of entry (most recent first)
        3.) Limit to only 25 results to improve performance
        */
        
        getTimelineData.whereKey("isVisible", equalTo: true)
        getTimelineData.orderByDescending("timestamp")
        getTimelineData.limit = 25
        
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
                            imgURL: object["imageFile"],
                            calories: object["calories"] as! Int,
                            gramsCarbs: object["gramsCarbs"] as! Int,
                            gramsProtein: object["gramsProtein"] as! Int,
                            gramsFat: object["gramsFat"] as! Int,
                            gramsFiber: object["gramsFiber"] as! Int,
                            enjoymentScore: object["enjoymentScore"] as! Float,
                            healthScore: object["healthScore"] as! Float,
                            mood: object["mood"] as! String,
                            energyLevel: object["energyLevel"] as! Float,
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
    
    func getDiners() -> [PFObject] {
        var getOtherDiners:PFQuery = PFQuery(className:"FoodDiaryEntryDiners")
        
        getOtherDiners.whereKey("foodDiaryEntryId", equalTo: self.toPFObject!)
        getOtherDiners.limit = 30 // Limit query results just in case
        
        var fetchedObjects = getOtherDiners.findObjects()
        var pfObjects = [PFObject]()
        for object in fetchedObjects! {
            if let pfObject = object as? PFObject {
                pfObjects.append(pfObject)
            }
        }
        return pfObjects
        
    }
    
    func getNotes() -> [PFObject] {
        var getNotes:PFQuery = PFQuery(className:"FoodDiaryTags")
        
        getNotes.whereKey("foodDiaryEntryId", equalTo: self.toPFObject!)
        getNotes.limit = 30 // Limit query results just in case
        
        var fetchedObjects = getNotes.findObjects()
        var pfObjects = [PFObject]()
        for object in fetchedObjects! {
            if let pfObject = object as? PFObject {
                pfObjects.append(pfObject)
            }
        }
        return pfObjects
        
    }
    
    func populateDiners() {
        var getOtherDiners:PFQuery = PFQuery(className:"FoodDiaryEntryDiners")
        
        getOtherDiners.whereKey("foodDiaryEntryId", equalTo: self.toPFObject!)
        getOtherDiners.orderByAscending("dinerName")
        getOtherDiners.limit = 30 // Limit query results just in case
        
        var otherDinersArray = [OtherDiner]()
        
        getOtherDiners.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if let objs = objects {
                for object in objs {
                    if error == nil {
                        // The find succeeded.
                        println("Successfully retrieved \(objs.count) diners.")
                        var diner = OtherDiner(entry: self, entity: object as! PFObject)
                        otherDinersArray.append(diner)
                        println(otherDinersArray)
                        
                    } else {
                        // Log details of the failure
                        println("Error: \(error!) \(error!.userInfo!)")
                    }
                }
                self.diners = otherDinersArray
            }
        }
    }
    
    func populateNotes() {
        var getNotes:PFQuery = PFQuery(className:"FoodDiaryTags")
        
        getNotes.whereKey("foodDiaryEntryId", equalTo: self.toPFObject!)
        getNotes.orderByAscending("dinerName")
        getNotes.limit = 30 // Limit query results just in case
        
        var notesArray = [Note]()
        
        getNotes.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if let objs = objects {
                for object in objs {
                    if error == nil {
                        // The find succeeded.
                        println("Successfully retrieved \(objs.count) notes.")
                        var note = Note(entry: self, entity: object as! PFObject)
                        notesArray.append(note)
                        println(notesArray)
                        
                    } else {
                        // Log details of the failure
                        println("Error: \(error!) \(error!.userInfo!)")
                    }
                }
                self.notes = notesArray
            }
        }
    }
    
    func populateIngredients() {
        // get from Backend and populate array
    }
    
    func clearIngredients() {
        // delete all Ingredients related to this foodDiaryEntry
    }
    
    func saveIngredients() {
        
        // build all ingredients and save to backend
        
    }
}
