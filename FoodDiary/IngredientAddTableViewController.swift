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
        
        self.foodDiaryEntry = Session.sharedInstance.currentFoodDiaryEntry!
        
        let ingredient = Ingredient()
        ingredient.ingredientId = self.ingredient
        ingredient.quantity = (self.numberOfServingsTextField.text)!.floatValue
        
        self.foodDiaryEntry?.ingredients.append(ingredient)
        
        let foodDiaryDetail = PFObject(className:"FoodDiaryDetail")
        foodDiaryDetail["foodDiaryEntryId"] = foodDiaryEntry?.toPFObject
        foodDiaryDetail["ingredientId"] = ingredient.ingredientId
        foodDiaryDetail["numberOfServings"] = ingredient.quantity
        
        foodDiaryDetail.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                let calories = self.ingredient!["calories"] as! Float
                let gramsFat = self.ingredient!["gramsFat"] as! Float
                let gramsProtein = self.ingredient!["gramsProtein"] as! Float
                let gramsCarbs = self.ingredient!["gramsCarbs"] as! Float
                let gramsFiber = self.ingredient!["gramsFiber"] as! Float
                self.foodDiaryEntry!.calories += ingredient.quantity! * calories
                self.foodDiaryEntry!.gramsFat += ingredient.quantity! * gramsFat
                self.foodDiaryEntry!.gramsProtein += ingredient.quantity! * gramsProtein
                self.foodDiaryEntry!.gramsCarbs += ingredient.quantity! * gramsCarbs
                self.foodDiaryEntry!.gramsFiber += ingredient.quantity! * gramsFiber
                self.foodDiaryEntry!.save()
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                // There was a problem, check error.description
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}
