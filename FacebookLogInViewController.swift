//
//  FacebookLogINViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 7/21/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit

class FacebookLogInViewController: UIViewController, FBSDKLoginButtonDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    /*!
     @abstract Sent to the delegate when the button was used to login.
     @param loginButton the sender
     @param result The results of the login
     @param error The error (if any) from the login
 
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        <#code#>
    }
*/
    
    var logInViewController: PFLogInViewController! = PFLogInViewController()
    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.current() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            // Or Show Logout Button
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            //    self.returnUserData()
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if (PFUser.current() == nil) {
            
            self.logInViewController.fields = [.usernameAndPassword, .logInButton, .signUpButton,
                                               .passwordForgotten, .dismissButton ]
            
            let logInLogoTitle = UILabel()
            logInLogoTitle.text = "Trust Buds"
            
            self.logInViewController.logInView!.logo = logInLogoTitle
            self.logInViewController.delegate = self
            
            let SignUpLogoTitle = UILabel()
            SignUpLogoTitle.text = "Trust Buds"
            
            self.signUpViewController.signUpView!.logo = SignUpLogoTitle
            self.signUpViewController.delegate = self
            self.logInViewController.signUpController = self.signUpViewController
            
        }
        
    }
    
    // Facebook Delegate Methods
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            print(PFUser.current())
            NotificationCenter.default.post(name: Notification.Name(rawValue: "userDidLogIn"), object: nil)
            
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
            
            //     self.returnUserData()
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = (result! as AnyObject).value(forKey: "name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = (result! as AnyObject).value(forKey: "email") as! NSString
                print("User Email is: \(userEmail)")
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Parse Login
    
    func log(_ logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if (!username.isEmpty || !password.isEmpty) {
            return true
        }else {
            return false
        }
        
    }
    
    func log(_ logInController: PFLogInViewController, didLogIn user: PFUser) {
        //self.dismissViewControllerAnimated(true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "userDidLogIn"), object: nil)
    }
    
    func log(_ logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("Failed to login...")
        let refreshAlert = UIAlertController(title: "Not Able to Login", message: "Please try again.", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            refreshAlert.dismiss(animated: true, completion: nil)
        }))
        AppDelegate.topViewController().present(refreshAlert, animated: true, completion: nil)
    }
    
    // MARK: Parse Sign Up
    
    
    func signUpViewController(_ signUpController: PFSignUpViewController, didSignUp user: PFUser) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func signUpViewController(_ signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        print("Failed to sign up...")
    }
    
    func signUpViewControllerDidCancelSignUp(_ signUpController: PFSignUpViewController) {
        print("User dismissed sign up.")
    }
    
    // MARK: Actions
    
    @IBAction func simpleAction(_ sender: AnyObject) {
        self.present(self.logInViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func logoutAction(_ sender: AnyObject) {
        PFUser.logOut()
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
