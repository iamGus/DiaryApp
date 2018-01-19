//
//  LoginViewController.swift
//  Diary App
//
//  Created by Angus Muller on 19/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

import UIKit

// Keychain Configuration
struct KeychainConfiguration {
    static let serviceName = "DiaryApp"
    static let accessGroup: String? = nil
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: Properties
    var passwordItems: [KeychainPasswordItem] = [] // to pass into the keychain
    let createLoginButtonTag = 0 // determine ig login button is being used
    let loginButtonTag = 1 // determine ig login button is being used

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check to see if already stored login for the user
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
        
        // Then set button title and tag
        if hasLogin {
            loginButton.setTitle("Login", for: .normal)
            loginButton.tag = loginButtonTag
        } else {
            loginButton.setTitle("Create", for: .normal)
            loginButton.tag = createLoginButtonTag
        }
        
        // If user already created then show username
        if let storedUsername = UserDefaults.standard.value(forKey: "username") as? String {
            usernameField.text = storedUsername
        }
    }
    
    // MARK: IBActions
    
    
    @IBAction func loginAction(_ sender: UIButton) {
        // Check that text has been enetered into username and password fields
        guard let newUsername = usernameField.text, let newPassword = passwordField.text, !newUsername.isEmpty, !newPassword.isEmpty else {
            showLoginFailedAlert()
            return
        }
        
        // Dismiss keyboard if vidable
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        //If login button has crateLoginButtonTag then create new login
        if sender.tag == createLoginButtonTag {
            let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
            if !hasLoginKey && usernameField.hasText {
                UserDefaults.standard.setValue(usernameField.text, forKey: "username")
            }
            
            do {
                // This is a new account, create a new keychain item with the username
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: newUsername, accessGroup: KeychainConfiguration.accessGroup)
                
                // Save the password for the nwe item
                try passwordItem.savePassword(newPassword)
            } catch {
                fatalError("Error uodating keychain: \(error)")
            }
            
            // Set hasLoginKey to indicate a password ahs been saved to keychain
            UserDefaults.standard.set(true, forKey: "hasLoginKey")
            loginButton.tag = loginButtonTag
            performSegue(withIdentifier: "dismissLogin", sender: self)
            
        // If login button has loginButtonTag then try logging in
        } else if sender.tag == loginButtonTag {
            if checkLogin(username: newUsername, password: newPassword) {
                performSegue(withIdentifier: "dismissLogin", sender: self)
            } else {
                showLoginFailedAlert()
            }
        }
    }
    
    // Checkecking secuirty details are correct
    func checkLogin(username: String, password: String) -> Bool {
        // Check username entered enetered matches one stored in UserDefaults
        guard username == UserDefaults.standard.value(forKey: "username") as? String else {
            return false
        }
        
        // Check password enetered matches one stored in Keychain
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: username, accessGroup: KeychainConfiguration.accessGroup)
            
            let keychainPassword = try passwordItem.readPassword()
            return password == keychainPassword
        } catch {
            fatalError("Error reading password from keychain: \(error)")
        }
    }
    
    private func showLoginFailedAlert() {
        showAlert(title: "Login Problem", message: "Wrong username or password")
    }

}


