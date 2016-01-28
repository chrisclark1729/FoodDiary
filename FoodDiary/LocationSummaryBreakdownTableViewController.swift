//
//  LocationSummaryBreakdownTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 1/25/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import UIKit

class LocationSummaryBreakdownTableViewController: UITableViewController {
    
  //  var locationSummaryData = [String: (entryCount: Int, mealCount: Int, calories: Float, enjoymentScore: Float, healthScore: Float, lastTimestamp: NSDate)]()
    var locationSummaries = [LocationSummary]()
    var foodDiaryEntries: [FoodDiaryEntry]?
    let startDate = Session.sharedInstance.currentSelectedStartDate
    let endDate = Session.sharedInstance.currentSelectedEndDate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationSummaries = self.getLocationSummary()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.getLocationSummary()

    }
    
    func getTotalCalories(entries: [FoodDiaryEntry]) -> Float {
        var totalCalories: Float = 0
        
        for entry in entries {
            totalCalories += entry.calories
        }
        
        return totalCalories
    }
    
    func islocationExisting(locationName: String, summaries: [LocationSummary]) -> Bool {
        
        for summary in summaries {
            if summary.locationName == locationName {
                return true
            }
        }
        return false
    }
    
    func getLocationSummaryWithName(locationName: String, summaries: [LocationSummary]) -> LocationSummary? {
        for summary in summaries {
            if summary.locationName == locationName {
                return summary
            }
        }
        return nil
    }
    
    func getLocationSummaryFromEntries(entries: [FoodDiaryEntry]) -> [LocationSummary]{
        var summaries = [LocationSummary]()
        
        for entry in entries {
            if !self.islocationExisting(entry.locationName, summaries: summaries) {
                let locationSummary = LocationSummary(entry: entry)
                summaries.append(locationSummary)
            } else {
                let locationSummary = self.getLocationSummaryWithName(entry.locationName, summaries: summaries)
                locationSummary!.updateLocationSummary(entry)
                
            }

        }
        return summaries
    }
    
    
    func getLocationSummary() -> [LocationSummary]  {
        self.foodDiaryEntries = FoodDiaryEntry.fetchFoodDiaryEntriesForSummary(startDate!, endDate: endDate!)
       // var totalCalories:Float = self.getTotalCalories(self.foodDiaryEntries!)
        var totalMeals:Int = 0
        var maxCaloriesPerMeal:Float = 0
        let locationSummaryData = self.getLocationSummaryFromEntries(self.foodDiaryEntries!)
        
        for summary in locationSummaryData {
            print(summary)
            totalMeals += summary.mealCount
            if maxCaloriesPerMeal < summary.caloriesPerMeal {
                maxCaloriesPerMeal = summary.caloriesPerMeal
            }
        }
        
        for summary in locationSummaryData {
            summary.populateAttentionScore(maxCaloriesPerMeal, totalMeals: totalMeals)
        }
        
        return locationSummaryData.sort({ $0.attentionScore > $1.attentionScore })
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
        return locationSummaries.count
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationData", forIndexPath: indexPath)
        let summaryData = self.locationSummaries[indexPath.row]
        cell.textLabel!.text = " \(summaryData.locationName) (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
        cell.detailTextLabel!.text = "Calories per Meal: \(Int(summaryData.caloriesPerMeal)) (\(summaryData.mealCount) meals) "
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
