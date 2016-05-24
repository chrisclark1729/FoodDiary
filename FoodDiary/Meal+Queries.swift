//
//  Meal+Queries.swift
//  FoodDiary
//
//  Created by Chris Clark on 12/1/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import Foundation
//import Parse

extension Meal {
    
    static func getAllMealsInLocation(geoPoint: PFGeoPoint, dayPart: String) -> [Meal] {
        
        let nearbyMeals:PFQuery = PFQuery(className:"Meal")
        nearbyMeals.whereKey("location", nearGeoPoint: geoPoint, withinMiles: 0.1)
        nearbyMeals.whereKey("isVerified", equalTo: true)
        nearbyMeals.whereKey("dayPart", equalTo: dayPart)
        nearbyMeals.orderByDescending("count")
        nearbyMeals.limit = 15
        
        let fetchedObjects = nearbyMeals.findObjects()
        var entries = [Meal]()
        for fetchedObject in fetchedObjects! {
            let entry = Meal(entity: fetchedObject as! PFObject)
            entries.append(entry)
        }
        
        return entries
    }
    
    static func searchMeals(searchText: String? = nil) -> [Meal] {
        let query = PFQuery(className: "Meal")
        query.whereKey("mealName", containsString: searchText)
        query.limit = 20
        query.orderByDescending("mealName")
        
        let fetchedObjects = query.findObjects()
        
        var entries = [Meal]()
        for fetchedObject in fetchedObjects! {
            let entry = Meal(entity: fetchedObject as! PFObject)
            entries.append(entry)
        }

        return entries
        
        }

    
    
    static func saveFoodDiaryEntryToMeals() {
        
    }
}
