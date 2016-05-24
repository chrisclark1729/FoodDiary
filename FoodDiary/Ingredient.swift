//
//  Ingredient.swift
//  FoodDiary
//
//  Created by Chris Clark on 8/24/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
//import Parse

class Ingredient: AnyObject {
    
    var ingredientId: PFObject?
    var entry: FoodDiaryEntry? //Does this make sense? Why does an ingredient need a FoodDiaryEntry??
    var name: String?
    var category: String?
    var calories: Float?
    var gramsFat: Float?
    var gramsProtein: Float?
    var gramsCarbs: Float?
    var gramsFiber: Float?
    var quantity: Float?
    
    init(){
    }
    
    init(entry: FoodDiaryEntry, entity: PFObject) {
        self.name = entity["ingredientName"] as? String
        self.category = entity["ingredientCategory"] as? String
        self.calories = entity["calories"] as? Float
        self.gramsFat = entity["gramsFat"] as? Float
        self.gramsProtein = entity["gramsProtein"] as? Float
        self.gramsCarbs = entity["gramsCarbs"] as? Float
        self.gramsFiber = entity["gramsFiber"] as? Float
        self.entry = entry
    }
    
    init(ingredientId: PFObject, entry: FoodDiaryEntry, name: String? = "nil", calories: Float, gramsFat: Float,
        gramsProtein: Float, gramsCarbs: Float, gramsFiber: Float, quantity: Float) {
        
        self.ingredientId = ingredientId
        self.name = name
        self.entry = entry
        self.calories = calories
        self.gramsFat = gramsFat
        self.gramsProtein = gramsProtein
        self.gramsCarbs = gramsCarbs
        self.gramsFiber = gramsFiber
        self.quantity = quantity

    }
   
}
