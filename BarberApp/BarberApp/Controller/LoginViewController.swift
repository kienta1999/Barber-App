//
//  LoginViewController.swift
//  BarberApp
//
//  Created by admin on 2/11/22.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var user: User?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStyling()
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        errorLabel.alpha = 0
        user = User.init(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", loginVc: self)
        
        if user!.validateLoginField() {
            user!.cleanFields()
            user?.loginUser()
        }
        else {
            errorLabel.text = User.fieldError
            errorLabel.alpha = 1
        }
    }
    
    func setUpStyling(){
//        emailTextField.attributedPlaceholder = [[NSAttributedString alloc] attributes:@{}]
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        errorLabel.alpha = 0
    }
    
    func transitionToHome(){
        let homeVC : HomepageViewController?
        if user?.role == "Barber"{
            homeVC = self.storyboard?.instantiateViewController(identifier: StoryBoard.homeBarberVC) as? HomepageBarberViewController
        }
        else if user?.role == "Client"{
            homeVC = self.storyboard?.instantiateViewController(identifier: StoryBoard.homeClientVC) as? HomepageClientViewController
        } else {
            return
        }
        homeVC?.user = user
        view.window?.rootViewController = homeVC
        view.window?.makeKeyAndVisible()
    }
}
