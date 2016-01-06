//
//  NutritionSummaryTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 11/22/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import UIKit
import Parse

class NutritionSummaryTableViewController: UITableViewController {
    
    var dayFormatter = NSDateFormatter()
    @IBOutlet weak var unarchivedMealCountLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var mealCountLabel: UILabel!
    @IBOutlet weak var caloriesPerDayLabel: UILabel!
    @IBOutlet weak var caloriesPerMealLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    
    var foodDiaryEntries: [FoodDiaryEntry]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayFormatter.dateFormat = "MMM dd, yyyy"
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let startDate = Session.sharedInstance.currentSelectedStartDate {
            self.startDateLabel.text = dayFormatter.stringFromDate(startDate)
            if let endDate = Session.sharedInstance.currentSelectedEndDate {
                self.endDateLabel.text = dayFormatter.stringFromDate(endDate)
                self.foodDiaryEntries = FoodDiaryEntry.fetchFoodDiaryEntriesForSummary(startDate, endDate: endDate)
                self.dayCountLabel.text = "Days: \(sumCalories().0)"
                self.mealCountLabel.text = "Meals: \(sumCalories().1)"
                self.caloriesPerDayLabel.text = "\(sumCalories().2)"
                self.caloriesPerMealLabel.text = "\(sumCalories().3)"
                self.unarchivedMealCountLabel.text = "\(sumCalories().4)"
                self.carbsLabel.text = "Carbs: \(getMacros().3)%"
                self.proteinLabel.text = "Protein: \(getMacros().4)%"
                self.fatLabel.text = "Fat: \(getMacros().5)%"
            }

        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sumCalories()-> (Int, Int, Float, Float, Int) {
    
        var totalCalories: Float = 0
        var archivedMeals: Int = 0
        var mealsToBeReviewed: Int = 0
        var daysInRange: Int = 0
        var caloriesPerDay: Float = 0
        var caloriesPerMeal: Float = 0
        var daysArray = [String]()
        
        for entry in self.foodDiaryEntries! {
            totalCalories += entry.calories
            if entry.isVisible == true {
                mealsToBeReviewed += 1
            } else {
                let date = dayFormatter.stringFromDate(entry.timestamp)
                if daysArray.contains(date) {
                    print("Day already counted")
                } else {
                    daysArray.append(date)
                    daysInRange += 1
                }
                archivedMeals += 1
            }
        }
        
        if archivedMeals != 0 {
            caloriesPerMeal = totalCalories/Float(archivedMeals)
            caloriesPerDay = totalCalories/Float(daysInRange)
        }
        
        
        self.getMacros()
        return (daysInRange, archivedMeals, caloriesPerDay, caloriesPerMeal, mealsToBeReviewed)
    }
    
    func getMacros() -> (Float, Float, Float, Float, Float, Float) {
        var totalCalories: Float = 0
        var carbsBreakdown: Float = 0
        var proteinBreakdown: Float = 0
        var fatBreakdown: Float = 0
        var gramsCarbs: Float = 0
        var gramsProtein: Float = 0
        var gramsFat: Float = 0
        
        for entry in self.foodDiaryEntries! {
            if entry.isVisible == false {
                gramsCarbs += entry.gramsCarbs
                gramsProtein += entry.gramsProtein
                gramsFat += entry.gramsFat
            }
        }
        
        totalCalories = 4*gramsCarbs + 4*gramsProtein + 9*gramsFat
        carbsBreakdown = 4*gramsCarbs/totalCalories*100
        proteinBreakdown = 4*gramsProtein/totalCalories*100
        fatBreakdown = 9*gramsFat/totalCalories*100
        
        return (gramsCarbs, gramsProtein, gramsFat, carbsBreakdown, proteinBreakdown, fatBreakdown)
    }

    // MARK: - Table view data source
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    } 
    */
    
    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    */

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    
    func getFoodDiaryEntriesForCalorieCount(startDate: NSDate, endDate: NSDate) -> Int {
        let calories = 0
        let query:PFQuery = PFQuery(className:"FoodDiaryEntries")
        query.whereKey("timestamp", greaterThanOrEqualTo: startDate)
        query.whereKey("timestamp", lessThanOrEqualTo: endDate)
        
        let fetchedObjects = query.findObjects()
        
        var entries = [FoodDiaryEntry]()
        for fetchedObject in fetchedObjects! {
            let entry = FoodDiaryEntry(fetchedObject: fetchedObject as! PFObject)
            entries.append(entry)
        }
        
        print("Bro, calories are: \(calories)")
        return calories
    }

}
