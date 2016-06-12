//
//  DayOfWeekTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/12/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

class DayOfWeekSummaryTableViewController: UITableViewController {
    
    var dayOfWeekSummaries = [DayOfWeekSummary]()
    var foodDiaryEntries: [FoodDiaryEntry]?
    let startDate = Session.sharedInstance.currentSelectedStartDate
    let endDate = Session.sharedInstance.currentSelectedEndDate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dayOfWeekSummaries = self.getDayOfWeekSummary()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.getDayOfWeekSummary()
        
    }
    
    
    func isDayOfWeekExisting(dayOfWeek: String, summaries: [DayOfWeekSummary]) -> Bool {
        
        for summary in summaries {
            if summary.dayOfWeek == dayOfWeek {
                return true
            }
        }
        return false
    }
    
    func getDayOfWeekSummaryWithName(dayOfWeek: String, summaries: [DayOfWeekSummary]) -> DayOfWeekSummary? {
        for summary in summaries {
            if summary.dayOfWeek == dayOfWeek {
                return summary
            }
        }
        return nil
    }
    
    func getDayOfWeekSummaryFromEntries(entries: [FoodDiaryEntry]) -> [DayOfWeekSummary]{
        var summaries = [DayOfWeekSummary]()
        var dayOfWeekCheck = [String]()
        
        for entry in entries {
            if !self.isDayOfWeekExisting(entry.getDayOfWeek(), summaries: summaries) {
                let dayOfWeekSummary = DayOfWeekSummary(entry: entry)
                summaries.append(dayOfWeekSummary)
                dayOfWeekCheck.append(entry.getDayOfWeek())
            } else {
                let dayOfWeekSummary = self.getDayOfWeekSummaryWithName(entry.getDayOfWeek(), summaries: summaries)
                dayOfWeekSummary!.updateDayOfWeekSummary(entry)
                
            }
        }
        
        return summaries
    }
    
    func getDayOfWeekSummary() -> [DayOfWeekSummary]  {
        self.foodDiaryEntries = FoodDiaryEntry.fetchFoodDiaryEntriesForSummary(startDate!, endDate: endDate!)
        var totalMeals:Int = 0
        var maxCaloriesPerMeal:Float = 0
        let dayOfWeekSummaryData = self.getDayOfWeekSummaryFromEntries(self.foodDiaryEntries!)
        
        for summary in dayOfWeekSummaryData {
            totalMeals += summary.mealCount
            if maxCaloriesPerMeal < summary.caloriesPerMeal {
                maxCaloriesPerMeal = summary.caloriesPerMeal
            }
        }
        
        for summary in dayOfWeekSummaryData {
            summary.populateAttentionScore(maxCaloriesPerMeal, totalMeals: totalMeals)
        }
        
        return dayOfWeekSummaryData.sort({ $0.attentionScore > $1.attentionScore })
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
        
        return 7
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dayOfWeekData", forIndexPath: indexPath)
        
        var sundayPercent = Float(0)
        var sundayCaloriesPerMeal = Float(0)
        var sundayMealCount = 0
        var mondayPercent = Float(0)
        var mondayCaloriesPerMeal = Float(0)
        var mondayMealCount = 0
        var tuesdayPercent = Float(0)
        var tuesdayCaloriesPerMeal = Float(0)
        var tuesdayMealCount = 0
        var wednesdayPercent = Float(0)
        var wednesdayCaloriesPerMeal = Float(0)
        var wednesdayMealCount = 0
        var thursdayPercent = Float(0)
        var thursdayCaloriesPerMeal = Float(0)
        var thursdayMealCount = 0
        var fridayPercent = Float(0)
        var fridayCaloriesPerMeal = Float(0)
        var fridayMealCount = 0
        var saturdayPercent = Float(0)
        var saturdayCaloriesPerMeal = Float(0)
        var saturdayMealCount = 0
        
        for summary in self.dayOfWeekSummaries {
            if summary.dayOfWeek == "Sun" {
                sundayPercent = summary.percentTotalCalories!
                sundayCaloriesPerMeal = summary.caloriesPerMeal
                sundayMealCount = summary.entryCount
            } else if summary.dayOfWeek == "Mon" {
                mondayPercent = summary.percentTotalCalories!
                mondayCaloriesPerMeal = summary.caloriesPerMeal
                mondayMealCount = summary.entryCount
            } else if summary.dayOfWeek == "Tue" {
                tuesdayPercent = summary.percentTotalCalories!
                tuesdayCaloriesPerMeal = summary.caloriesPerMeal
                tuesdayMealCount = summary.entryCount
            } else if summary.dayOfWeek == "Wed" {
                wednesdayPercent = summary.percentTotalCalories!
                wednesdayCaloriesPerMeal = summary.caloriesPerMeal
                wednesdayMealCount = summary.entryCount
            }else if summary.dayOfWeek == "Thu" {
                thursdayPercent = summary.percentTotalCalories!
                thursdayCaloriesPerMeal = summary.caloriesPerMeal
                thursdayMealCount = summary.entryCount
            }else if summary.dayOfWeek == "Fri" {
                fridayPercent = summary.percentTotalCalories!
                fridayCaloriesPerMeal = summary.caloriesPerMeal
                fridayMealCount = summary.entryCount
            }else if summary.dayOfWeek == "Sat" {
                saturdayPercent = summary.percentTotalCalories!
                saturdayCaloriesPerMeal = summary.caloriesPerMeal
                saturdayMealCount = summary.entryCount
            }
            
        }
        
        if indexPath.row == 0 {
            cell.textLabel!.text = "Sunday: (\(Int(100*sundayPercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(sundayCaloriesPerMeal)) (\(sundayMealCount) meals) "
            
        } else if indexPath.row == 1 {
            cell.textLabel!.text = "Monday: (\(Int(100*mondayPercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(mondayCaloriesPerMeal)) (\(mondayMealCount) meals) "
        } else if indexPath.row == 2 {
            cell.textLabel!.text = "Tuesday: (\(Int(100*tuesdayPercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(tuesdayCaloriesPerMeal)) (\(tuesdayMealCount) meals) "
        } else if indexPath.row == 3 {
            cell.textLabel!.text = "Wednesday: (\(Int(100*wednesdayPercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(wednesdayCaloriesPerMeal)) (\(wednesdayMealCount) meals) "
        } else if indexPath.row == 4 {
            cell.textLabel!.text = "Thursday: (\(Int(100*thursdayPercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(thursdayCaloriesPerMeal)) (\(thursdayMealCount) meals) "
        } else if indexPath.row == 5 {
            cell.textLabel!.text = "Friday: (\(Int(100*fridayPercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(fridayCaloriesPerMeal)) (\(fridayMealCount) meals) "
        } else if indexPath.row == 6 {
            cell.textLabel!.text = "Saturday: (\(Int(100*saturdayPercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(saturdayCaloriesPerMeal)) (\(saturdayMealCount) meals) "
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
