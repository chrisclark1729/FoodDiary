//
//  AddMealDetailViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/8/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit

class ViewMealDetailViewController: UITableViewController {
    
    var foodDiaryEntry: FoodDiaryEntry?
    var dayFormatter = DateFormatter()
    
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
    
    @IBAction func archiveMeal(_ sender: AnyObject) {
        
        self.foodDiaryEntry?.archiveMeal()
        let ingredientCount = self.foodDiaryEntry?.ingredientDetails.count
        
        if ingredientCount == 0 {
            print("No Ingredients. Nothing to save.")
        } else {
            self.foodDiaryEntry?.createMealFromFoodDiaryEntry()
        }
      //  self.navigationController?.popViewController(animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: Add loader here
        DispatchQueue.global(qos: .background).async {
            self.initDetailFields()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func initDetailFields() {
        foodDiaryEntry?.populateDiners()
        foodDiaryEntry?.populateIngredients()
        foodDiaryEntry?.populateNotes()
        foodDiaryEntry?.populateIngredientDetails()
        foodDiaryEntry?.save()
        let entry = foodDiaryEntry
        Session.sharedInstance.currentFoodDiaryEntry = entry
        
        let dinersCountAsString = String(foodDiaryEntry!.diners.count)
        let notesCountAsString = String(foodDiaryEntry!.notes.count)
        let ingredientsCountAsString = String(foodDiaryEntry!.ingredientDetails.count)
        DispatchQueue.main.async {
            self.dayFormatter.dateFormat = "MMM dd, yyyy: h:mm a"
            self.mealName.text = entry?.mealName
            self.mealLocationName.text = entry?.locationName
            self.timeLabel.text = self.dayFormatter.string(from: (entry?.timestamp)! as Date)
            self.moodLabel.text = entry?.mood
            self.enjoymentScoreLabel.text = "Enjoyment Score: " + (NSString(format: "%.1f", (entry?.enjoymentScore)!) as String)
            self.energyLevelLabel.text = "Energy Level: " + (NSString(format: "%.1f",(entry?.energyLevel)!) as String)
            self.healthScoreLabel.text = "Health Score: " + (NSString(format: "%.1f", (entry?.healthScore)!) as String)
            self.otherDinersLabel.text = "Other Diners: " + dinersCountAsString
            self.notesLabel.text = "Notes: " + notesCountAsString
            self.ingredientsLabel.text = "Ingredients: " + ingredientsCountAsString
            self.caloriesLabel.text = "Calories: " + (NSString(format: "%.0f",(entry?.calories)!) as String)
            self.macrosLabel.text = "Carbs: " + (NSString(format: "%.0f",(entry?.gramsCarbs)!) as String) + "g, " + "Protein: "  + (NSString(format: "%.0f",(entry?.gramsProtein)!) as String) + "g, Fat: "  + (NSString(format: "%.0f",(entry?.gramsFat)!) as String) + "g"
            //TODO: Stop loader here
        }
        
        
           }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 /*
    func save() {
        self.foodDiaryEntry?.mealName = self.mealName.text!
        
    } */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editFoodDiaryEntry"
        {
            let destination = segue.destination as! EditMealDetailTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
        } else if segue.identifier == "editMealExperience" {
            let destination = segue.destination as! EditMealExperienceTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
        } else if segue.identifier == "editMealComponents" {
            let destination = segue.destination as! EditMealComponentsTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
        } else if segue.identifier == "editMood" {
            let destination = segue.destination as! EditMoodTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
        } else if segue.identifier == "editMealTags" {
            let destination = segue.destination as! EditMealTagsTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
        } else if segue.identifier == "showSearchIngredients" {
            let destination = segue.destination as! IngredientsSearchTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
            
        } else if segue.identifier == "showIngredientList" {
            let destination = segue.destination as! ViewAndEditMealIngredientsTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
            
        } else if segue.identifier == "editLocation" {
            let destination = segue.destination as! EditMealLocationTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
        } else if segue.identifier == "editTimestamp" {
            let destination = segue.destination as! EditTimestampTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shortPath = ((indexPath as NSIndexPath).section, (indexPath as NSIndexPath).row)
        switch shortPath {
        case (0, 3):
            if self.foodDiaryEntry!.hasIngredients()  {
                self.performSegue(withIdentifier: "showIngredientList", sender: self)
            } else {
                self.performSegue(withIdentifier: "showSearchIngredients", sender: self)
            }
            break
        default:
            break
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
