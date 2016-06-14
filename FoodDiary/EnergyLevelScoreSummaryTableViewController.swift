//
//  EnergyLevelScoreSummaryTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/14/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import UIKit

class EnergyLevelScoreSummaryTableViewController: UITableViewController {
    
    var energyLevelScoreSummaries = [EnergyLevelScoreSummary]()
    var foodDiaryEntries: [FoodDiaryEntry]?
    let startDate = Session.sharedInstance.currentSelectedStartDate
    let endDate = Session.sharedInstance.currentSelectedEndDate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.energyLevelScoreSummaries = self.getEnergyLevelScoreSummary()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.getEnergyLevelScoreSummary()
        
    }
    
    
    func isEnergyLevelScoreExisting(energyLevelScore: String, summaries: [EnergyLevelScoreSummary]) -> Bool {
        
        for summary in summaries {
            if summary.energyLevelScoreRange == energyLevelScore {
                return true
            }
        }
        return false
    }
    
    func getEnergyLevelScoreSummaryWithName(energyLevelScore: String, summaries: [EnergyLevelScoreSummary]) -> EnergyLevelScoreSummary? {
        for summary in summaries {
            if summary.energyLevelScoreRange == energyLevelScore {
                return summary
            }
        }
        return nil
    }
    
    func getEnergyLevelScoreSummaryFromEntries(entries: [FoodDiaryEntry]) -> [EnergyLevelScoreSummary]{
        var summaries = [EnergyLevelScoreSummary]()
        var energyLevelScoreCheck = [String]()
        
        for entry in entries {
            if !self.isEnergyLevelScoreExisting(entry.getEnergyLevelScoreRange(), summaries: summaries) {
                let energyLevelScoreSummary = EnergyLevelScoreSummary(entry: entry)
                summaries.append(energyLevelScoreSummary)
                energyLevelScoreCheck.append(entry.getEnergyLevelScoreRange())
            } else {
                let energyLevelScoreSummary = self.getEnergyLevelScoreSummaryWithName(entry.getEnergyLevelScoreRange(), summaries: summaries)
                energyLevelScoreSummary!.updateEnergyLevelScoreRangeSummary(entry)
                
            }
        }
        
        return summaries
    }
    
    func getEnergyLevelScoreSummary() -> [EnergyLevelScoreSummary]  {
        self.foodDiaryEntries = FoodDiaryEntry.fetchFoodDiaryEntriesForSummary(startDate!, endDate: endDate!)
        var totalMeals:Int = 0
        var maxCaloriesPerMeal:Float = 0
        let energyLevelScoreSummaryData = self.getEnergyLevelScoreSummaryFromEntries(self.foodDiaryEntries!)
        
        for summary in energyLevelScoreSummaryData {
            totalMeals += summary.mealCount
            if maxCaloriesPerMeal < summary.caloriesPerMeal {
                maxCaloriesPerMeal = summary.caloriesPerMeal
            }
        }
        
        for summary in energyLevelScoreSummaryData {
            summary.populateAttentionScore(maxCaloriesPerMeal, totalMeals: totalMeals)
        }
        
        return energyLevelScoreSummaryData.sort({ $0.attentionScore > $1.attentionScore })
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
        return "Energy Level"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 5
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("energyLevelScoreData", forIndexPath: indexPath)
        
        var zeroToOnePercent = Float(0)
        var zeroToOneCaloriesPerMeal = Float(0)
        var zeroToOneMealCount = 0
        var oneToTwoPercent = Float(0)
        var oneToTwoCaloriesPerMeal = Float(0)
        var oneToTwoMealCount = 0
        var twoToThreePercent = Float(0)
        var twoToThreeCaloriesPerMeal = Float(0)
        var twoToThreeMealCount = 0
        var threeToFourPercent = Float(0)
        var threeToFourCaloriesPerMeal = Float(0)
        var threeToFourMealCount = 0
        var fourToFivePercent = Float(0)
        var fourToFiveCaloriesPerMeal = Float(0)
        var fourToFiveMealCount = 0
        
        for summary in self.energyLevelScoreSummaries {
            if summary.energyLevelScoreRange == "0 - 1" {
                zeroToOnePercent = summary.percentTotalCalories!
                zeroToOneCaloriesPerMeal = summary.caloriesPerMeal
                zeroToOneMealCount = summary.entryCount
            } else if summary.energyLevelScoreRange == "1 - 2" {
                oneToTwoPercent = summary.percentTotalCalories!
                oneToTwoCaloriesPerMeal = summary.caloriesPerMeal
                oneToTwoMealCount = summary.entryCount
            } else if summary.energyLevelScoreRange == "2 - 3" {
                twoToThreePercent = summary.percentTotalCalories!
                twoToThreeCaloriesPerMeal = summary.caloriesPerMeal
                twoToThreeMealCount = summary.entryCount
            } else if summary.energyLevelScoreRange == "3 - 4" {
                threeToFourPercent = summary.percentTotalCalories!
                threeToFourCaloriesPerMeal = summary.caloriesPerMeal
                threeToFourMealCount = summary.entryCount
            }else if summary.energyLevelScoreRange == "4 - 5" {
                fourToFivePercent = summary.percentTotalCalories!
                fourToFiveCaloriesPerMeal = summary.caloriesPerMeal
                fourToFiveMealCount = summary.entryCount
            }
        }
        
        if indexPath.row == 0 {
            cell.textLabel!.text = "0 - 1: (\(Int(100*zeroToOnePercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(zeroToOneCaloriesPerMeal)) (\(zeroToOneMealCount) meals) "
            
        } else if indexPath.row == 1 {
            cell.textLabel!.text = "1 - 2: (\(Int(100*oneToTwoPercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(oneToTwoCaloriesPerMeal)) (\(oneToTwoMealCount) meals) "
        } else if indexPath.row == 2 {
            cell.textLabel!.text = "2 - 3: (\(Int(100*twoToThreePercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(twoToThreeCaloriesPerMeal)) (\(twoToThreeMealCount) meals) "
        } else if indexPath.row == 3 {
            cell.textLabel!.text = "3 - 4: (\(Int(100*threeToFourPercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(threeToFourCaloriesPerMeal)) (\(threeToFourMealCount) meals) "
        } else if indexPath.row == 4 {
            cell.textLabel!.text = "4 - 5: (\(Int(100*fourToFivePercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(fourToFiveCaloriesPerMeal)) (\(fourToFiveMealCount) meals) "
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

