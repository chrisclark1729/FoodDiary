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
    
    static func getAllMealsInLocation(_ geoPoint: PFGeoPoint, dayPart: String) -> [Meal] {
        
        let nearbyMeals:PFQuery = PFQuery(className:"Meal")
        nearbyMeals.whereKey("location", nearGeoPoint: geoPoint, withinMiles: 0.1)
        nearbyMeals.whereKey("isVerified", equalTo: true)
        nearbyMeals.whereKey("dayPart", equalTo: dayPart)
        nearbyMeals.order(byDescending: "count")
        nearbyMeals.limit = 15
        
        do {
            let fetchedObjects = try nearbyMeals.findObjects()
            var entries = [Meal]()
            for fetchedObject in fetchedObjects {
                let entry = Meal(entity: fetchedObject)
                entries.append(entry)
            }
            return entries
        }
        catch {
            print("Unexpected Error in getAllMealsInLocation")
        }
        
        return [Meal]()
    }
    
    static func searchMeals(_ searchText: String? = nil) -> [Meal] {
        let query = PFQuery(className: "Meal")
        query.whereKey("mealName", contains: searchText)
        query.limit = 20
        query.order(byDescending: "mealName")
        do {
            let fetchedObjects = try query.findObjects()
            var entries = [Meal]()
            for fetchedObject in fetchedObjects {
                let entry = Meal(entity: fetchedObject)
                entries.append(entry)
            }
            return entries
        } catch {
            print("Unexpected error when calling searchMeals")
        }
        return [Meal]()
    }
    
}
