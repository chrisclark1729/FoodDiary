//
//  IngredientAddTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 9/13/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
import Parse

class IngredientAddTableViewController: UITableViewController {
    
    var foodDiaryEntry: FoodDiaryEntry?
    var ingredient: PFObject?
    var foodDiaryDetail = [FoodDiaryDetail]()
    
    @IBOutlet weak var numberOfServingsTextField: UITextField!

    @IBAction func addIngredientButtonTapped(sender: AnyObject) {
        
        let ingredient = Ingredient()
        ingredient.ingredientId = self.ingredient
        ingredient.quantity = (self.numberOfServingsTextField.text)!.floatValue
        self.foodDiaryEntry?.ingredients.append(ingredient)
        
     /*
        var foodDiaryDetail = FoodDiaryDetail(ingredientId:self.ingredient,entry: self.foodDiaryEntry!, quantity: ingredient.quantity)
*/
        
        let foodDiaryDetail = PFObject(className:"FoodDiaryDetail")
        foodDiaryDetail["foodDiaryEntryId"] = foodDiaryEntry?.toPFObject
        foodDiaryDetail["ingredientId"] = ingredient.ingredientId
        foodDiaryDetail["numberOfServings"] = ingredient.quantity
        
        foodDiaryDetail.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
}
