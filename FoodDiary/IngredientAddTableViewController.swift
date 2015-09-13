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
    
    @IBOutlet weak var numberOfServingsTextField: UITextField!

    @IBAction func addIngredientButtonTapped(sender: AnyObject) {
        
        var ingredient = Ingredient()
        ingredient.ingredientId = self.ingredient
        ingredient.quantity = (self.numberOfServingsTextField.text).floatValue
        self.foodDiaryEntry?.ingredients.append(ingredient)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
}
