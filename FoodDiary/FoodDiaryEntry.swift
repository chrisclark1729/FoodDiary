//
//  FoodDiaryEntry.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/4/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit

class FoodDiaryEntry: NSObject {
    
    var mealID:Double
    var mealName:String
    var timestamp:String
    var dayPart:String // TODO: make this based on user preferences and derive based on time of day
    var location:String
    var ingredients:String
    var imgURL:String
    var calories:Int
    var gramsCarbs:Int
    var gramsProtein:Int
    var gramsFat:Int
    var enjoymentScore:Int
    var healthScore:Int
    var mood:String
    var energyLevel:Int
    var otherPeople:String
    var notes:String
    init(mealID:Double, mealName:String,timestamp:String,dayPart:String,location:String,ingredients:String,imgURL:String,calories:Int,gramsCarbs:Int,gramsProtein:Int,gramsFat:Int,enjoymentScore:Int,healthScore:Int,mood:String,energyLevel:Int,otherPeople:String,notes:String ) {
        self.mealID=mealID
        self.mealName=mealName
        self.timestamp=timestamp
        self.dayPart=dayPart
        self.location=location
        self.ingredients=ingredients
        self.imgURL=imgURL
        self.calories=calories
        self.gramsCarbs=gramsCarbs
        self.gramsProtein=gramsProtein
        self.gramsFat=gramsFat
        self.enjoymentScore=enjoymentScore
        self.healthScore=healthScore
        self.mood=mood
        self.energyLevel=energyLevel
        self.otherPeople=otherPeople
        self.notes=notes
    }
   
}

// macros calculator 1g Protein = 4 calories, 1g Carbohydrate = 4 calories, 1g Fat = 9 calories



