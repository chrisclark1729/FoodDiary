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
    
    
    
    // TODO: Query
    //var mealNameSuggestions:[foodDiaryEnry] = ["suggestion1", "suggestion2", "suggestion3"]
    var mealNameSuggestions:[String] = ["suggestion1", "suggestion2", "suggestion3", "booze"]
    var selectedSuggestion:String?
    var mealNameField: UITextField?
    
    @IBOutlet weak var editMood: UITextField!
    @IBOutlet weak var editTimestampPicker: UIDatePicker!
    
    @IBAction func saveMood(sender: AnyObject) {
        
        self.foodDiaryEntry?.mood = self.editMood.text!
        foodDiaryEntry!.save()
        self.navigationController?.popViewControllerAnimated(true)
    }
   
    @IBAction func saveMealName(sender: AnyObject) {
        
        self.foodDiaryEntry?.mealName = self.mealNameField!.text!
        foodDiaryEntry!.save()
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    @IBAction func saveMealTimestamp(sender: AnyObject) {
        
        self.foodDiaryEntry?.timestamp = self.editTimestampPicker.date
        foodDiaryEntry!.save()
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
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
        self.initMoodField()
        self.initTimestampPicker()
    }
    
   
    func initMealNameField() {
      self.mealNameField!.text = self.foodDiaryEntry?.mealName
    }
    
    func initMoodField() {
        if let editMoodField = self.editMood {
            editMoodField.becomeFirstResponder()
            
            if let entry = foodDiaryEntry {
                
                editMoodField.text = entry.mood
            }
            else {
                print("No Food Entry")
            }
        }
        
    }
    
    func initTimestampPicker() {
        if let editTimestampPickerField = self.editTimestampPicker {
            editTimestampPickerField.becomeFirstResponder()
            
            if let entry = foodDiaryEntry {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy: h:mm a"
                
                self.editTimestampPicker.date = entry.timestamp
                
            } else {
                print("No Food Entry")
            }
        }
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
            cell.mealNameField.text = self.selectedSuggestion
            self.mealNameField = cell.mealNameField
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SuggestionCell", forIndexPath: indexPath) 
            cell.textLabel!.text = self.mealNameSuggestions[indexPath.row]
            return cell
        }
    

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedSuggestion = self.mealNameSuggestions[indexPath.row]
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
