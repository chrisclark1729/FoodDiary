//
//  TimeOfDaySummaryTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 2/3/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import UIKit

class TimeOfDaySummaryTableViewController: UITableViewController {

    var timeOfDaySummaries = [TimeOfDaySummary]()
    var foodDiaryEntries: [FoodDiaryEntry]?
    let startDate = Session.sharedInstance.currentSelectedStartDate
    let endDate = Session.sharedInstance.currentSelectedEndDate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timeOfDaySummaries = self.getTimeOfDaySummary()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.getTimeOfDaySummary()
        
    }
    
    
    func isTimeOfDayExisting(timeOfDay: String, summaries: [TimeOfDaySummary]) -> Bool {
        
        for summary in summaries {
            if summary.timeOfDay == timeOfDay {
                return true
            }
        }
        return false
    }
    
    func getTimeOfDaySummaryWithName(timeOfDay: String, summaries: [TimeOfDaySummary]) -> TimeOfDaySummary? {
        for summary in summaries {
            if summary.timeOfDay == timeOfDay {
                return summary
            }
        }
        return nil
    }
    
    func getTimeOfDaySummaryFromEntries(entries: [FoodDiaryEntry]) -> [TimeOfDaySummary]{
        var summaries = [TimeOfDaySummary]()
        
        for entry in entries {
            if !self.isTimeOfDayExisting(entry.dayPart(), summaries: summaries) {
                let timeOfDaySummary = TimeOfDaySummary(entry: entry)
                summaries.append(timeOfDaySummary)
            } else {
                let timeOfDaySummary = self.getTimeOfDaySummaryWithName(entry.dayPart(), summaries: summaries)
                timeOfDaySummary!.updateTimeOfDaySummary(entry)
                
            }
            
        }
        
        return summaries
    }
    
    func getTimeOfDaySummary() -> [TimeOfDaySummary]  {
        self.foodDiaryEntries = FoodDiaryEntry.fetchFoodDiaryEntriesForSummary(startDate!, endDate: endDate!)
        var totalMeals:Int = 0
        var maxCaloriesPerMeal:Float = 0
        let timeOfDaySummaryData = self.getTimeOfDaySummaryFromEntries(self.foodDiaryEntries!)
        
        for summary in timeOfDaySummaryData {
            totalMeals += summary.mealCount
            if maxCaloriesPerMeal < summary.caloriesPerMeal {
                maxCaloriesPerMeal = summary.caloriesPerMeal
            }
        }
        
        for summary in timeOfDaySummaryData {
            summary.populateAttentionScore(maxCaloriesPerMeal, totalMeals: totalMeals)
        }
        
        return timeOfDaySummaryData.sort({ $0.attentionScore > $1.attentionScore })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if timeOfDaySummaries.count > 5 {
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
        
        return 6
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("timeOfDayData", forIndexPath: indexPath)
        let row = indexPath.row
        
        let summaryData = self.timeOfDaySummaries[row]
        if indexPath.row == 0 && summaryData.timeOfDay == "morning" {
            
            cell.textLabel!.text = "Morning: (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
            
        } else if indexPath.row == 1 && summaryData.timeOfDay == " late morning" {
            cell.textLabel!.text = "Late Morning: (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
            
        } else if indexPath.row == 2 && summaryData.timeOfDay == "afternoon"  {
            cell.textLabel!.text = "Afternoon: (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
        } else if indexPath.row == 3 && summaryData.timeOfDay == "evening" {
            cell.textLabel!.text = "Evening: (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
        } else if indexPath.row == 4 && summaryData.timeOfDay == "night" {
            cell.textLabel!.text = "Night: (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
        } else if indexPath.row == 5 && summaryData.timeOfDay == "late night" {
            cell.textLabel!.text = "Late Night: (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
        }
        
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
