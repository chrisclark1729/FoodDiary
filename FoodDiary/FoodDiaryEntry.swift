//
//  FoodDiaryEntry.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/4/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit

class FoodDiaryEntry: NSObject {
    
    var mealName:String
    var timestamp:Double
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
    init(mealName:String,timestamp:Double,dayPart:String,location:String,ingredients:String,imgURL:String,calories:Int,gramsCarbs:Int,gramsProtein:Int,gramsFat:Int,enjoymentScore:Int,healthScore:Int,mood:String,energyLevel:Int,otherPeople:String,notes:String ) {
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

let eggsAndBaconAndOatmeal = FoodDiaryEntry(mealName: "Eggs & Bacon & Oatmeal", timestamp:1433250941, dayPart:"Morning", location:"Home", ingredients: "3 eggs, 3 pieces bacon, 1 tbsp grapeseed oil, 1/2 cup oatmeal", imgURL:"https://s3-us-west-1.amazonaws.com/trust-buds/meal-photos/chris-clark/IMG_20150607_101616.jpg", calories:675, gramsCarbs:2, gramsProtein:36, gramsFat:35, enjoymentScore:5, healthScore:4, mood:"Relaxed", energyLevel:3, otherPeople:"", notes:"")


let toast = FoodDiaryEntry(mealName: "Toast & Coffee", timestamp:1430674241, dayPart:"Late Morning", location:"The Mill", ingredients: "Toast, Butter, Jam, Coffee", imgURL:"https://s3-us-west-1.amazonaws.com/trust-buds/meal-photos/chris-clark/the-mill-10.jpg", calories:375, gramsCarbs:80, gramsProtein:8, gramsFat:3, enjoymentScore:4, healthScore:1, mood:"Anxious", energyLevel:4, otherPeople:"Alex", notes:"Could have skipped toast and just enjoyed time with Alex instead.")

