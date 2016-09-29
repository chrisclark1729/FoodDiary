//
//  FoodDiaryEntry+NutritionSummary.swift
//  FoodDiary
//
//  Created by Chris Clark on 1/5/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import Foundation
//import Parse


extension FoodDiaryEntry {
    
    static func fetchFoodDiaryPFObjectsForSummary(_ startDate:Date, endDate:Date) -> [PFObject] {
        let summaryFoodDiaryEntries:PFQuery = PFQuery(className:"FoodDiaryEntries")
        summaryFoodDiaryEntries.whereKey("userId", equalTo: PFUser.current()!)
       // summaryFoodDiaryEntries.whereKey("userId", equalTo: "Z66C62Ev7M")
        summaryFoodDiaryEntries.whereKey("timestamp", greaterThanOrEqualTo: startDate)
        summaryFoodDiaryEntries.whereKey("timestamp", lessThanOrEqualTo: endDate)
        summaryFoodDiaryEntries.order(byAscending: "timestamp")
        summaryFoodDiaryEntries.limit = 1000
        
        do {
            let entries = try summaryFoodDiaryEntries.findObjects()
            
            return entries
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return [PFObject]()
    }
    
    static func fetchFoodDiaryEntriesForSummary(_ startDate:Date, endDate:Date) -> [FoodDiaryEntry] {
        let entryObjects = fetchFoodDiaryPFObjectsForSummary(startDate, endDate: endDate)
        var foodDiaryEntries = [FoodDiaryEntry]()
        for entry in entryObjects {
            let foodDiaryEntry = FoodDiaryEntry(fetchedObject: entry)
            foodDiaryEntries.append(foodDiaryEntry)
        }
        
        return foodDiaryEntries
    }
    
    static func populateDiners() {
        
    }
    
    


    
}
