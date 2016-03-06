//
//  signupViewController.swift
//  Instagram
//
//  Created by Difan Chen on 3/3/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit
import Parse

class signupViewController: UIViewController {
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: "tap:")
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        passwordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
    }
    
    @IBAction func onCancelSignup(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSignup(sender: AnyObject) {
        if (passwordTextField.text != repeatPasswordTextField.text) {
            return
        }
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        
        // call sign up function on the object
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User Registered successfully")
                // manually segue to logged in view
            }
        }
        performSegueWithIdentifier("backToLogin", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
