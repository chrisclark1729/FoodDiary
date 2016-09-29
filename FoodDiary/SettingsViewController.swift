//
//  SettingsViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/21/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        PFUser.logOut()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "userDidLogout"), object: nil)
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
