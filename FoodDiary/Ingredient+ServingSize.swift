//
//  Ingredient+ServingSize.swift
//  FoodDiary
//
//  Created by Chris Clark on 3/14/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import Foundation
//import Parse

extension PFObject {
    
    func getServingSize() -> [PFObject] {
        let getServingSizes:PFQuery = PFQuery(className:"IngredientServingSizeOptions")
        getServingSizes.whereKey("ingredientId", equalTo: self)
        getServingSizes.order(byDescending: "unitOfMeasurement")
        getServingSizes.limit = 15
        
        do {
           let servingSizes = try getServingSizes.findObjects()
            return servingSizes
        } catch let error as NSError {
            print(error.localizedDescription)
        }

        return [PFObject]()

    }
}
