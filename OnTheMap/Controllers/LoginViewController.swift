//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Justin Priday on 2017/10/10.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let SIGNUP_URL = "https://www.udacity.com/account/auth#!/signup"
    let LAST_USER_KEY = "last_logged_in_user"
    
    // MARK: IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginActivityView: UIActivityIndicatorView!
    @IBOutlet weak var loginErrorLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIRoundedButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    // MARK: UIViewController Delegates
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login View did load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let lastUser = UserDefaults.standard.string(forKey: LAST_USER_KEY) {
            usernameTextField.text = lastUser
        }
    }
    
    // MARK: IBActions
    @IBAction func loginPressed(_ sender: Any) {
        if (usernameTextField.isFirstResponder) {
            usernameTextField.resignFirstResponder()
        } else if (passwordTextField.isFirstResponder) {
            passwordTextField.resignFirstResponder()
        }
        
        guard (usernameTextField.text?.isValidEmail())! else {
            showError(error: "Email address required")
            return
        }
        
        guard let text = passwordTextField.text, !text.isEmpty else {
            showError(error: "Password required")
            return
        }
        
        setUI(enabled: false)
        setLoading(true)
        UdacityClient.sharedInstance().authenticateUdacity(username: usernameTextField.text!, password: passwordTextField.text!) { (success, error) in
            self.setUI(enabled: true)
            self.setLoading(false)
            
            guard success, error == nil else {
                self.showError(error: error!)
                return
            }
            
            UserDefaults.standard.set(self.usernameTextField.text, forKey:self.LAST_USER_KEY) //Save last logged in user
            self.passwordTextField.text = "" //Remove password for future logout.
            self.performSegue(withIdentifier: "ShowOnTheMapViews", sender: nil)
            print("Login Success, show map")
        }
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        guard let url = URL(string:SIGNUP_URL) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func facebookLoginPressed(_ sender: Any) {
        print("Facebook Login")
    }
}

//Extension for UI Handling
extension LoginViewController {
    
    func showError(error : String) {
        loginActivityView.stopAnimating()
        loginErrorLabel.text = error
        loginErrorLabel.isHidden = false
    }
    
    func setLoading(_ loading : Bool) {
        loginErrorLabel.isHidden = true
        if loading {
            loginActivityView.startAnimating()
        } else {
            loginActivityView.stopAnimating()
        }
    }
    
    func setUI(enabled : Bool) {
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        signupButton.isEnabled = enabled
        facebookButton.isEnabled = enabled
    }
}

//Extension for UITextField Delegates
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.usernameTextField) {
            self.passwordTextField.becomeFirstResponder()
        } else if (textField == self.passwordTextField) {
            self.passwordTextField.resignFirstResponder()
            self.loginPressed(self)
        }
        
        return true
    }
}


