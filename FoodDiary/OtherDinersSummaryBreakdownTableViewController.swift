//
//  OtherDinersSummaryBreakdownTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 2/3/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import UIKit

class OtherDinersSummaryBreakdownTableViewController: UITableViewController {
    
    var summaries = [OtherDinersSummary]()
    var foodDiaryEntries: [FoodDiaryEntry]?
    let startDate = Session.sharedInstance.currentSelectedStartDate
    let endDate = Session.sharedInstance.currentSelectedEndDate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.summaries = self.getOtherDinerSummary()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getOtherDinerSummary() -> [OtherDinersSummary] {
        var summaries = [OtherDinersSummary]()
        self.foodDiaryEntries = FoodDiaryEntry.fetchFoodDiaryEntriesForSummary(startDate!, endDate: endDate!)
        var totalMeals:Int = 0
        var maxCaloriesPerMeal:Float = 0
        for entry in self.foodDiaryEntries! {
            entry.populateDinersSync()
        }
        
        let diners = self.getUniqueDiners(self.foodDiaryEntries!)
        
        for diner in diners {
            let filteredEntries = self.getFoodDiaryEntriesWithDiner(diner)
            let summary = OtherDinersSummary(entries: filteredEntries, dinerName: diner)
            summaries.append(summary)
            totalMeals += summary.mealCount
            
            if maxCaloriesPerMeal < summary.caloriesPerMeal {
                maxCaloriesPerMeal = summary.caloriesPerMeal
            }
            
        }
        
        for summary in summaries {
            summary.populateAttentionScore(maxCaloriesPerMeal, totalMeals: totalMeals)
        }
        
        return summaries.sort({ $0.attentionScore > $1.attentionScore })

    }
    
    func getUniqueDiners(entries: [FoodDiaryEntry]) -> Set<String> {
        var dinersForSummary = Set<String>()
        for entry in entries {
            for diner in entry.diners {
                dinersForSummary.insert(diner.name!)
            }
        }
        return dinersForSummary
    }
    
    func getFoodDiaryEntriesWithDiner(dinerName: String) -> [FoodDiaryEntry] {
        var filteredEntries = [FoodDiaryEntry]()
        for entry in self.foodDiaryEntries! {
            for diner in entry.diners {
                if diner.name == dinerName {
                    filteredEntries.append(entry)
                    break
                }
            }
        }
        
        return filteredEntries
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if summaries.count > 5 {
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
            return min(5, self.summaries.count)
        } else {
            if self.summaries.count > 5 {
                return self.summaries.count - 5
            } else {
                return 0
            }
            
        }

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dinerSummaryCell", forIndexPath: indexPath)
        
        let row = indexPath.row
        
        if indexPath.section == 0 {
            let summaryData = self.summaries[row]
            
            cell.textLabel!.text = " \(summaryData.dinerName) (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(summaryData.caloriesPerMeal)) (\(summaryData.mealCount) meals)"
            return cell
        } else {
            if self.summaries.count > 5 {
                let summaryData = self.summaries[row + 5]
                cell.textLabel!.text = " \(summaryData.dinerName) (\(Int(100*summaryData.percentTotalCalories!)) % of total calories)"
                cell.detailTextLabel!.text = "Calories per Meal: \(Int(summaryData.caloriesPerMeal)) (\(summaryData.mealCount) meals)"
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
