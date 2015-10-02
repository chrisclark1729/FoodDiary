//
//  FoodDiaryDetail.swift
//  FoodDiary
//
//  Created by Chris Clark on 9/13/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import Parse

class FoodDiaryDetail: NSObject {
   
    var ingredientId: PFObject?
    var entry: FoodDiaryEntry?
    var quantity: Float?
}
