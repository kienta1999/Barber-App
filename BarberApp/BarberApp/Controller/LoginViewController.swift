//
//  LoginViewController.swift
//  BarberApp
//
//  Created by admin on 2/11/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStyling()
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        print("login")
    }
    
    func setUpStyling(){
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        errorLabel.alpha = 0
    }
}
