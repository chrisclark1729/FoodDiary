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

            if error != nil {
                print(error)
            } else if let entry = FoodDiaryEntry {
                entry.populateWithFoodDiaryEntry(self)
                entry["userID"] = PFUser.currentUser()
                
                entry.saveInBackground()
                
                self.deleteAllDiners()
                self.writeDinersToBackend()
                self.deleteAllNotes()
                self.writeNotesToBackend()
                
                entry.fetch()
            }
        }
    }
    
//MARK: Diners
    
    func deleteAllDiners() {
        let fetchedDiners = self.getDiners()
        
        for diner in fetchedDiners {
            diner.delete()
        }
    }
    
    func writeDinersToBackend() {
        for diner in self.diners {
            let foodDiaryEntryDiner:PFObject = PFObject(className:"FoodDiaryEntryDiners")
            
            foodDiaryEntryDiner["dinerName"] = diner.name
            foodDiaryEntryDiner["foodDiaryEntryId"] = self.toPFObject
            
            foodDiaryEntryDiner.save()
            
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
    
//MARK: Notes
    
    func deleteAllNotes() {
        let fetchedNotes = self.getNotes()
        
        for note in fetchedNotes {
            note.delete()
        }
        
    }
    
    func writeNotesToBackend() {
        for note in self.notes {
            let foodDiaryEntryTag:PFObject = PFObject(className:"FoodDiaryTags")
            
            foodDiaryEntryTag["foodDiaryTag"] = note.note
            foodDiaryEntryTag["foodDiaryEntryId"] = self.toPFObject
            
            foodDiaryEntryTag.save()
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
                        
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }
                self.notes = notesArray
            }
        }
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
        
        
        var totalCalories: Float = 0
        var totalGramsFat: Float = 0
        var totalGramsProtein: Float = 0
        var totalGramsCarbs: Float = 0
        var totalGramsFiber: Float = 0
        var totalGramsSaturatedFat: Float = 0
        var ingredientCount: Int = 0
        
        let fetchedDetails = self.fetchFoodDiaryDetails()
        
        if let details = fetchedDetails {
            for detail in details {
                
                print("Successfully retrieved \(detail.count) food diary detail rows.")
                
                let ingredient = self.getIngredientsAsPFObjectFromFoodDiaryDetail(detail as! PFObject)
                let ingredientTotalCalories = self.getTotalCaloriesForIngredient(detail as! PFObject, ingredient: ingredient)
                totalCalories += ingredientTotalCalories.0
                totalGramsFat += ingredientTotalCalories.1
                totalGramsProtein += ingredientTotalCalories.2
                totalGramsCarbs += ingredientTotalCalories.3
                totalGramsFiber += ingredientTotalCalories.4
                totalGramsSaturatedFat += ingredientTotalCalories.5
                ingredientCount += 1
                
            }
            self.calories = totalCalories
            self.gramsFat = totalGramsFat
            self.gramsProtein = totalGramsProtein
            self.gramsCarbs = totalGramsCarbs
            self.gramsFiber = totalGramsFiber
            self.gramsSaturatedFat = totalGramsSaturatedFat
            
        }
        return ingredientCount
    }
    
    func fetchFoodDiaryDetails() -> [AnyObject]? {
        // get from Backend and populate array
        let foodDiaryDetails:PFQuery = PFQuery(className:"FoodDiaryDetail")
        foodDiaryDetails.whereKey("foodDiaryEntryId", equalTo: self.toPFObject!)
        let fetchedDetails = foodDiaryDetails.findObjects()
        
        return fetchedDetails
    }
    
    func deleteAllFoodDiaryDetails() {
        let details = self.fetchFoodDiaryDetails()
        
        for detail in details! {
            detail.delete()
        }
    }
    
    func deleteFoodDiaryDetail(foodDiaryDetail: FoodDiaryDetail) {
        let details = self.fetchFoodDiaryDetails()
      //  let detailObjectId = foodDiaryDetail.objectId
        
        for detail in details! {
            let fetchedObjectId = detail.objectId
            if foodDiaryDetail.objectId == fetchedObjectId {
                detail.delete()
            }

        }

    }
    
    func populateIngredientDetails() {
        self.ingredientDetails = []
        let fetchedDetails = self.fetchFoodDiaryDetails()
        if let details = fetchedDetails {
            for detail in details {
                let foodDiaryDetail = FoodDiaryDetail(entry: self, entity: detail as! PFObject)
                self.ingredientDetails.append(foodDiaryDetail)
                
            }
        }
    }
    
    func hasIngredients() -> Bool {
        if self.ingredientDetails.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func deleteIngredientFromFoodDiaryDetail(ingredientForDeletion: PFObject) {
        ingredientForDeletion.deleteInBackground()
    }
    
    func addFoodDiaryDetailFromMealIngredients(mealIngredients: [MealIngredients]) {
        
        for mealIngredient in mealIngredients {
            let foodDiaryDetail = PFObject(className:"FoodDiaryDetail")
            foodDiaryDetail["foodDiaryEntryId"] = self.toPFObject
            foodDiaryDetail["ingredientId"] = mealIngredient.getIngredientId()
            foodDiaryDetail["numberOfServings"] = mealIngredient.getNumberOfServings()
            
            foodDiaryDetail.save()
            
        }
        

    }
    
    func archiveMeal() {
        self.isVisible = false
        self.toPFObject!["isVisible"] = false
        self.toPFObject!.save()
        
    }
    
}
