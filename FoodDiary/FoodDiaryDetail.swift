//
//  FoodDiaryDetail.swift
//  FoodDiary
//
//  Created by Chris Clark on 9/13/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

//import Parse

class FoodDiaryDetail: NSObject {
    
    var objectId: String
    var foodDiaryEntryId: PFObject?
    var ingredientId: PFObject?
    var entry: FoodDiaryEntry?
    var quantity: Float?
    var toPFObject: PFObject?
    
    init(entry: FoodDiaryEntry, entity: PFObject) {
        self.objectId = entity.objectId!
        self.ingredientId = entity["ingredientId"] as? PFObject
        self.quantity = entity["numberOfServings"] as? Float
        self.foodDiaryEntryId = entity["foodDiaryEntryId"] as? PFObject
        self.toPFObject = entity
    }
    
}
