//
//  LoginViewController.swift
//  Diary App
//
//  Created by Angus Muller on 19/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: Properties
    
    let usernameKey = "Gus"
    let passwordKey = "Pass"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: IBActions
    
    
    @IBAction func loginAction(_ sender: Any) {
        if checkLogin(username: usernameField.text!, password: passwordField.text!) { // Fource unwrapping for now, can add empty checks for textfoeld later
            performSegue(withIdentifier: "dismissLogin", sender: self)
        } else {
            // Error message that wrong details enetered
        }
    }
    
    // Checkecking secuirty details are correct
    func checkLogin(username: String, password: String) -> Bool {
        return username == usernameKey && password == passwordKey
    }

}


