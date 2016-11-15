//
//  userDataOnboardingViewController.swift
//  FoodDiary
//
//  Created by chris clark on 10/12/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import UIKit

class userDataOnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var birthDate: UIDatePicker!
    @IBOutlet weak var postalCode: UITextField!
    
    @IBAction func userDataSubmitButtonPressed(_ sender: UIButton) {
        PFUser.current()?.add(gender.selectedSegmentIndex, forKey: "gender")
        PFUser.current()?.add(birthDate.date, forKey: "birthDate")
        PFUser.current()?.add(postalCode.text!, forKey: "postalCode")
        do {
            try PFUser.current()?.save()
        } catch let error as NSError {
            print(error)
        }
        self.performSegue(withIdentifier: "userCoachSelection", sender: nil)
        
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
