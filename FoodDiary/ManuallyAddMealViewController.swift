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
    @IBOutlet weak var manualEntryMood: UITextField!
    @IBAction func sendManualFoodDiaryEntry(sender: AnyObject) {
        
        var foodDiaryEntry:PFObject = PFObject(className:"FoodDiaryEntries")
        
        foodDiaryEntry["mealName"] = manualEntryMealNameTextView.text
        foodDiaryEntry["locationName"] = manualEntryLocationTextView.text
     //   foodDiaryEntry["imageFile"] =
        foodDiaryEntry["timestamp"] = NSDate()
        foodDiaryEntry["healthScore"] = 0
        foodDiaryEntry["calories"] = 0
        foodDiaryEntry["gramsFat"] = 0
        foodDiaryEntry["gramsCarbs"] = 0
        foodDiaryEntry["gramsProtein"] = 0
        foodDiaryEntry["gramsFiber"] = 0
        foodDiaryEntry["enjoymentScore"] = 0
        foodDiaryEntry["mood"] = manualEntryMood.text
        foodDiaryEntry["energyLevel"] = 0
        foodDiaryEntry["wasEaten"] = true
        foodDiaryEntry["isVisible"] = true
        foodDiaryEntry["timezone"] = NSTimeZone.localTimeZone().abbreviation!
        foodDiaryEntry["location"] = PFGeoPoint(location: LocationManagerViewController.sharedLocation.lastKnownLocation)
        foodDiaryEntry["userId"] = PFUser.currentUser()
        
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
