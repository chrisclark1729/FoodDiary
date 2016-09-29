//
//  EnjoymentSumaryTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/13/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class EnjoymentScoreSummaryTableViewController: UITableViewController {
    
    var enjoymentScoreSummaries = [EnjoymentScoreSummary]()
    var foodDiaryEntries: [FoodDiaryEntry]?
    let startDate = Session.sharedInstance.currentSelectedStartDate
    let endDate = Session.sharedInstance.currentSelectedEndDate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.enjoymentScoreSummaries = self.getEnjoymentScoreSummary()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getEnjoymentScoreSummary()
        
    }
    
    
    func isEnjoymentScoreExisting(_ enjoymentScore: String, summaries: [EnjoymentScoreSummary]) -> Bool {
        
        for summary in summaries {
            if summary.enjoymentScoreRange == enjoymentScore {
                return true
            }
        }
        return false
    }
    
    func getEnjoymentScoreSummaryWithName(_ enjoymentScore: String, summaries: [EnjoymentScoreSummary]) -> EnjoymentScoreSummary? {
        for summary in summaries {
            if summary.enjoymentScoreRange == enjoymentScore {
                return summary
            }
        }
        return nil
    }
    
    func getEnjoymentScoreSummaryFromEntries(_ entries: [FoodDiaryEntry]) -> [EnjoymentScoreSummary]{
        var summaries = [EnjoymentScoreSummary]()
        var enjoymentScoreCheck = [String]()
        
        for entry in entries {
            if !self.isEnjoymentScoreExisting(entry.getEnjoymentScoreRange(), summaries: summaries) {
                let enjoymentScoreSummary = EnjoymentScoreSummary(entry: entry)
                summaries.append(enjoymentScoreSummary)
                enjoymentScoreCheck.append(entry.getEnjoymentScoreRange())
            } else {
                let enjoymentScoreSummary = self.getEnjoymentScoreSummaryWithName(entry.getEnjoymentScoreRange(), summaries: summaries)
                enjoymentScoreSummary!.updateEnjoymentScoreRangeSummary(entry)
                
            }
        }
        
        return summaries
    }
    
    func getEnjoymentScoreSummary() -> [EnjoymentScoreSummary]  {
        self.foodDiaryEntries = FoodDiaryEntry.fetchFoodDiaryEntriesForSummary(startDate!, endDate: endDate!)
        var totalMeals:Int = 0
        var maxCaloriesPerMeal:Float = 0
        let enjoymentScoreSummaryData = self.getEnjoymentScoreSummaryFromEntries(self.foodDiaryEntries!)
        
        for summary in enjoymentScoreSummaryData {
            totalMeals += summary.mealCount
            if maxCaloriesPerMeal < summary.caloriesPerMeal {
                maxCaloriesPerMeal = summary.caloriesPerMeal
            }
        }
        
        for summary in enjoymentScoreSummaryData {
            summary.populateAttentionScore(maxCaloriesPerMeal, totalMeals: totalMeals)
        }
        
        return enjoymentScoreSummaryData.sorted(by: { $0.attentionScore > $1.attentionScore })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Enjoyment Score"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 5
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "enjoymentScoreData", for: indexPath)
        
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
        
        for summary in self.enjoymentScoreSummaries {
            if summary.enjoymentScoreRange == "0 - 1" {
                zeroToOnePercent = summary.percentTotalCalories!
                zeroToOneCaloriesPerMeal = summary.caloriesPerMeal
                zeroToOneMealCount = summary.entryCount
            } else if summary.enjoymentScoreRange == "1 - 2" {
                oneToTwoPercent = summary.percentTotalCalories!
                oneToTwoCaloriesPerMeal = summary.caloriesPerMeal
                oneToTwoMealCount = summary.entryCount
            } else if summary.enjoymentScoreRange == "2 - 3" {
                twoToThreePercent = summary.percentTotalCalories!
                twoToThreeCaloriesPerMeal = summary.caloriesPerMeal
                twoToThreeMealCount = summary.entryCount
            } else if summary.enjoymentScoreRange == "3 - 4" {
                threeToFourPercent = summary.percentTotalCalories!
                threeToFourCaloriesPerMeal = summary.caloriesPerMeal
                threeToFourMealCount = summary.entryCount
            }else if summary.enjoymentScoreRange == "4 - 5" {
                fourToFivePercent = summary.percentTotalCalories!
                fourToFiveCaloriesPerMeal = summary.caloriesPerMeal
                fourToFiveMealCount = summary.entryCount
            }
        }
        
        if (indexPath as NSIndexPath).row == 0 {
            cell.textLabel!.text = "0 - 1: (\(Int(100*zeroToOnePercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(zeroToOneCaloriesPerMeal)) (\(zeroToOneMealCount) meals) "
            
        } else if (indexPath as NSIndexPath).row == 1 {
            cell.textLabel!.text = "1 - 2: (\(Int(100*oneToTwoPercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(oneToTwoCaloriesPerMeal)) (\(oneToTwoMealCount) meals) "
        } else if (indexPath as NSIndexPath).row == 2 {
            cell.textLabel!.text = "2 - 3: (\(Int(100*twoToThreePercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(twoToThreeCaloriesPerMeal)) (\(twoToThreeMealCount) meals) "
        } else if (indexPath as NSIndexPath).row == 3 {
            cell.textLabel!.text = "3 - 4: (\(Int(100*threeToFourPercent)) % of total calories)"
            cell.detailTextLabel!.text = "Calories per Meal: \(Int(threeToFourCaloriesPerMeal)) (\(threeToFourMealCount) meals) "
        } else if (indexPath as NSIndexPath).row == 4 {
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
