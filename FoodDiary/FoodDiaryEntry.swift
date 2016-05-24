//
//  FoodDiaryEntry.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/4/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
//import Parse

class FoodDiaryEntry: NSObject {
    
    var mealID:String
    var mealName:String
    var timestamp:NSDate
    var locationName:String
    var imgURL:AnyObject?
    var calories:Float
    var gramsCarbs:Float
    var gramsProtein:Float
    var gramsFat:Float
    var gramsFiber:Float
    var gramsSaturatedFat:Float
    var enjoymentScore:Float
    var healthScore:Float
    var mood:String
    var energyLevel:Float
    var timezone:String
    var isVisible:Bool
    var userId:PFUser
    var location:PFGeoPoint
    var diners = [OtherDiner]()
    var notes = [Note]()
    var ingredients = [Ingredient]()
    var ingredientDetails = [FoodDiaryDetail]()
    var toPFObject: PFObject?

    init(mealID:String,mealName:String,timestamp:NSDate,locationName:String,imgURL:AnyObject?,calories:Float,gramsCarbs:Float,gramsProtein:Float,gramsFat:Float,gramsFiber:Float,gramsSaturatedFat:Float,enjoymentScore:Float,healthScore:Float,mood:String,energyLevel:Float, timezone:String,isVisible:Bool,userId:PFUser,location:PFGeoPoint) {
        self.mealID=mealID
        self.mealName=mealName
        self.timestamp=timestamp
        self.locationName=locationName
        self.imgURL=imgURL
        self.calories=calories
        self.gramsCarbs=gramsCarbs
        self.gramsProtein=gramsProtein
        self.gramsFat=gramsFat
        self.gramsFiber=gramsFiber
        self.gramsSaturatedFat=gramsSaturatedFat
        self.enjoymentScore=enjoymentScore
        self.healthScore=healthScore
        self.mood=mood
        self.energyLevel=energyLevel
        self.timezone=timezone
        self.isVisible=isVisible
        self.userId=userId
        self.location=location

    }
    
    init(fetchedObject: PFObject){
        self.mealID=fetchedObject.objectId!
        self.mealName=fetchedObject["mealName"] as! String
        self.timestamp=fetchedObject["timestamp"] as! NSDate
        self.locationName=fetchedObject["locationName"] as! String
        self.imgURL=fetchedObject["imageFile"]
        self.calories=fetchedObject["calories"] as! Float
        self.gramsCarbs=fetchedObject["gramsCarbs"] as! Float
        self.gramsProtein=fetchedObject["gramsProtein"] as! Float
        self.gramsFat=fetchedObject["gramsFat"] as! Float
        self.gramsFiber=fetchedObject["gramsFiber"] as! Float
        self.gramsSaturatedFat=fetchedObject["gramsSaturatedFat"] as! Float
        self.enjoymentScore=fetchedObject["enjoymentScore"] as! Float
        self.healthScore=fetchedObject["healthScore"] as! Float
        self.mood=fetchedObject["mood"] as! String
        self.energyLevel=fetchedObject["energyLevel"] as! Float
        self.timezone=fetchedObject["timezone"] as! String
        self.isVisible=fetchedObject["isVisible"] as! Bool
        self.userId=fetchedObject["userId"] as! PFUser
        self.location=fetchedObject["location"] as! PFGeoPoint
        self.toPFObject = fetchedObject
        
    }
    
    func addDiner(diner: OtherDiner) {
        
        self.diners.append(diner)
    }
    
    func addNote(note: Note) {
        
        self.notes.append(note)
    }
    
    func addIngredient(ingredient: Ingredient) {
        self.ingredients.append(ingredient)
    }
    
    func mealScore() ->NSString {
        
        /*Meal "Score" is a combination of how healthy the meal is and how much the user enjoyed the meal.
        The philosophy is that the healthiest life is eating healthy food that you also enjoy. */
        
        let mealScore = NSString(format: "%.1f",(self.healthScore*16)+(self.enjoymentScore*4))
        
        return mealScore
    }
    
    func dayPart() -> (String) {
        
        //TODO: Base Day part on user preferences
        let date = self.timestamp
       // let calendar = NSCalendar.currentCalendar()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timeOfDay = timeFormatter.stringFromDate(date)

        var dayPart = ""
        /*
        Morning: 4 - 8:59 am
        Late Morning: 9 - 11:59 am
        Afternoon: 12 - 4:59pm
        Evening: 5 - 8:59pm
        Night: 9:00pm - 11:59 pm
        Late Night: 12am - 3:59am
        */
        
        switch(timeOfDay)
        {
            case "04:00"..."08:59":
                dayPart = "morning"
            case "09:00"..."11:59":
                dayPart = "late morning"
            case "12:00"..."16:59":
                dayPart = "afternoon"
            case "17:00"..."20:59":
                dayPart = "evening"
            case "21:00"..."23:59":
                dayPart = "night"
            case "00:00"..."4:00":
                dayPart = "late night"
            default: dayPart = "Not set"
        }
        
        return dayPart

    }
   
}

// macros calculator 1g Protein = 4.2 calories, 1g Carbohydrate = 5.7 calories, 1g Fat = 9.4 calories






