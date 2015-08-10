//
//  OtherDiners.swift
//  FoodDiary
//
//  Created by Chris Clark on 8/10/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
import Parse

class OtherDiners: NSObject {
    
    var name: String?
    var dinerId: PFUser
    var mealId: PFObject
    
    init(name: String? = "nil", dinerId: PFUser? = PFUser.currentUser(), mealId: PFObject) {
        self.name = name
        self.dinerId = dinerId!
        self.mealId = mealId
        super.init()
    }
    
   
}
