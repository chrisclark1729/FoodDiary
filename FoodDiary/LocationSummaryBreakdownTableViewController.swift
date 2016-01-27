//
//  LocationSummaryBreakdownTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 1/25/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import UIKit

class LocationSummaryBreakdownTableViewController: UITableViewController {
    
    var locationSummaryData = [String: (entryCount: Int, mealCount: Int, calories: Float, enjoymentScore: Float, healthScore: Float, lastTimestamp: NSDate)]()
    var locationSummary = [String: (Int, Float, Float, Float, Float)]()
    var foodDiaryEntries: [FoodDiaryEntry]?
    let startDate = Session.sharedInstance.currentSelectedStartDate
    let endDate = Session.sharedInstance.currentSelectedEndDate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.getLocationSummary()

    }
    
    //
    
    func getLocationSummary()  {
        self.foodDiaryEntries = FoodDiaryEntry.fetchFoodDiaryEntriesForSummary(startDate!, endDate: endDate!)
        var totalCalories:Float = 0
        var totalMeals:Int = 0
        var maxCaloriesPerMeal:Float = 0
        
        for entry in self.foodDiaryEntries! {
            
            if (locationSummaryData[entry.locationName] == nil) {
                locationSummaryData[entry.locationName] = (1, 1, entry.calories, entry.enjoymentScore, entry.healthScore, entry.timestamp)
                totalCalories += entry.calories
                totalMeals += 1
            } else {
                let minutesDifference = -NSCalendar.currentCalendar().components(.Minute, fromDate: locationSummaryData[entry.locationName]!.lastTimestamp, toDate: entry.timestamp, options: []).minute
                
                if minutesDifference < 75 {
                    locationSummaryData[entry.locationName]!.0 += 1
                    locationSummaryData[entry.locationName]!.2 += entry.calories
                    locationSummaryData[entry.locationName]!.3 += entry.enjoymentScore
                    locationSummaryData[entry.locationName]!.4 += entry.healthScore
                    locationSummaryData[entry.locationName]!.5 = entry.timestamp
                    totalCalories += entry.calories
                } else {
                    locationSummaryData[entry.locationName]!.0 += 1
                    locationSummaryData[entry.locationName]!.1 += 1
                    locationSummaryData[entry.locationName]!.2 += entry.calories
                    locationSummaryData[entry.locationName]!.3 += entry.enjoymentScore
                    locationSummaryData[entry.locationName]!.4 += entry.healthScore
                    locationSummaryData[entry.locationName]!.5 = entry.timestamp
                    totalCalories += entry.calories
                    totalMeals += 1
                }
            }
            
        }
        
        for location in locationSummaryData {
            var mealCount = 0
            var entryCount = 0
            var caloriesPerMeal: Float = 0
            var percentTotalCalories: Float = 0
            var enjoymentScore: Float = 0
            var attentionScore: Float = 0
            var healthScore: Float = 0
            var experienceScores: Float = 0
            let locationName = location.0
            
            mealCount = location.1.mealCount
            entryCount = location.1.entryCount
            caloriesPerMeal = location.1.calories/Float(mealCount)
            percentTotalCalories = location.1.calories/totalCalories
            enjoymentScore = location.1.enjoymentScore/Float(entryCount)
            healthScore = location.1.healthScore/Float(entryCount)
            
            //Rank locations to be sorted by various criteria:
            if maxCaloriesPerMeal < (location.1.calories/Float(mealCount)) {
                maxCaloriesPerMeal = location.1.calories
            }
            
            experienceScores = ((5 - enjoymentScore) * 0.04) + ((Float(mealCount)/Float(totalMeals)) * 0.1) + (5 - healthScore)/100
            attentionScore = (caloriesPerMeal/maxCaloriesPerMeal)*0.4 + percentTotalCalories*0.25 + experienceScores
            locationSummary[locationName] = (mealCount, caloriesPerMeal, percentTotalCalories, enjoymentScore, attentionScore)
            
            
           // locationAggregated = ("Name", mealCount, caloriesPerMeal, percentTotalCalories, enjoymentScore, attentionScore)
            
            
            /*
            locationSummary.append("Name", mealCount: mealCount, caloriesPerMeal: caloriesPerMeal, percentTotalCalories: percentTotalCalories, enjoymentScore: enjoymentScore, attentionScore: attentionScore) */
            
        }
        
        print(locationSummary)
        
        // return locationSummary

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locationSummary.count
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationData", forIndexPath: indexPath)
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
