//
//  OtherDiners.swift
//  FoodDiary
//
//  Created by Chris Clark on 8/10/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
import Parse

class OtherDiner: NSObject {
    
    var name: String?
    var entry: FoodDiaryEntry?
  
    
    init(entry: FoodDiaryEntry, name: String? = "nil") {
        self.name = name
        self.entry = entry
        super.init()
    }
    
   
}
