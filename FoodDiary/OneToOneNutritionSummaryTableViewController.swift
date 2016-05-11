//
//  OneToOneNutritionSummaryTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 4/26/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import UIKit

class OneToOneNutritionSummaryTableViewController: UITableViewController {
    
    var summaryKey: String?
    var locationSummaries = [LocationSummary]()
    var foodDiaryEntries: [FoodDiaryEntry]?
    let startDate = Session.sharedInstance.currentSelectedStartDate
    let endDate = Session.sharedInstance.currentSelectedEndDate
    var summaries = [DayPartSummary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.summaries = self.getDayPartNutritionSummary()
    }
    
    func getDayPartNutritionSummary() -> [DayPartSummary] {
        self.foodDiaryEntries = FoodDiaryEntry.fetchFoodDiaryEntriesForSummary(startDate!, endDate: endDate!)
     //   var totalMeals:Int = 0
       // var maxCaloriesPerMeal:Float = 0
        var morningEntries = [FoodDiaryEntry]()
        for entry in self.foodDiaryEntries! {
            if entry.dayPart() == "morning" {
                morningEntries.append(entry)
            }
        }
        
        var lateMorningEntries = [FoodDiaryEntry]()
        for entry in self.foodDiaryEntries! {
            if entry.dayPart() == "late morning" {
                lateMorningEntries.append(entry)
            }
        }
        
        var afternoonEntries = [FoodDiaryEntry]()
        for entry in self.foodDiaryEntries! {
            if entry.dayPart() == "afternoon" {
                afternoonEntries.append(entry)
            }
        }
        
        var eveningEntries = [FoodDiaryEntry]()
        for entry in self.foodDiaryEntries! {
            if entry.dayPart() == "evening" {
                eveningEntries.append(entry)
            }
        }
        
        var nightEntries = [FoodDiaryEntry]()
        for entry in self.foodDiaryEntries! {
            if entry.dayPart() == "night" {
                nightEntries.append(entry)
            }
        }
        
        var lateNightEntries = [FoodDiaryEntry]()
        for entry in self.foodDiaryEntries! {
            if entry.dayPart() == "late night" {
                lateNightEntries.append(entry)
            }
        }

        let morningSummary = DayPartSummary(entries: morningEntries)
        let lateMorningSummary = DayPartSummary(entries: lateMorningEntries)
        let afternoonSummary = DayPartSummary(entries: afternoonEntries)
        let eveningSummary = DayPartSummary(entries: eveningEntries)
        let nightSummary = DayPartSummary(entries: nightEntries)
        let lateNightSummary = DayPartSummary(entries: lateNightEntries)

        
        return [morningSummary, lateMorningSummary, afternoonSummary, eveningSummary, nightSummary, lateNightSummary]


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
        }
        
        return "Day Part"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.summaries.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dayPartCell", forIndexPath: indexPath)
        let row = indexPath.row
        
        let summaryData = self.summaries[row]
        if indexPath.row == 0 {
            
            cell.textLabel!.text = "Morning: (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
            
        } else if indexPath.row == 1 {
            cell.textLabel!.text = "Late Morning: (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
            
        } else if indexPath.row == 2 {
            cell.textLabel!.text = "Afternoon: (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
        } else if indexPath.row == 3 {
            cell.textLabel!.text = "Evening: (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
        } else if indexPath.row == 4 {
            cell.textLabel!.text = "Night: (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
        } else if indexPath.row == 5 {
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
