//
//  BaseTabBarController.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/21/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseTabBarController.userDidLogIn), name: "userDidLogIn", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseTabBarController.userDidLogout), name: "userDidLogout", object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if isLoggedIn() {
            print("User is logged in.")
        } else {
            self.performSegueWithIdentifier("showLogInView", sender: self)
        }
    }
    
    func isLoggedIn() -> Bool {
        
        return (PFUser.currentUser() != nil)
    }
    
    func userDidLogIn() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func userDidLogout() {
        self.performSegueWithIdentifier("showLogInView", sender: self)
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
