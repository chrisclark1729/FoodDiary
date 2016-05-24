//
//  Session.swift
//  FoodDiary
//
//  Created by Chris Clark on 10/24/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import Foundation
//import Parse

class Session {
    static let sharedInstance = Session()
    var currentFoodDiaryEntry: FoodDiaryEntry?
    var currentMeals:[FoodDiaryEntry]?
    var currentSelectedFoodDiaryDetail:FoodDiaryDetail?
    var currentSelectedStartDate:NSDate?
    var currentSelectedEndDate:NSDate?
    var currentTotalCalories:Float?
    var currentMealCount:Int?
    var currentOneToOneDimensionForSummary:String?
    var currentIngredient:PFObject?
    var currentSelectedMeal:Meal?
    
}
