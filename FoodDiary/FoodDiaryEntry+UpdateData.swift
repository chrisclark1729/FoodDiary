//
//  FoodDiaryEntry+UpdateData.swift
//  FoodDiary
//
//  Created by Chris Clark on 7/14/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import Foundation
import UIKit
import Parse

extension FoodDiaryEntry {
    
    func save() {
        var query = PFQuery(className:"FoodDiaryEntries")
        query.getObjectInBackgroundWithId(self.mealID) {
            (FoodDiaryEntry: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let entry = FoodDiaryEntry {
                entry["mealName"] = self.mealName
                entry["locationName"] = self.locationName
                entry["timestamp"] = self.timestamp
                entry["locationName"] = self.locationName
                entry["ingredients"] = self.ingredients
                entry["calories"] = self.calories
                entry["gramsFat"] = self.gramsFat
                entry["gramsCarbs"] = self.gramsCarbs
                entry["gramsProtein"] = self.gramsProtein
                entry["gramsFiber"] = self.gramsFiber
                entry["enjoymentScore"] = self.enjoymentScore
                entry["healthScore"] = self.healthScore
                entry["mood"] = self.mood
                entry["energyLevel"] = self.energyLevel
                entry["otherPeople"] = self.otherPeople
                entry["notes"] = self.notes
                entry["timezone"] = self.timezone
                entry["isVisible"] = self.isVisible
                
                entry.saveInBackground()
                entry.fetch()
            }
        }
    }
    

}