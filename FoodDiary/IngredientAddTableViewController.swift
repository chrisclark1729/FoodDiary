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
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var fatGramsLabel: UILabel!
    @IBOutlet weak var saturatedFatGramsLabel: UILabel!
    @IBOutlet weak var cholesterolLabel: UILabel!
    @IBOutlet weak var sodiumLabel: UILabel!
    @IBOutlet weak var gramsCarbsLabel: UILabel!
    @IBOutlet weak var gramsFiberLabel: UILabel!
    @IBOutlet weak var gramsSugarLabel: UILabel!
    @IBOutlet weak var gramsProteinLabel: UILabel!
    
    
    @IBOutlet weak var numberOfServingsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let calories = ingredient!["calories"]!
        let fatGrams = ingredient!["gramsFat"]!
        let saturatedFatGrams = ingredient!["gramsSaturatedFat"]!
        let cholesterol = ingredient!["gramsCholesterol"]!
        let sodium = ingredient!["gramsSodium"]!
        let gramsCarbs = ingredient!["gramsCarbs"]!
        let fiber = ingredient!["gramsFiber"]!
        let sugar = ingredient!["gramsSugar"]!
        let protein = ingredient!["gramsProtein"]!
        var caloriesDisplay: Int = 0
        var fatGramsDisplay: Int = 0
        var saturatedFatGramsDisplay: Int = 0
        var cholesterolDisplay: Int = 0
        var sodiumDisplay: Int = 0
        var gramsCarbsDisplay: Int = 0
        var fiberDisplay: Int = 0
        var sugarDisplay: Int = 0
        var proteinDisplay: Int = 0
        var multiplier = 1
        
        caloriesDisplay = (calories as? Int)! * multiplier
        fatGramsDisplay = (fatGrams as? Int)! * multiplier
        saturatedFatGramsDisplay = (saturatedFatGrams as? Int)! * multiplier
        cholesterolDisplay = (cholesterol as? Int)! * multiplier
        sodiumDisplay = (sodium as? Int)! * multiplier
        gramsCarbsDisplay = (gramsCarbs as? Int)! * multiplier
        fiberDisplay = (fiber as? Int)! * multiplier
        sugarDisplay = (sugar as? Int)! * multiplier
        proteinDisplay = (protein as? Int)! * multiplier
        
        self.caloriesLabel.text = String(caloriesDisplay)
        self.fatGramsLabel.text = String(fatGramsDisplay)
        self.saturatedFatGramsLabel.text = String(saturatedFatGramsDisplay)
        self.cholesterolLabel.text = String(cholesterolDisplay)
        self.sodiumLabel.text = String(sodiumDisplay)
        self.gramsCarbsLabel.text = String(gramsCarbsDisplay)
        self.gramsFiberLabel.text = String(fiberDisplay)
        self.gramsSugarLabel.text = String(sugarDisplay)
        self.gramsProteinLabel.text = String(proteinDisplay)
        
    }

    @IBAction func addIngredientButtonTapped(sender: UIButton) {
        
        self.foodDiaryEntry = Session.sharedInstance.currentFoodDiaryEntry!
        let foodDiaryDetail = Session.sharedInstance.currentSelectedFoodDiaryDetail
        
        if let detail = foodDiaryDetail {
            detail.toPFObject!["numberOfServings"] = (self.numberOfServingsTextField.text)!.floatValue
            detail.quantity = (self.numberOfServingsTextField.text)!.floatValue
            detail.toPFObject?.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
            self.navigationController?.popViewControllerAnimated(true)
                } else {
                    print("There was a problem, check error.description")
                }
            }
        } else {
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
                    print("There was a problem, check error.description")
                }
            }
        }
       
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            let ingredientName = ingredient!["ingredientName"] as? String
            let unitOfMeasurement = ingredient!["unitOfMeasurement"] as? String
            return ingredientName! + " (" + unitOfMeasurement! + ")" as? String
        } else {
            return "Nutrition Facts"
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            return 2
        } else {
                return 9
            }
    }
  
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ingredientNutritionData", forIndexPath: indexPath)
        let row = indexPath.row
        let calories = ingredient!["calories"] as! Int
        let caloriesAsString = String(calories)
        
        if row == 0 {
            cell.textLabel?.text = caloriesAsString
        }
        
        print(self.ingredient!["calories"])
        
        return cell
    }
    
*/
    
    
}
