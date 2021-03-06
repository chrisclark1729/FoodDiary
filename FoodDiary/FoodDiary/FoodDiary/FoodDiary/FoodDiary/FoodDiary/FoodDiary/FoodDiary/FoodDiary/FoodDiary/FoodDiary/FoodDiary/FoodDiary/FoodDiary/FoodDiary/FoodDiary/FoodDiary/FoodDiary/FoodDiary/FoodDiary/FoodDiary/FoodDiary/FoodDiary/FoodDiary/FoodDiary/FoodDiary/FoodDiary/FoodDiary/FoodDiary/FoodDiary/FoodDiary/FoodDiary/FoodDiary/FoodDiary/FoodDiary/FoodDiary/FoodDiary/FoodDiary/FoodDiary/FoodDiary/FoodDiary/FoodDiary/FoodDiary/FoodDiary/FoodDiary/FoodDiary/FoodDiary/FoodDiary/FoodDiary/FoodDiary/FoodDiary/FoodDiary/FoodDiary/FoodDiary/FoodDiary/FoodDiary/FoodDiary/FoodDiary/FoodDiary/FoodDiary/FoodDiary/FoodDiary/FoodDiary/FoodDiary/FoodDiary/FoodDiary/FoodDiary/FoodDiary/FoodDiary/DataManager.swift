//
//  DataManager.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/7/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import Foundation

class DataManager {
    
    
    let eggsAndBaconAndOatmeal = FoodDiaryEntry(mealName: "Eggs & Bacon & Oatmeal", timestamp:1433250941, dayPart:"Morning", location:"Home", ingredients: "3 eggs, 3 pieces bacon, 1 tbsp grapeseed oil, 1/2 cup oatmeal", imgURL:"https://s3-us-west-1.amazonaws.com/trust-buds/meal-photos/chris-clark/IMG_20150607_101616.jpg", calories:675, gramsCarbs:2, gramsProtein:36, gramsFat:35, enjoymentScore:5, healthScore:4, mood:"Relaxed", energyLevel:3, otherPeople:"", notes:"")
    
    
    let toast = FoodDiaryEntry(mealName: "Toast & Coffee", timestamp:1430674241, dayPart:"Late Morning", location:"The Mill", ingredients: "Toast, Butter, Jam, Coffee", imgURL:"https://s3-us-west-1.amazonaws.com/trust-buds/meal-photos/chris-clark/the-mill-10.jpg", calories:375, gramsCarbs:80, gramsProtein:8, gramsFat:3, enjoymentScore:4, healthScore:1, mood:"Anxious", energyLevel:4, otherPeople:"Alex", notes:"Could have skipped toast and just enjoyed time with Alex instead.")
    
    func getFoodDiaryEntries() ->[FoodDiaryEntry] {
        
        var foodDiaryEntryArray = [FoodDiaryEntry]()
        
        foodDiaryEntryArray.append(eggsAndBaconAndOatmeal)
        foodDiaryEntryArray.append(toast)
        
        return foodDiaryEntryArray
    }
    
}
