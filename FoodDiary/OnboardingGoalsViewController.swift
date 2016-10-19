//
//  OnboardingGoalsViewController.swift
//  FoodDiary
//
//  Created by chris clark on 10/12/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import UIKit

class OnboardingGoalsViewController: UIViewController {
    
    var userPrimaryGoal = ""
    @IBOutlet weak var loseWeightButton: UIButton!
    @IBOutlet weak var maintainWeightButton: UIButton!
    @IBOutlet weak var gainWeightButton: UIButton!
    @IBOutlet weak var increaseEnergyButton: UIButton!
    @IBOutlet weak var reducePainButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goalLoseWeightButtonPressed(_ sender: UIButton) {
        PFUser.current()?.add("Lose Weight", forKey: "primaryOnboardingGoal")
        self.performSegue(withIdentifier: "userDataOnboarding", sender: nil)

    }
    
    @IBAction func goalMaintainWeightButtonPressed(_ sender: UIButton) {
        PFUser.current()?.add("Maintain Weight", forKey: "primaryOnboardingGoal")
        self.performSegue(withIdentifier: "userDataOnboarding", sender: nil)
    }
    
 
    @IBAction func goalGainWeightButtonPressed(_ sender: UIButton) {
        PFUser.current()?.add("Gain Weight", forKey: "primaryOnboardingGoal")
        self.performSegue(withIdentifier: "userDataOnboarding", sender: nil)
    }
    
    @IBAction func goalIncreaseEnergyButtonPressed(_ sender: UIButton) {
        PFUser.current()?.add("Increase Energy", forKey: "primaryOnboardingGoal")
        self.performSegue(withIdentifier: "userDataOnboarding", sender: nil)
    }
    
    @IBAction func goalReducePainButtonPressed(_ sender: UIButton) {
        PFUser.current()?.add("Reduce Pain", forKey: "primaryOnboardingGoal")
        self.performSegue(withIdentifier: "userDataOnboarding", sender: nil)
    }
    
    func showUserPrimaryGoal(goal: String) {
        
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
