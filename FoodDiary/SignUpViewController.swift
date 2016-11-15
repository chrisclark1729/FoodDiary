//
//  SignUpViewController.swift
//  FoodDiary
//
//  Created by chris clark on 10/3/16.
//  Copyright © 2016 Chris Clark. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, PFSignUpViewControllerDelegate {

    @IBOutlet weak var emailAddressSignUpField: UITextField!
    @IBOutlet weak var passwordSignUpField: UITextField!
    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signUpViewController.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccountWithEmailButtonPressed(_ sender: UIButton) {
        
        let user = PFUser()
        user.password = passwordSignUpField.text
        user.username = emailAddressSignUpField.text
        user.email = emailAddressSignUpField.text
        user.signUpInBackground(block: {
            (successful, error) in
            if error == nil {
                if successful {
                self.logIn()
                }
            }
        })
    }
    
    func logIn() {
        PFUser.logInWithUsername(inBackground: emailAddressSignUpField.text!, password: passwordSignUpField.text!, block: {
            (resultUser, error) in
            if let error = error {
                print(error)
                let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            } else {
                print(resultUser)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "userDidLogIn"), object: nil)
            }
        })
    }
    
    @IBAction func createAccountWithFacebookButtonPressed(_ sender: UIButton) {
        let permissions = ["public_profile", "email", "user_friends"]
        PFFacebookUtils.logInInBackground(withReadPermissions: permissions, block: {
            (user, error) in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "userDidLogIn"), object: nil)
                } else {
                    print("User logged in through Facebook!")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "userDidLogIn"), object: nil)
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        })
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
