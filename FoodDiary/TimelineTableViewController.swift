//
//  TimelineTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/7/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
import Parse

class TimelineTableViewController: UITableViewController, UIAlertViewDelegate {
    
    
    var dataManager = DataManager()
    var dateFormatter = NSDateFormatter()
    var dayFormatter = NSDateFormatter()
    var timeFormatter = NSDateFormatter()
    var meals:[FoodDiaryEntry]?
    var rowToDelete: NSIndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataManager.delegate = self
        self.dataManager.loadTimelineData()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dayFormatter.dateFormat = "MMM dd, yyyy"
        timeFormatter.dateFormat = "h:mm a"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "archiveMeal:", name: "archiveMealNotification", object: nil)
        
    }
    
    func archiveMeal(notification: NSNotification) {
        print(notification.object)
        let mealToArchive: FoodDiaryEntry = notification.object as! FoodDiaryEntry
        var indexToArchive: Int?
        for (index, element) in meals!.enumerate() {
            print("Item \(index): \(element)")
            if element == mealToArchive {
                indexToArchive = index
                break
            }
                    }
        self.meals!.removeAtIndex(indexToArchive!)
        self.tableView.reloadData()

    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func deleteFoodDiaryEntry(button: UIButton) {
        let alert: UIAlertView = UIAlertView()
        
            if let superview = button.superview {
                if let cell = superview.superview as? TimelineTableViewCell {
                    let indexPath = self.tableView.indexPathForCell(cell)
                    self.rowToDelete = indexPath
                }
        }
        
        alert.title = "Delete"
        alert.message = "Are you sure you want to delete this entry?"
        alert.addButtonWithTitle("Yes")
        alert.addButtonWithTitle("No")
        alert.delegate = self  // set the delegate here
        alert.show()
    
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let buttonTitle = alertView.buttonTitleAtIndex(buttonIndex)
        print("\(buttonTitle!) pressed")
        if buttonTitle == "Yes" {
            // TODO: Figure out how I know what the current food Diary Entry Id is?
            let entry = self.meals![self.rowToDelete!.row]
            entry.deleteFromBackEnd()
            self.meals!.removeAtIndex(self.rowToDelete!.row)
            tableView.reloadData()
            
        }
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let meals = self.meals {
            return meals.count
        } else {
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell", forIndexPath: indexPath) as! TimelineTableViewCell
        
        let meal = meals![indexPath.row]
        
        var mealImageFile:PFFile?
        mealImageFile = meal.imgURL as? PFFile
        
        if mealImageFile != nil {
            mealImageFile!.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        cell.mealImage.image = image
                    }
                }
            }
        } else {
            print("mealImageFile is nil.")
        }
        
        let calories = NSString(format: "%.0f", meal.calories)
        
        cell.mealName.text = meal.mealName
        cell.mealLocationName.text = meal.locationName
        cell.mealDate.text = dayFormatter.stringFromDate(meal.timestamp)
        cell.mealTime.text = timeFormatter.stringFromDate(meal.timestamp)
        cell.mealScore.text = "Score: \(meal.mealScore())% (\(calories) cal.)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetail", sender: self)
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetail" {
            
            let destination = segue.destinationViewController as! ViewMealDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow
            let meal = meals![selectedIndexPath!.row]
            
            destination.foodDiaryEntry = meal
            
        }
        
    }
    
    func hideAllArchived() {
        if let meals = self.meals {
            var archived = [FoodDiaryEntry]()
            
            for meal in meals {
                if !meal.isVisible {
                    archived.append(meal)
                }
            }
        }
    }
    
}
