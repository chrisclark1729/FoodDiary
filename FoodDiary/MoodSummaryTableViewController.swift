//
//  MoodSummaryTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 5/3/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import UIKit

class MoodSummaryBreakdownTableViewController: UITableViewController {
    
    var moodSummaries = [MoodSummary]()
    var foodDiaryEntries: [FoodDiaryEntry]?
    let startDate = Session.sharedInstance.currentSelectedStartDate
    let endDate = Session.sharedInstance.currentSelectedEndDate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moodSummaries = self.getMoodSummary()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.getMoodSummary()
        
    }
    
    func isMoodExisting(mood: String, summaries: [MoodSummary]) -> Bool {
        
        for summary in summaries {
            if summary.mood == mood {
                return true
            }
        }
        return false
    }
    
    func getMoodSummaryWithName(mood: String, summaries: [MoodSummary]) -> MoodSummary? {
        for summary in summaries {
            if summary.mood == mood {
                return summary
            }
        }
        return nil
    }
    
    func getMoodSummaryFromEntries(entries: [FoodDiaryEntry]) -> [MoodSummary]{
        var summaries = [MoodSummary]()
        
        for entry in entries {
            if !self.isMoodExisting(entry.mood, summaries: summaries) {
                let moodSummary = MoodSummary(entry: entry)
                summaries.append(moodSummary)
            } else {
                let moodSummary = self.getMoodSummaryWithName(entry.mood, summaries: summaries)
                moodSummary!.updateMoodSummary(entry)
                
            }
            
        }
        
        return summaries
    }
    
    func getMoodSummary() -> [MoodSummary]  {
        self.foodDiaryEntries = FoodDiaryEntry.fetchFoodDiaryEntriesForSummary(startDate!, endDate: endDate!)
        var totalMeals:Int = 0
        var maxCaloriesPerMeal:Float = 0
        let moodSummaryData = self.getMoodSummaryFromEntries(self.foodDiaryEntries!)
        
        for summary in moodSummaryData {
            totalMeals += summary.mealCount
            if maxCaloriesPerMeal < summary.caloriesPerMeal {
                maxCaloriesPerMeal = summary.caloriesPerMeal
            }
        }
        
        for summary in moodSummaryData {
            summary.populateAttentionScore(maxCaloriesPerMeal, totalMeals: totalMeals)
        }
        
        return moodSummaryData.sort({ $0.attentionScore > $1.attentionScore })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if moodSummaries.count > 5 {
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
            return min(5, moodSummaries.count)
        } else {
            if moodSummaries.count > 5 {
                return moodSummaries.count - 5
            } else {
                return 0
            }
            
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("moodData", forIndexPath: indexPath)
        let row = indexPath.row
        
        if indexPath.section == 0 {
            let summaryData = self.moodSummaries[row]
            
            cell.textLabel!.text = " \(summaryData.mood) (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(summaryData.caloriesPerMeal)) (\(summaryData.mealCount) meals) "
            return cell
        } else {
            if self.moodSummaries.count > 5 {
                let summaryData = self.moodSummaries[row + 5]
                cell.textLabel!.text = " \(summaryData.mood) (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
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
