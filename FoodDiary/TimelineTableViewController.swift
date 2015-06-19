//
//  TimelineTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/7/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit

class TimelineTableViewController: UITableViewController {
    
    
    var dataManager = DataManager()
    var dateFormatter = NSDateFormatter()
    var dayFormatter = NSDateFormatter()
    var timeFormatter = NSDateFormatter()
    var meals:[FoodDiaryEntry]?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        meals = self.dataManager.getFoodDiaryEntries()
        
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dayFormatter.dateFormat = "MMM dd, yyyy"
        timeFormatter.dateFormat = "h:mm a"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
      return self.meals!.count

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell", forIndexPath: indexPath) as! TimelineTableViewCell
        
        //TODO: Make sure meals sort descending
        
        let meal = meals![indexPath.row]
        
        
        var mealTimeDate = dateFormatter.dateFromString(meal.timestamp)
        
        //TODO: Download Images asynchronously. Using AFNetworking
        cell.mealImage.setImageWithURL(NSURL(string: meal.imgURL))
        cell.mealName.text = meal.mealName
        cell.mealLocation.text = meal.location
        cell.mealDate.text = dayFormatter.stringFromDate(mealTimeDate!)
        cell.mealTime.text = timeFormatter.stringFromDate(mealTimeDate!)
        cell.mealScore.text = "Score: \(meal.mealScore())%"
        
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
            
            var destination = segue.destinationViewController as! AddMealDetailViewController
            var selectedIndexPath = tableView.indexPathForSelectedRow()
            var meal = meals![selectedIndexPath!.row]
            
            destination.foodDiaryEntry = meal
            
        }
        
    }


}
