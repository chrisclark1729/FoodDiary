//
//  MealIngredients.swift
//  FoodDiary
//
//  Created by Chris Clark on 12/1/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import UIKit
import Parse

class MealIngredients: BaseEntity {
    func getMealId() -> Meal {
        var mealId = self.entity["mealId"] as! PFObject
        var meal = Meal(entity: mealId)
        
        return meal
    }

}
