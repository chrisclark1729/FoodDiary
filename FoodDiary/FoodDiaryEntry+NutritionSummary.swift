//
//  FoodDiaryEntry+NutritionSummary.swift
//  FoodDiary
//
//  Created by Chris Clark on 1/5/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import Foundation
import Parse


extension FoodDiaryEntry {
    
    static func fetchFoodDiaryPFObjectsForSummary(startDate:NSDate, endDate:NSDate) -> [PFObject] {
        let summaryFoodDiaryEntries:PFQuery = PFQuery(className:"FoodDiaryEntries")
        summaryFoodDiaryEntries.whereKey("userId", equalTo: PFUser.currentUser()!)
        summaryFoodDiaryEntries.whereKey("timestamp", greaterThanOrEqualTo: startDate)
        summaryFoodDiaryEntries.whereKey("timestamp", lessThanOrEqualTo: endDate)
        summaryFoodDiaryEntries.orderByAscending("timestamp")
        summaryFoodDiaryEntries.limit = 1000
    
        let entries = summaryFoodDiaryEntries.findObjects() as! [PFObject]
    
        return entries
    
    }
    
    static func fetchFoodDiaryEntriesForSummary(startDate:NSDate, endDate:NSDate) -> [FoodDiaryEntry] {
        let entryObjects = fetchFoodDiaryPFObjectsForSummary(startDate, endDate: endDate)
        var foodDiaryEntries = [FoodDiaryEntry]()
        for entry in entryObjects {
            let foodDiaryEntry = FoodDiaryEntry(fetchedObject: entry)
            foodDiaryEntries.append(foodDiaryEntry)
        }
        
        return foodDiaryEntries
    }
    
    


    
}