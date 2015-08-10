//
//  AddMealDetailViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/8/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
import Parse


class ViewMealDetailViewController: UITableViewController {

    
  //  @IBOutlet weak var mealName: UITextField!
    
    
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealLocationName: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    
    @IBOutlet weak var enjoymentScoreLabel: UILabel!
    
    @IBOutlet weak var energyLevelLabel: UILabel!
    
    @IBOutlet weak var healthScoreLabel: UILabel!
    @IBAction func cancelToViewMealDetailViewController(segue:UIStoryboardSegue) {
        
    }
    
    
    @IBAction func archiveMeal(sender: AnyObject) {
        
        var query = PFQuery(className:"FoodDiaryEntries")
        query.getObjectInBackgroundWithId(foodDiaryEntry!.mealID) {
            (FoodDiaryEntry: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let entry = FoodDiaryEntry {
                entry["isVisible"] = false
                entry.saveInBackground()
                self.navigationController?.popViewControllerAnimated(true)
            }
        }

        
    }

    
   
    /*
    @IBOutlet weak var mealName: UITextField!
    @IBOutlet weak var mealLocation: UITextField!
    @IBOutlet weak var mealTime: UILabel!
    @IBOutlet weak var calories: UITextField!
    @IBOutlet weak var mood: UITextField!
    @IBOutlet weak var otherDiners: UITextField!
    @IBOutlet weak var healthScore: UITextField!
    
    @IBOutlet weak var enjoymentScore: UITextField!
    
    @IBOutlet weak var energyLevel: UITextField!
    
    @IBOutlet weak var mealNotes: UITextField!
    
    @IBAction func cancelToMealDetailViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func saveIngredients(segue:UIStoryboardSegue) {
        
    }
    */
    var foodDiaryEntry: FoodDiaryEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if let entry = foodDiaryEntry {
            
            self.mealName.text = entry.mealName
            self.mealLocationName.text = entry.locationName
            self.moodLabel.text = entry.mood
            self.enjoymentScoreLabel.text = "Enjoyment Score: " + (NSString(format: "%.1f", entry.enjoymentScore) as String)
            self.energyLevelLabel.text = "Energy Level: " + (NSString(format: "%.1f",entry.energyLevel) as String)
             self.healthScoreLabel.text = "Health Score: " + (NSString(format: "%.1f", entry.healthScore) as String)
    
            /*
            
            self.mealTime.text = entry.timestamp
            self.calories.text = "Calories: " + String(stringInterpolationSegment: entry.calories)
            self.mood.text = "Mood: " + entry.mood
            self.otherDiners.text = "Other Diners: " + entry.otherPeople
            self.healthScore.text = "Health Score: " + String(stringInterpolationSegment: entry.healthScore)

            self.mealNotes.text = entry.notes
            */
        }
        else {
            println("No Food Entry")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func save() {
        self.foodDiaryEntry?.mealName = self.mealName.text!
        
    }
    

    @IBAction func sendMealDataUpdate(sender: AnyObject) {
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editFoodDiaryEntry" ||
        segue.identifier == "editMood" || segue.identifier == "editLocation"
        {
            
            var destination = segue.destinationViewController as! EditMealDetailTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
            
        } else if segue.identifier == "editMealExperience" {
            var destination = segue.destinationViewController as! EditMealExperienceTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
