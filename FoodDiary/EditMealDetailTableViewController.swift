//
//  EditMealDetailTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/26/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
import Parse

class EditMealDetailTableViewController: UITableViewController {
    
    var foodDiaryEntry: FoodDiaryEntry?
    var mealNameSuggestions:[Meal] = []
    var selectedSuggestion:String?
    var mealNameField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.initMealNameField()
        self.mealNameSuggestions = Meal.getAllMealsInLocation((foodDiaryEntry?.location)!, dayPart: (self.foodDiaryEntry?.dayPart())!)
        self.tableView.reloadData()
        
    }
   
    @IBAction func saveMealName(sender: AnyObject) {
        self.foodDiaryEntry?.mealName = self.mealNameField!.text!
        foodDiaryEntry!.save()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func initMealNameField() {
        self.mealNameField!.text = self.foodDiaryEntry?.mealName
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return 1
        } else {
            return mealNameSuggestions.count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("MealNameCell", forIndexPath: indexPath) as! MealNameFieldTableViewCell
            if let suggestion = self.selectedSuggestion {
                cell.mealNameField.text = suggestion
            } else {
                cell.mealNameField.text = foodDiaryEntry?.mealName
            }
            
            self.mealNameField = cell.mealNameField
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SuggestionCell", forIndexPath: indexPath) 
            cell.textLabel!.text = self.mealNameSuggestions[indexPath.row].getMealName()
            return cell
        }
    

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let meal = self.mealNameSuggestions[indexPath.row]
        print(meal.getMealIngredients())
        
        self.selectedSuggestion = meal.getMealName()
        self.tableView.reloadData()
        
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
