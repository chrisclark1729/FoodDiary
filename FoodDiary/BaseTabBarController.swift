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
        NotificationCenter.default.addObserver(self, selector: #selector(BaseTabBarController.userDidLogIn), name: NSNotification.Name(rawValue: "userDidLogIn"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseTabBarController.userDidLogout), name: NSNotification.Name(rawValue: "userDidLogout"), object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isLoggedIn() {
            print("User is logged in.")
        } else {
            self.performSegue(withIdentifier: "showLogInView", sender: self)
        }
    }
    
    func isLoggedIn() -> Bool {
        
        return (PFUser.current() != nil)
    }
    
    func userDidLogIn() {
        self.dismiss(animated: true, completion: nil)
        self.selectedIndex = 2
        self.performSegue(withIdentifier: "showOnboarding", sender: nil)
    }
    
    func userDidLogout() {
        self.performSegue(withIdentifier: "showLogInView", sender: self)
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
