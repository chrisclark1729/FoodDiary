//
//  FoodDiaryEntry+MealUpdateData.swift
//  FoodDiary
//
//  Created by Chris Clark on 12/7/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import Foundation
import Parse

extension FoodDiaryEntry {
    
    func isMealExisting() -> (Bool) {
        
        let mealCheck:PFQuery = PFQuery(className:"Meal")
        mealCheck.whereKey("location", nearGeoPoint: self.location, withinMiles: 0.08)
        mealCheck.whereKey("mealName", equalTo: self.mealName)
        mealCheck.whereKey("dayPart", equalTo: self.dayPart())
        let fetchedMeal = mealCheck.getFirstObject()
        
        if (fetchedMeal != nil) {
            fetchedMeal?.incrementKey("count")
            fetchedMeal?.saveInBackground()
            return (true)
        } else {
           
            return (false)
        }
        
    }
    
    func createMealFromFoodDiaryEntry() {
        if self.isMealExisting() {
            print("Meal Already Exists.")
        } else {
            let meal = PFObject.createMealPFObject()
            
            //***Option to make meals for a specific user***
            // meal["userId"] = PFUser.currentUser()
            
            meal["mealName"] = self.mealName
            meal["location"] = self.location
            meal["dayPart"] = self.dayPart()
            meal["isGeneric"] = false
            meal.saveInBackground()
            self.createMealIngredientsFromFoodDiaryDetails(meal)
        }
    }
    
    func createMealIngredientsFromFoodDiaryDetails(meal: PFObject) {

        for ingredient in self.ingredientDetails {
            let mealIngredient = PFObject(className:"MealIngredients")
            mealIngredient["ingredientId"] = ingredient.ingredientId
            mealIngredient["mealId"] = meal
            mealIngredient["numberOfServings"] = ingredient.quantity
            mealIngredient.save()
        }
       
    }
}
