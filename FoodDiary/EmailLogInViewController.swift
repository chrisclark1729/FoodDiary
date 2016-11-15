//
//  ActualLogInViewController.swift
//  FoodDiary
//
//  Created by chris clark on 10/3/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import UIKit

class EmailLogInViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        
        var username = usernameField.text
        var password = passwordField.text
        
        if (username?.characters.count)! < 5 {
            let alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else if (password?.characters.count)! < 8{
            let alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            // Run a spinner to show a task in progress
            let logInSpinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            logInSpinner.startAnimating()
            
            PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!, block: {
                (resultUser, error) in
                if let error = error {
                    print(error)
                    let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                } else {
                    print(resultUser)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "userDidLogIn"), object: nil)
                    /*
                    DispatchQueue.main.async(execute: { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Timeline") 
                        self.present(viewController, animated: true, completion: nil)
                    }) */
                }
            })
            // Stop the spinner
            logInSpinner.stopAnimating()
        }
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
