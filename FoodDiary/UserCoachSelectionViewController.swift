//
//  UserCoachSelectionViewController.swift
//  FoodDiary
//
//  Created by chris clark on 10/24/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import UIKit

class UserCoachSelectionViewController: UIViewController {

    @IBOutlet weak var userDoesNotHaveCoach: UIButton!
    @IBOutlet weak var userInterestedInCoachButton: UIButton!
    @IBOutlet weak var userHasCoachButton: UIButton!
    @IBOutlet weak var coachTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func noCoachButtonPressed(_ sender: UIButton) {
        PFUser.current()?.add("No Coach", forKey: "doesUserHaveCoach")
    }
    
    
    @IBAction func interestedInCoachButtonPressed(_ sender: UIButton) {
        PFUser.current()?.add("Interested In Coach", forKey: "doesUserHaveCoach")
    }
    
    @IBAction func hasCoachButtonPressed(_ sender: UIButton) {
        PFUser.current()?.add("User Has Coach", forKey: "doesUserHaveCoach")
    }
    
    @IBAction func userCoachSubmitButtonPressed(_ sender: UIButton) {
        PFUser.current()?.add(coachTextField.text!, forKey: "userCoachName")
        do {
            try PFUser.current()?.save()
        } catch let error as NSError {
            print(error)
        }
        self.performSegue(withIdentifier: "userWeightData", sender: nil)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
