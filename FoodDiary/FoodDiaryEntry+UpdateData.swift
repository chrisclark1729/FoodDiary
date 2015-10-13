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
        let query = PFQuery(className:"FoodDiaryEntries")
        query.getObjectInBackgroundWithId(self.mealID) {
            (FoodDiaryEntry: PFObject?, error: NSError?) -> Void in
            //TODO: Fix this logic. It's ugly.
            if error != nil {
                print(error)
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
                entry["gramsSaturatedFat"] = self.gramsSaturatedFat
                entry["enjoymentScore"] = self.enjoymentScore
                entry["healthScore"] = self.healthScore
                entry["mood"] = self.mood
                entry["energyLevel"] = self.energyLevel
                entry["timezone"] = self.timezone
                entry["isVisible"] = self.isVisible
                entry["userID"] = PFUser.currentUser()
                
                // WARNING: Do **NOT** Update Location during editing. This will overwrite geoLocation Data.
                
                entry.saveInBackground()
                
                let fetchedDiners = self.getDiners()
                
                for diner in fetchedDiners {
                    diner.delete()
                }
                
                for diner in self.diners {
                    let foodDiaryEntryDiner:PFObject = PFObject(className:"FoodDiaryEntryDiners")
                    
                    foodDiaryEntryDiner["dinerName"] = diner.name
                    foodDiaryEntryDiner["foodDiaryEntryId"] = FoodDiaryEntry
                    
                    foodDiaryEntryDiner.save()
                    
                }
                
                
                entry.fetch()
            }
            
            let fetchedNotes = self.getNotes()
            
            for note in fetchedNotes {
                note.delete()
            }
            
            for note in self.notes {
                let foodDiaryEntryTag:PFObject = PFObject(className:"FoodDiaryTags")
                
                foodDiaryEntryTag["foodDiaryTag"] = note.note
                foodDiaryEntryTag["foodDiaryEntryId"] = FoodDiaryEntry
                
                foodDiaryEntryTag.save()
            }
            
            for ingredients in self.ingredients {
                print("ingredients print")
                print(ingredients.ingredientId)
            }
            
        }
    }
    
    
    
    func loadData() {
        //  timelineFoodDiaryData.removeAllObjects()
        
        let getTimelineData:PFQuery = PFQuery(className:"FoodDiaryEntries")
        
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
                // print(Successfully retrieved  (objects!.count) scores.")
                // Do something with the found objects
                
                var foodDiaryEntryArray = [FoodDiaryEntry]()
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        // println(object.objectId)
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
                            location: object["geoPoint"] as! PFGeoPoint)
                        
                        foodDiaryEntryArray.append(entry)
                        
                    }
                    
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            
            
        }
    }
    
    func getDiners() -> [PFObject] {
        let getOtherDiners:PFQuery = PFQuery(className:"FoodDiaryEntryDiners")
        
        getOtherDiners.whereKey("foodDiaryEntryId", equalTo: self.toPFObject!)
        getOtherDiners.limit = 30 // Limit query results just in case
        
        let fetchedObjects = getOtherDiners.findObjects()
        var pfObjects = [PFObject]()
        for object in fetchedObjects! {
            if let pfObject = object as? PFObject {
                pfObjects.append(pfObject)
            }
        }
        return pfObjects
        
    }
    
    func populateDiners() {
        let getOtherDiners:PFQuery = PFQuery(className:"FoodDiaryEntryDiners")
        
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
                        print("Successfully retrieved \(objs.count) diners.")
                        let diner = OtherDiner(entry: self, entity: object as! PFObject)
                        otherDinersArray.append(diner)
                        
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }
                self.diners = otherDinersArray
            }
        }
    }
    
    func getNotes() -> [PFObject] {
        let getNotes:PFQuery = PFQuery(className:"FoodDiaryTags")
        
        getNotes.whereKey("foodDiaryEntryId", equalTo: self.toPFObject!)
        getNotes.limit = 30 // Limit query results just in case
        
        let fetchedObjects = getNotes.findObjects()
        var pfObjects = [PFObject]()
        for object in fetchedObjects! {
            if let pfObject = object as? PFObject {
                pfObjects.append(pfObject)
            }
        }
        return pfObjects
        
    }
    
    func populateNotes() {
        let getNotes:PFQuery = PFQuery(className:"FoodDiaryTags")
        
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
                        print("Successfully retrieved \(objs.count) notes.")
                        let note = Note(entry: self, entity: object as! PFObject)
                        notesArray.append(note)
                        print(notesArray)
                        
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }
                self.notes = notesArray
            }
        }
    }
    
    func getIngredientsFromFoodDiaryDetail(detail:PFObject) -> Ingredient {
        let fetchIngredient = self.getIngredientsAsPFObjectFromFoodDiaryDetail(detail)
        let ingredient = Ingredient(entry: self, entity: fetchIngredient)
      //  print(ingredient)
        return ingredient
    }
    
    func getIngredientsAsPFObjectFromFoodDiaryDetail(detail:PFObject) -> PFObject {
        let fetchedIngredient = detail["ingredientId"] as! PFObject
        fetchedIngredient.fetch()
        return fetchedIngredient
    }
    
    func getTotalCaloriesForIngredient(detail:PFObject, ingredient:PFObject) -> (Float, Float, Float, Float, Float, Float) {
        
        var totalCalories:Float = 0
        var totalGramsFat:Float = 0
        var totalGramsProtein:Float = 0
        var totalGramsCarbs:Float = 0
        var totalGramsFiber:Float = 0
        var totalGramsSaturatedFat:Float = 0
        
        let fetchedIngredient = detail["ingredientId"] as! PFObject
        fetchedIngredient.fetch()
        
        let quantity = detail["numberOfServings"] as! Float
        let calories = fetchedIngredient["calories"] as! Float
        let gramsFat = fetchedIngredient["gramsFat"] as! Float
        let gramsProtein = fetchedIngredient["gramsProtein"] as! Float
        let gramsCarbs = fetchedIngredient["gramsCarbs"] as! Float
        let gramsFiber = fetchedIngredient["gramsFiber"] as! Float
        let gramsSaturatedFat = fetchedIngredient["gramsSaturatedFat"] as! Float
        
        totalCalories = (calories * quantity)
        totalGramsFat = (gramsFat * quantity)
        totalGramsProtein = (gramsProtein * quantity)
        totalGramsCarbs = (gramsCarbs * quantity)
        totalGramsFiber = (gramsFiber * quantity)
        totalGramsSaturatedFat = (gramsSaturatedFat * quantity)
        
        return (totalCalories, totalGramsFat, totalGramsProtein, totalGramsCarbs, totalGramsFiber, totalGramsSaturatedFat)
    }
    
    
    
    func populateIngredients() -> Int {
        // get from Backend and populate array
        let foodDiaryDetails:PFQuery = PFQuery(className:"FoodDiaryDetail")
        
        foodDiaryDetails.whereKey("foodDiaryEntryId", equalTo: self.toPFObject!)
        
        var totalCalories: Float = 0
        var totalGramsFat: Float = 0
        var totalGramsProtein: Float = 0
        var totalGramsCarbs: Float = 0
        var totalGramsFiber: Float = 0
        var totalGramsSaturatedFat: Float = 0
        var ingredientCount: Int = 0
        
        foodDiaryDetails.findObjectsInBackgroundWithBlock {
            //TODO: Change variable names to describe foodDiaryDetail objects
            (fetchedDetails: [AnyObject]?, error: NSError?) -> Void in
            
            if let details = fetchedDetails {
                for detail in details {
                    if error == nil {
                        // The find succeeded.
                        print("Successfully retrieved \(detail.count) food diary detail rows.")
                        
                   //     var ingredient = Ingredient(entry: self, entity: object as! PFObject)
                       // ingredientsArray.append(ingredient)
                        let ingredient = self.getIngredientsAsPFObjectFromFoodDiaryDetail(detail as! PFObject)
                      //  ingredientsArray.append(ingredient)
                        let ingredientTotalCalories = self.getTotalCaloriesForIngredient(detail as! PFObject, ingredient: ingredient)
                        totalCalories += ingredientTotalCalories.0
                        totalGramsFat += ingredientTotalCalories.1
                        totalGramsProtein += ingredientTotalCalories.2
                        totalGramsCarbs += ingredientTotalCalories.3
                        totalGramsFiber += ingredientTotalCalories.4
                        totalGramsSaturatedFat += ingredientTotalCalories.5
                        ingredientCount += 1
                        print("ingredient \(ingredientTotalCalories)")
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }
                //self.ingredients = ingredientsArray
                print("end of loop: \(ingredientCount) ingredients at \(totalCalories) calories")
                self.calories = totalCalories
                self.gramsFat = totalGramsFat
                self.gramsProtein = totalGramsProtein
                self.gramsCarbs = totalGramsCarbs
                self.gramsFiber = totalGramsFiber
                self.gramsSaturatedFat = totalGramsSaturatedFat

            }
        }
        print(ingredientCount)
        return ingredientCount
    }
    
    
        
    }
    
    func clearIngredients() {
        // delete all Ingredients related to this foodDiaryEntry
    }
    
    func saveIngredients() {
        
        // build all ingredients and save to backend
        
    }

