//
//  LocationSummaryBreakdownTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 1/25/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import UIKit

class LocationSummaryBreakdownTableViewController: UITableViewController {
    
    var locationSummaries = [LocationSummary]()
    var foodDiaryEntries: [FoodDiaryEntry]?
    let startDate = Session.sharedInstance.currentSelectedStartDate
    let endDate = Session.sharedInstance.currentSelectedEndDate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationSummaries = self.getLocationSummary()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.getLocationSummary()
        
    }
    
    func getLocationSummary() -> [LocationSummary]  {
        self.foodDiaryEntries = FoodDiaryEntry.fetchFoodDiaryEntriesForSummary(startDate!, endDate: endDate!)
        var totalMeals:Int = 0
        var maxCaloriesPerMeal:Float = 0
        let locationSummaryData = self.getLocationSummaryFromEntries(self.foodDiaryEntries!)
        
        for summary in locationSummaryData {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if locationSummaries.count > 5 {
            return 2
        } else {
            return 1
        }
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Primary Focus"
        } else {
            return "Other Focus Items"
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            return min(5, locationSummaries.count)
        } else {
            if locationSummaries.count > 5 {
                return locationSummaries.count - 5
            } else {
                return 0
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationData", forIndexPath: indexPath)
        let row = indexPath.row
        
        if indexPath.section == 0 {
            let summaryData = self.locationSummaries[row]
            
            cell.textLabel!.text = " \(summaryData.locationName) (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(summaryData.caloriesPerMeal)) (\(summaryData.mealCount) meals) "
            return cell
        } else {
            if self.locationSummaries.count > 5 {
                let summaryData = self.locationSummaries[row + 5]
                cell.textLabel!.text = " \(summaryData.locationName) (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
                cell.detailTextLabel!.text = "Calories per Meal: \(Int(summaryData.caloriesPerMeal)) (\(summaryData.mealCount) meals) "
                return cell
            } else {
                return cell
            }
            
        }
        
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
