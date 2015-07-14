//
//  FoodDiaryEntry.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/4/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
import Parse

class FoodDiaryEntry: NSObject {
    
    var mealID:String
    var mealName:String
    var timestamp:NSDate
    var locationName:String
    var ingredients:String
    var imgURL:AnyObject?
    var calories:Int
    var gramsCarbs:Int
    var gramsProtein:Int
    var gramsFat:Int
    var gramsFiber:Int
    var enjoymentScore:Int
    var healthScore:Int
    var mood:String
    var energyLevel:Int
    var otherPeople:String
    var notes:String
    var timezone:String
    var isVisible:Bool

    init(mealID:String,mealName:String,timestamp:NSDate,locationName:String,ingredients:String,imgURL:AnyObject?,calories:Int,gramsCarbs:Int,gramsProtein:Int,gramsFat:Int,gramsFiber:Int,enjoymentScore:Int,healthScore:Int,mood:String,energyLevel:Int,otherPeople:String,notes:String, timezone:String,isVisible:Bool) {
        self.mealID=mealID
        self.mealName=mealName
        self.timestamp=timestamp
        self.locationName=locationName
        self.ingredients=ingredients
        self.imgURL=imgURL
        self.calories=calories
        self.gramsCarbs=gramsCarbs
        self.gramsProtein=gramsProtein
        self.gramsFat=gramsFat
        self.gramsFiber=gramsFiber
        self.enjoymentScore=enjoymentScore
        self.healthScore=healthScore
        self.mood=mood
        self.energyLevel=energyLevel
        self.otherPeople=otherPeople
        self.notes=notes
        self.timezone=timezone
        self.isVisible=isVisible

    }
    
    func mealScore() ->Int {
        
        /*Meal "Score" is a combination of how healthy the meal is and how much the user enjoyed the meal.
        The philosophy is that the healthiest life is eating healthy food that you also enjoy.
        Overtime, I'd like this to be much more sophisticated.                           */
        
        let mealScore = (self.healthScore*16)+(self.enjoymentScore*4)
        
        return mealScore
    }
    
    func dayPart() ->NSString {
        
        //TODO: Base Day part on user preferences
        var dayPart = ""
      /*
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var mealTimeDate = dateFormatter.dateFromString(self.timestamp)
        var timeComparisonFormatter = NSDateFormatter()
        timeComparisonFormatter.dateFormat = "H:mm"
     */   
        
        return dayPart
    }
   
}

// macros calculator 1g Protein = 4.2 calories, 1g Carbohydrate = 5.7 calories, 1g Fat = 9.4 calories






