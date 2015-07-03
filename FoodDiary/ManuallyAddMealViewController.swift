//
//  ManuallyAddMealViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 7/2/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
import Parse

class ManuallyAddMealViewController: UIViewController {

    @IBOutlet weak var manualEntryMealNameTextView: UITextField!
    @IBOutlet weak var manualEntryLocationTextView: UITextField!
    @IBOutlet weak var manualEntryTimestampTextView: UITextField!
    @IBOutlet weak var manualEntryIngredientsTextView: UITextView!
    @IBOutlet weak var manualEntryHealthScore: UITextField!
    @IBOutlet weak var manualEntryCalories: UITextField!
    @IBOutlet weak var manualEntryGramsFat: UITextField!
    @IBOutlet weak var manualEntryGramsCarbs: UITextField!
    @IBOutlet weak var manualEntryGramsProtein: UITextField!
    @IBOutlet weak var manualEntryEnjoymentScore: UITextField!
    @IBOutlet weak var manualEntryMood: UITextField!
    @IBOutlet weak var manualEntryEnergyLevel: UITextField!
    @IBOutlet weak var manualEntryOtherDiners: UITextField!
    @IBOutlet weak var manualEntryNotes: UITextView!
    
    @IBAction func sendManualFoodDiaryEntry(sender: AnyObject) {
        
        var foodDiaryEntry:PFObject = PFObject(className:"FoodDiaryEntries")
        
       // foodDiaryEntry["user"] = PFUser.currentUser()
        foodDiaryEntry["user"] = "chris test"
        foodDiaryEntry["mealName"] = manualEntryMealNameTextView.text
        foodDiaryEntry["location"] = manualEntryLocationTextView.text
        foodDiaryEntry["timestamp"] = manualEntryTimestampTextView.text
        foodDiaryEntry["healthScore"] = manualEntryHealthScore.text
        foodDiaryEntry["calories"] = manualEntryCalories.text
        foodDiaryEntry["gramsFat"] = manualEntryGramsFat.text
        foodDiaryEntry["gramsCarbs"] = manualEntryGramsCarbs.text
        foodDiaryEntry["gramsProtein"] = manualEntryGramsProtein.text
        foodDiaryEntry["enjoymentScore"] = manualEntryEnjoymentScore.text
        foodDiaryEntry["mood"] = manualEntryMood.text
        foodDiaryEntry["energyLevel"] = manualEntryEnergyLevel.text
        foodDiaryEntry["otherDiners"] = manualEntryOtherDiners.text
        foodDiaryEntry["Notes"] = manualEntryNotes.text
        foodDiaryEntry["wasEaten"] = true
        
        foodDiaryEntry.saveInBackground()
        self.navigationController?.popToRootViewControllerAnimated(true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
