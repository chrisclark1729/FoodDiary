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
        self.mealCount = 0
        self.entryCount = 0
        self.dinerTotalCalories = 0
        self.caloriesPerMeal = 0
        self.enjoymentScore = 0
        self.healthScore = 0
        self.attentionScore = 0
        self.lastTimestamp = NSDate()
        
        for entry in entries {
            let minutesDifference = NSCalendar.currentCalendar().components(.Minute, fromDate: self.lastTimestamp, toDate: entry.timestamp, options: []).minute
            
            if abs(minutesDifference) < 75 {
                self.entryCount += 1
            } else {
                self.entryCount += 1
                self.mealCount += 1
            }
            self.dinerTotalCalories += entry.calories
            self.enjoymentScore += entry.enjoymentScore
            self.healthScore += entry.healthScore
            self.lastTimestamp = entry.timestamp
        }
        
        self.caloriesPerMeal += self.dinerTotalCalories/Float(self.mealCount)
        
        if Session.sharedInstance.currentTotalCalories! == 0 {
            self.percentTotalCalories = 0
        } else {
            self.percentTotalCalories = self.dinerTotalCalories/Session.sharedInstance.currentTotalCalories!
        }
    }
    
    func calculateAttentionScore(maxCaloriesPerMeal: Float, totalMeals: Int) -> Float {
        var experienceScores: Float = 0
        var attentionScore:Float = 0
        var compareAgainstTotal:Float = 0
        var enjoymentScoreForCalc:Float = 0
        var healthScoreForCalc:Float = 0
        
        enjoymentScoreForCalc = ((5 - self.enjoymentScore/Float(self.entryCount)) * 0.04)
        healthScoreForCalc = (5 - self.healthScore/Float(self.entryCount))/100
        experienceScores = enjoymentScoreForCalc + healthScoreForCalc
        compareAgainstTotal = ((Float(self.mealCount)/Float(totalMeals)) * 0.1)
        attentionScore = (self.caloriesPerMeal/maxCaloriesPerMeal)*0.4 + self.percentTotalCalories!*0.25 + experienceScores + compareAgainstTotal
        
        return attentionScore
    }
    
    func populateAttentionScore(maxCaloriesPerMeal: Float, totalMeals: Int) {
        self.attentionScore = self.calculateAttentionScore(maxCaloriesPerMeal, totalMeals: totalMeals)
    }
    
}
