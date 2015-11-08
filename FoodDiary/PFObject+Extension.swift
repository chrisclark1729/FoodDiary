//
//  PFObject+Extension.swift
//  FoodDiary
//
//  Created by Chris Clark on 11/8/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import Foundation
import Parse

//Pass a food diary entry object and this populates the properties

extension PFObject {
    func populateWithFoodDiaryEntry(entry:FoodDiaryEntry) {
        self["mealName"] = entry.mealName
        self["locationName"] = entry.locationName
        self["timestamp"] = entry.timestamp
        self["locationName"] = entry.locationName
        self["calories"] = entry.calories
        self["gramsFat"] = entry.gramsFat
        self["gramsCarbs"] = entry.gramsCarbs
        self["gramsProtein"] = entry.gramsProtein
        self["gramsFiber"] = entry.gramsFiber
        self["gramsSaturatedFat"] = entry.gramsSaturatedFat
        self["enjoymentScore"] = entry.enjoymentScore
        self["healthScore"] = entry.healthScore
        self["mood"] = entry.mood
        self["energyLevel"] = entry.energyLevel
        self["timezone"] = entry.timezone
        self["isVisible"] = entry.isVisible
        // WARNING: Do **NOT** Update Location during editing. This will overwrite geoLocation Data.
    }
}