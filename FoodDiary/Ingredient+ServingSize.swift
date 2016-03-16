//
//  Ingredient+ServingSize.swift
//  FoodDiary
//
//  Created by Chris Clark on 3/14/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import Foundation
import Parse

extension PFObject {
    
    func getServingSize() -> [PFObject] {
        let getServingSizes:PFQuery = PFQuery(className:"IngredientServingSizeOptions")
        getServingSizes.whereKey("ingredientId", equalTo: self)
        getServingSizes.orderByDescending("unitOfMeasurement")
        getServingSizes.limit = 10
        
        let servingSizes = getServingSizes.findObjects() as! [PFObject]
        
        return servingSizes

    }
}
