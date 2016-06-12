//
//  DayPartSummary.swift
//  FoodDiary
//
//  Created by Chris Clark on 4/26/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import Foundation

class DayPartSummary: NutritionSummary {
    var dayPart: String
    
     init(entries: [FoodDiaryEntry]) {
        var firstEntry = entries[0]
        var entriesCopy = entries
        entriesCopy.removeFirst()
        
        self.dayPart = entries[0].dayPart()
        super.init(entry: entries[0])
        
        for entry in entriesCopy {
            self.updateDayPartSummary(entry)
        }

    }
    
     func updateDayPartSummary(entry: FoodDiaryEntry) {
        let minutesDifference = NSCalendar.currentCalendar().components(.Minute, fromDate: self.lastTimestamp, toDate: entry.timestamp, options: []).minute
        
        if abs(minutesDifference) < 75 {
            self.entryCount += 1
        } else {
            self.entryCount += 1
            self.mealCount += 1
        }
        
        self.locationTotalCalories += entry.calories
        self.caloriesPerMeal = self.locationTotalCalories/Float(self.mealCount)
        self.enjoymentScore += entry.enjoymentScore
        self.healthScore += entry.healthScore
        self.percentTotalCalories = self.locationTotalCalories/Session.sharedInstance.currentTotalCalories!
        self.lastTimestamp = entry.timestamp
        
    }
    
    
}