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

    var dayFormatter = NSDateFormatter()
    var timeFormatter = NSDateFormatter()
    
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealLocationName: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var enjoymentScoreLabel: UILabel!
    @IBOutlet weak var energyLevelLabel: UILabel!
    @IBOutlet weak var healthScoreLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var macrosLabel: UILabel!
    @IBOutlet weak var otherDinersLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    @IBAction func archiveMeal(sender: AnyObject) {
        
        let query = PFQuery(className:"FoodDiaryEntries")
        query.getObjectInBackgroundWithId(foodDiaryEntry!.mealID) {
            (FoodDiaryEntry: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let entry = FoodDiaryEntry {
                entry["isVisible"] = false
                entry.saveInBackground()
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        
    }

    var foodDiaryEntry: FoodDiaryEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodDiaryEntry?.populateDiners()
 //       foodDiaryEntry?.populateIngredients()
        foodDiaryEntry?.populateNotes()
        foodDiaryEntry?.populateIngredientDetails()
        foodDiaryEntry?.save()
        
        dayFormatter.dateFormat = "MMM dd, yyyy: h:mm a"
      //  timeFormatter.dateFormat = "h:mm a"
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if let entry = foodDiaryEntry {
            
            
            let dinersCountAsString = String(foodDiaryEntry!.diners.count)
            let notesCountAsString = String(foodDiaryEntry!.notes.count)
            let ingredientsCountAsString = String(foodDiaryEntry!.ingredientDetails.count)
            
            
            self.mealName.text = entry.mealName
            self.mealLocationName.text = entry.locationName
            self.timeLabel.text = dayFormatter.stringFromDate(entry.timestamp)
            self.moodLabel.text = entry.mood
            self.enjoymentScoreLabel.text = "Enjoyment Score: " + (NSString(format: "%.1f", entry.enjoymentScore) as String)
            self.energyLevelLabel.text = "Energy Level: " + (NSString(format: "%.1f",entry.energyLevel) as String)
            self.healthScoreLabel.text = "Health Score: " + (NSString(format: "%.1f", entry.healthScore) as String)
            self.otherDinersLabel.text = "Other Diners: " + dinersCountAsString
            self.notesLabel.text = "Notes: " + notesCountAsString
            self.ingredientsLabel.text = "Ingredients: " + ingredientsCountAsString
            self.caloriesLabel.text = "Calories: " + (NSString(format: "%.0f",entry.calories) as String)
            self.macrosLabel.text = "Carbs: " + (NSString(format: "%.0f",entry.gramsCarbs) as String) + "g, " + "Protein: "  + (NSString(format: "%.0f",entry.gramsProtein) as String) + "g, Fat: "  + (NSString(format: "%.0f",entry.gramsFat) as String) + "g"
            entry.populateDiners()
            entry.populateIngredients()
            entry.populateNotes()

        }
        else {
            print("No Food Entry")
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
        segue.identifier == "editMood" || segue.identifier == "editLocation" || segue.identifier == "editMealDetail"
        {
            
            let destination = segue.destinationViewController as! EditMealDetailTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
            
        } else if segue.identifier == "editMealExperience" {
            let destination = segue.destinationViewController as! EditMealExperienceTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
        } else if segue.identifier == "editMealComponents" {
            let destination = segue.destinationViewController as! EditMealComponentsTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
        } else if segue.identifier == "editMealTags" {
            let destination = segue.destinationViewController as! EditMealTagsTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
        } else if segue.identifier == "showSearchIngredients" {
            let destination = segue.destinationViewController as! IngredientsSearchTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
            
        } else if segue.identifier == "showIngredientList" {
            let destination = segue.destinationViewController as! ViewAndEditMealIngredientsTableViewController
            
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
