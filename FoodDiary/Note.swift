//
//  Note.swift
//  FoodDiary
//
//  Created by Chris Clark on 8/15/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
import Parse

class Note: NSObject {
   
    var note: String?
    var entry: FoodDiaryEntry?
    
    init(entry: FoodDiaryEntry, note: String? = "nil") {
        self.note = note
        self.entry = entry
        super.init()
    }

}
