//
//  Session.swift
//  FoodDiary
//
//  Created by Chris Clark on 10/24/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import Foundation

class Session {
    static let sharedInstance = Session()
    var currentFoodDiaryEntry: FoodDiaryEntry?
    var currentMeals:[FoodDiaryEntry]?
}
