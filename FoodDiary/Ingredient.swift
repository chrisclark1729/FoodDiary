//
//  Ingredient.swift
//  FoodDiary
//
//  Created by Chris Clark on 8/24/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
import Parse

class Ingredient: AnyObject {
    
    var ingredientId: PFObject?
    var entry: FoodDiaryEntry? //Does this make sense? Why does an ingredient need a FoodDiaryEntry??
    var name: String?
    var calories: Float?
    var gramsFat: Float?
    var gramsProtein: Float?
    var gramsCarbs: Float?
    var gramsFiber: Float?
    var quantity: Float?
   
}
