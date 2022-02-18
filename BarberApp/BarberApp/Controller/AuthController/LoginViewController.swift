//
//  LoginViewController.swift
//  BarberApp
//
//  Created by admin on 2/11/22.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UserAuthViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStyling()
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        errorLabel.alpha = 0
        user = User.init(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        
        if user!.validateLoginField() {
            user!.cleanFields()
            user?.loginUser() { error, data in
                if let e = error {
                    self.errorLabel.text = e
                    self.errorLabel.alpha = 1
                } else {
                    self.user?.firstname = data?[User.userConstant.firstnameField] as? String
                    self.user?.lastname = data?[User.userConstant.lastnameField] as? String
                    self.user?.role = data?[User.userConstant.roleField]  as? String
                    self.transitionToHome()
                }
            }
        }
        else {
            errorLabel.text = User.fieldError
            errorLabel.alpha = 1
        }
    }
    
    
    func setUpStyling(){
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        errorLabel.alpha = 0
    }
}