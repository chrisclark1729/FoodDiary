//
//  NutritionSummaryTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 11/22/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import UIKit
//import Parse

class NutritionSummaryTableViewController: UITableViewController {
    
    var dayFormatter = NSDateFormatter()
    var foodDiaryEntries: [FoodDiaryEntry]?
    @IBOutlet weak var unarchivedMealCountLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var mealCountLabel: UILabel!
    @IBOutlet weak var mealsPerDay: UILabel!
    @IBOutlet weak var caloriesPerDayLabel: UILabel!
    @IBOutlet weak var caloriesPerMealLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayFormatter.dateFormat = "EEEE: MMM dd, yyyy"
        
        Session.sharedInstance.currentSelectedEndDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let unitFlags: NSCalendarUnit = [.Year,.Month,.Day,.Hour,.Minute,.Second]
        let components = calendar.components(unitFlags, fromDate: Session.sharedInstance.currentSelectedEndDate!)
        components.hour = 0
        components.minute = 0
        components.second = 0
        Session.sharedInstance.currentSelectedEndDate = calendar.dateFromComponents(components)

        self.endDateLabel.text = dayFormatter.stringFromDate(Session.sharedInstance.currentSelectedEndDate!)
  
        let startDate = Session.sharedInstance.currentSelectedEndDate?.dateByAddingTimeInterval(-7*24*60*60)
        Session.sharedInstance.currentSelectedStartDate = startDate
        self.startDateLabel.text = dayFormatter.stringFromDate(Session.sharedInstance.currentSelectedStartDate!)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let calendar = NSCalendar.currentCalendar()
        
        if let startDate = Session.sharedInstance.currentSelectedStartDate {
            self.startDateLabel.text = dayFormatter.stringFromDate(startDate)
            if let endDate = Session.sharedInstance.currentSelectedEndDate {
                let endDateForLabel = calendar.dateByAddingUnit(.Day, value: -1, toDate: endDate, options: [])
                self.endDateLabel.text = dayFormatter.stringFromDate(endDateForLabel!)
                self.foodDiaryEntries = FoodDiaryEntry.fetchFoodDiaryEntriesForSummary(startDate, endDate: endDate)
                self.dayCountLabel.text = "Days: \(sumCalories().0)"
                self.mealCountLabel.text = "Meals: \(sumCalories().1)"
                self.caloriesPerDayLabel.text = "\(sumCalories().2)"
                self.caloriesPerMealLabel.text = "\(sumCalories().3)"
                self.unarchivedMealCountLabel.text = "\(sumCalories().4)"
                self.mealsPerDay.text = "Meals per Day: \(sumCalories().5)"
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
    
    func sumCalories()-> (Int, Int, String, String, Int, String) {
    
        var totalCalories: Float = 0
        var archivedMeals: Int = 0
        var mealsToBeReviewed: Int = 0
        var daysInRange: Int = 0
        var mealsPerDay: String = ""
        var caloriesPerDay: String = ""
        var caloriesPerMeal: String = ""
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
            caloriesPerMeal = NSString(format: "%.0f", totalCalories/Float(archivedMeals)) as String
            caloriesPerDay = NSString(format: "%.0f", totalCalories/Float(daysInRange)) as String
            mealsPerDay =  NSString(format: "%.1f", Float(archivedMeals)/Float(daysInRange)) as String
        }
        
        Session.sharedInstance.currentTotalCalories = totalCalories
        Session.sharedInstance.currentMealCount = archivedMeals
        self.getMacros()
        return (daysInRange, archivedMeals, caloriesPerDay, caloriesPerMeal, mealsToBeReviewed, mealsPerDay)
    }
    
    func getMacros() -> (Float, Float, Float, String, String, String) {
        var totalCalories: Float = 0
        var carbsBreakdown: String = ""
        var proteinBreakdown: String = ""
        var fatBreakdown: String = ""
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
        carbsBreakdown = NSString(format: "%.0f", 4*gramsCarbs/totalCalories*100) as String
        proteinBreakdown = NSString(format: "%.0f", 4*gramsProtein/totalCalories*100) as String
        fatBreakdown = NSString(format: "%.0f", 9*gramsFat/totalCalories*100) as String
        
        return (gramsCarbs, gramsProtein, gramsFat, carbsBreakdown, proteinBreakdown, fatBreakdown)
    }
    
    /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("viewLocationSummary", sender: self )
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewLocationSummary"
        {
            Session.sharedInstance.currentOneToOneDimensionForSummary = "entry.locationName"
        } else if segue.identifier == "viewTimeOfDaySummary" {
            Session.sharedInstance.currentOneToOneDimensionForSummary = "entry.dayPart()"
        }
    } */

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

}
