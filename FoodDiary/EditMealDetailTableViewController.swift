//
//  EditMealDetailTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/26/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
//import Parse

class EditMealDetailTableViewController: UITableViewController {
    
    var foodDiaryEntry: FoodDiaryEntry?
    var mealNameSuggestions:[Meal] = []
  
    var mealNameField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initMealNameField()
        self.mealNameSuggestions = Meal.getAllMealsInLocation((foodDiaryEntry?.location)!, dayPart: (self.foodDiaryEntry?.dayPart())!)
        
        self.tableView.reloadData()
        
        
    }
   
    @IBAction func saveMealName(_ sender: AnyObject) {
        self.foodDiaryEntry?.mealName = self.mealNameField!.text!
        let mealIngredients = Session.sharedInstance.currentSelectedMeal?.getMealIngredients()
        if (mealIngredients != nil){
            self.foodDiaryEntry?.addFoodDiaryDetailFromMealIngredients(mealIngredients!)
        }
        foodDiaryEntry!.save()
        self.navigationController?.popViewController(animated: true)
    }
    
    func initMealNameField() {
        self.mealNameField!.text = self.foodDiaryEntry?.mealName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return mealNameSuggestions.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
            return cell

        } else if (indexPath as NSIndexPath).section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MealNameCell", for: indexPath) as! MealNameFieldTableViewCell
            if let suggestion = Session.sharedInstance.currentSelectedMeal {
                cell.mealNameField.text = suggestion.getMealName()
            } else {
                cell.mealNameField.text = foodDiaryEntry?.mealName
            }
            
            self.mealNameField = cell.mealNameField
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath) 
            cell.textLabel!.text = self.mealNameSuggestions[(indexPath as NSIndexPath).row].getMealName()
            return cell
        }
    

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 {
            self.performSegue(withIdentifier: "mealSearch", sender: self)
        } else {
            let meal = self.mealNameSuggestions[(indexPath as NSIndexPath).row]
            
            Session.sharedInstance.currentSelectedMeal = meal
            self.tableView.reloadData()
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
