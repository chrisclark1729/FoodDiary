//
//  OtherDinersSummary.swift
//  FoodDiary
//
//  Created by Chris Clark on 2/3/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import Foundation

class OtherDinersSummary {
    var dinerName: String
    var mealCount: Int
    var entryCount: Int
    var dinerTotalCalories: Float
    var caloriesPerMeal: Float
    var percentTotalCalories: Float?
    var enjoymentScore: Float
    var healthScore: Float
    var lastTimestamp: NSDate
    var attentionScore: Float?
    
    init(entries: [FoodDiaryEntry], dinerName: String) {
        self.dinerName = dinerName
        self.mealCount = 1
        self.entryCount = 1
        self.dinerTotalCalories = 0
        self.caloriesPerMeal = 0
        self.enjoymentScore = 0
        self.healthScore = 0
        self.attentionScore = 0
        self.lastTimestamp = NSDate()
        
        for entry in entries {
            self.dinerTotalCalories += entry.calories
            self.caloriesPerMeal += entry.calories/Float(self.mealCount)
            self.enjoymentScore += entry.enjoymentScore
            self.healthScore += entry.healthScore
            self.lastTimestamp = entry.timestamp
        }
        
        if Session.sharedInstance.currentTotalCalories! == 0 {
            self.percentTotalCalories = 0
        } else {
            self.percentTotalCalories = self.dinerTotalCalories/Session.sharedInstance.currentTotalCalories!
        }
    }
}
