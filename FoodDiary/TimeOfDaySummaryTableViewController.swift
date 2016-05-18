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
        var dayPartCheck = [String]()
        
        for entry in entries {
            if !self.isTimeOfDayExisting(entry.dayPart(), summaries: summaries) {
                let timeOfDaySummary = TimeOfDaySummary(entry: entry)
                summaries.append(timeOfDaySummary)
                dayPartCheck.append(entry.dayPart())
            } else {
                let timeOfDaySummary = self.getTimeOfDaySummaryWithName(entry.dayPart(), summaries: summaries)
                timeOfDaySummary!.updateTimeOfDaySummary(entry)
                
            }
        }
        /*
        if !dayPartCheck.contains("morning") {
            let currentDate = NSDate()
            var morningSummary:TimeOfDaySummary?
            morningSummary = ("morning", 0, 0, Float(0), Float(0), Float(0), Float(0), Float(0), currentDate, Float(0))
            summaries.append(morningSummary!)
        } */
        
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
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Time Of Day"
           }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 6
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("timeOfDayData", forIndexPath: indexPath)
       // let row = indexPath.row
    //    let summaryCount = self.timeOfDaySummaries.count - 1
      //  let summaryData = self.timeOfDaySummaries[summaryCount]
        
        var morningPercent = Float(0)
        var morningCaloriesPerMeal = Float(0)
        var morningMealCount = 0
        var lateMorningPercent = Float(0)
        var lateMorningCaloriesPerMeal = Float(0)
        var lateMorningMealCount = 0
        var afternoonPercent = Float(0)
        var afternoonCaloriesPerMeal = Float(0)
        var afternoonMealCount = 0
        var eveningPercent = Float(0)
        var eveningCaloriesPerMeal = Float(0)
        var eveningMealCount = 0
        var nightPercent = Float(0)
        var nightCaloriesPerMeal = Float(0)
        var nightMealCount = 0
        var lateNightPercent = Float(0)
        var lateNightCaloriesPerMeal = Float(0)
        var lateNightMealCount = 0
        
        for summary in self.timeOfDaySummaries {
            if summary.timeOfDay == "morning" {
                morningPercent = summary.percentTotalCalories!
                morningCaloriesPerMeal = summary.caloriesPerMeal
                morningMealCount = summary.entryCount
            } else if summary.timeOfDay == "late morning" {
                lateMorningPercent = summary.percentTotalCalories!
                lateMorningCaloriesPerMeal = summary.caloriesPerMeal
                lateMorningMealCount = summary.entryCount
            } else if summary.timeOfDay == "afternoon" {
                afternoonPercent = summary.percentTotalCalories!
                afternoonCaloriesPerMeal = summary.caloriesPerMeal
                afternoonMealCount = summary.entryCount
            } else if summary.timeOfDay == "evening" {
                eveningPercent = summary.percentTotalCalories!
                eveningCaloriesPerMeal = summary.caloriesPerMeal
                eveningMealCount = summary.entryCount
            }else if summary.timeOfDay == "night" {
                nightPercent = summary.percentTotalCalories!
                nightCaloriesPerMeal = summary.caloriesPerMeal
                nightMealCount = summary.entryCount
            }else if summary.timeOfDay == "late night" {
                lateNightPercent = summary.percentTotalCalories!
                lateNightCaloriesPerMeal = summary.caloriesPerMeal
                lateNightMealCount = summary.entryCount
            }

        }
        
        if indexPath.row == 0 {
                cell.textLabel!.text = "Morning: (\(Int(100*morningPercent)) % of total calories)"
                cell.detailTextLabel!.text = "Calories per Meal: \(Int(morningCaloriesPerMeal)) (\(morningMealCount) meals) "
            
        } else if indexPath.row == 1 {
            cell.textLabel!.text = "Late Morning: (\(Int(100*lateMorningPercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(lateMorningCaloriesPerMeal)) (\(lateMorningMealCount) meals) "
        } else if indexPath.row == 2 {
            cell.textLabel!.text = "Afternoon: (\(Int(100*afternoonPercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(afternoonCaloriesPerMeal)) (\(afternoonMealCount) meals) "
        } else if indexPath.row == 3 {
            cell.textLabel!.text = "Evening: (\(Int(100*eveningPercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(eveningCaloriesPerMeal)) (\(eveningMealCount) meals) "
        } else if indexPath.row == 4 {
            cell.textLabel!.text = "Night: (\(Int(100*nightPercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(nightCaloriesPerMeal)) (\(nightMealCount) meals) "
        } else if indexPath.row == 5 {
            cell.textLabel!.text = "Late Night: (\(Int(100*lateNightPercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(lateNightCaloriesPerMeal)) (\(lateNightMealCount) meals) "
        }
        
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
