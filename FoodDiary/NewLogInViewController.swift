//
//  NewLogInViewController.swift
//  
//
//  Created by chris clark on 10/3/16.
//
//

import UIKit

class NewLogInViewController: UIViewController, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate {
    
    var logInViewController: PFLogInViewController! = PFLogInViewController()
    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()
    
    @IBAction func facebookLogInButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func emailLogInButtonPressed(_ sender: UIButton) {
        self.present(self.logInViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        self.present(self.signUpViewController, animated: true, completion: nil)
    }
    
    func initSignUpView() {
        let SignUpLogoTitle = UILabel()
        SignUpLogoTitle.text = "Fit Map"
        
        self.signUpViewController.signUpView!.logo = SignUpLogoTitle

        self.signUpViewController.delegate = self
        self.logInViewController.signUpController = self.signUpViewController
        
    }
    
    func initLogInView() {
        self.logInViewController.fields = [.usernameAndPassword, .logInButton, .signUpButton,
                                           .passwordForgotten, .dismissButton ]
        
        let logInLogoTitle = UILabel()
        logInLogoTitle.text = "Fit Map"
        
        self.logInViewController.logInView!.logo = logInLogoTitle
        self.logInViewController.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initSignUpView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
