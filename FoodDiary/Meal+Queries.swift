//
//  Meal+Queries.swift
//  FoodDiary
//
//  Created by Chris Clark on 12/1/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import Foundation
import Parse

extension Meal {
    
    static func getAllMealsInLocation(geoPoint: PFGeoPoint, dayPart: String) -> [Meal] {
        
        let nearbyMeals:PFQuery = PFQuery(className:"Meal")
        nearbyMeals.whereKey("location", nearGeoPoint: geoPoint, withinMiles: 0.1)
        nearbyMeals.whereKey("isVerified", equalTo: true)
        nearbyMeals.whereKey("dayPart", equalTo: dayPart)
        nearbyMeals.orderByDescending("count")
        nearbyMeals.limit = 15
        
        //TODO: Get +/- 3 hours as a condition. Issue is need to extract "time part" only irrespective of day.
        let fetchedObjects = nearbyMeals.findObjects()
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
