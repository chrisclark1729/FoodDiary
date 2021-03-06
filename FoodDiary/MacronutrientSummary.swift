//
//  MacronutrientSummary.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/15/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import Foundation

class MacronutrientSummary {
    var macronutrientCategory: String
    var mealCount: Int
    var entryCount: Int
    var macronutrientCategoryTotalCalories: Float
    var caloriesPerMeal: Float
    var percentTotalCalories: Float?
    var enjoymentScore: Float
    var healthScore: Float
    var lastTimestamp: Date
    var attentionScore: Float?
    
    init(entry: FoodDiaryEntry) {
        self.macronutrientCategory = entry.getMacronutrientCategory()
        self.mealCount = 1
        self.entryCount = 1
        self.macronutrientCategoryTotalCalories = entry.calories
        self.caloriesPerMeal = entry.calories/Float(self.mealCount)
        self.enjoymentScore = entry.enjoymentScore
        self.healthScore = entry.healthScore
        self.lastTimestamp = entry.timestamp as Date
        if Session.sharedInstance.currentTotalCalories! == 0 {
            self.percentTotalCalories = 0
        } else {
            self.percentTotalCalories = self.macronutrientCategoryTotalCalories/Session.sharedInstance.currentTotalCalories!
        }
    }
    
    func updateMacronutrientCategorySummary(_ entry: FoodDiaryEntry) {
        let minutesDifference = (Calendar.current as NSCalendar).components(.minute, from: self.lastTimestamp, to: entry.timestamp as Date, options: []).minute
        
        if abs(minutesDifference!) < 75 {
            self.entryCount += 1
        } else {
            self.entryCount += 1
            self.mealCount += 1
        }
        
        self.macronutrientCategoryTotalCalories += entry.calories
        self.caloriesPerMeal = self.macronutrientCategoryTotalCalories/Float(self.mealCount)
        self.enjoymentScore += entry.enjoymentScore
        self.healthScore += entry.healthScore
        self.percentTotalCalories = self.macronutrientCategoryTotalCalories/Session.sharedInstance.currentTotalCalories!
        self.lastTimestamp = entry.timestamp as Date
        
    }
    
    func calculateAttentionScore(_ maxCaloriesPerMeal: Float, totalMeals: Int) -> Float {
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
    
    func populateAttentionScore(_ maxCaloriesPerMeal: Float, totalMeals: Int) {
        self.attentionScore = self.calculateAttentionScore(maxCaloriesPerMeal, totalMeals: totalMeals)
    }
    
}
