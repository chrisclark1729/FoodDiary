//
//  Meal.swift
//  FoodDiary
//
//  Created by Chris Clark on 12/1/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import UIKit
//import Parse

class Meal: BaseEntity {

    func getMealId() -> String {
        return self.entity["mealId"] as! String
    }
    
    func setMealName(name: String) {
        self.entity["mealId"] = name

    }
    
    func getMealName() -> String {
        return self.entity["mealName"] as! String
    }
    
    func getMealIngredients() -> [MealIngredients] {
        var ingredients:[MealIngredients] = []
        
        let fetchedIngredients:PFQuery = PFQuery(className:"MealIngredients")
        fetchedIngredients.whereKey("mealId", equalTo: self.entity)
        do {
            let mealIngredients = try fetchedIngredients.findObjects()
            for ingredient in mealIngredients as [PFObject] {
                let ingredientDetail = MealIngredients(entity:ingredient )
                
                ingredients.append(ingredientDetail)
                
            }
            
            return ingredients
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return [MealIngredients]()
    }
    
}
