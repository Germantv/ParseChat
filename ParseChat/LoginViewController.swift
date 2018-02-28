//
//  LoginViewController.swift
//  ParseChat
//
//  Created by German Flores on 2/28/18.
//  Copyright © 2018 German Flores. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBAction func signUpButton(_ sender: Any) {
        registerUser()
    }
    @IBAction func loginButton(_ sender: Any) {
        loginUser()
    }
    
    func registerUser() {
        //init a user obj
        let newUser = PFUser()
        
        //set the properties
        newUser.username = userNameTextField.text
        newUser.password = passWordTextField.text
        
        if (newUser.username?.isEmpty)! || (newUser.password?.isEmpty)! {
            let alertController = UIAlertController(title: "Username or Password required", message: "Please enter your username or password", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // handle response here.
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            present(alertController, animated: true) {}
        }
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User Registered successfully")
                // manually segue to logged in view
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    func loginUser() {
        
        let username = userNameTextField.text ?? ""
        let password = passWordTextField.text ?? ""
        
        if username.isEmpty || password.isEmpty {
            let alertController = UIAlertController(title: "Username or Password required", message: "Please enter your username or password", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // handle response here.
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            present(alertController, animated: true) {}
        }
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
            } else {
                print("User logged in successfully")
                // display view controller that needs to shown after successful login
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

