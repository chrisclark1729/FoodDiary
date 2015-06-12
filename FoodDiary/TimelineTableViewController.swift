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

    override func viewDidLoad() {
        super.viewDidLoad()

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
      return self.dataManager.getFoodDiaryEntries().count

    }

 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell", forIndexPath: indexPath) as! TimelineTableViewCell
        
        
        //TODO: Make sure meals sort descending
        let meals = self.dataManager.getFoodDiaryEntries()
        let meal = meals[indexPath.row]
        
        //TODO: Ask Aldrich if this belongs here?
        
        /*Meal "Score" is a combination of how healthy the meal is and how much the user enjoyed the meal.
          The philosophy is that the healthiest life is eating healthy food that you also enjoy.
          Overtime, I'd like this to be much more sophisticated.                           */

        let mealScore = (meal.healthScore*16)+(meal.enjoymentScore*4)
        
       /*
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = dateFormatter.dateFromString(meal.timestamp) as NSDate!
        let outputDate = dateFormatter.stringFromDate(date)
        let dateValue = dateFormatter.dateFromString(dataString) as NSDate!
        */
        
        var dataString = meal.timestamp as String
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
       // dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        let dateValue = dateFormatter.dateFromString(dataString) as NSDate!
        let dateValueAsString = String(stringInterpolationSegment: dateValue)
        
        // convert string into date
        
        
        println(dateValue)
        
        //TODO: Download Images asynchronously
       // let url = NSURL(string: meal.imgURL)
       // let data = NSData(contentsOfURL: url!) //TODO: make sure image in this url exists
      //  cell.mealImage.image = UIImage(data: data!) //UIImage(named: "placeholder")
        
        cell.mealName.text = meal.mealName
        cell.mealLocation.text = meal.location
        cell.mealDate.text = meal.timestamp.substringToIndex(advance(meal.timestamp.startIndex, 10))
        cell.mealTime.text = dateValueAsString
        cell.mealScore.text = "Score: \(mealScore)%"
        
        return cell
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
