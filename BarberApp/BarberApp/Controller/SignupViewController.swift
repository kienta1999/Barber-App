//
//  SignupViewController.swift
//  BarberApp
//
//  Created by admin on 2/11/22.
//

import UIKit
import Firebase
//import FirebaseFirestore

class SignupViewController: UIViewController {
    
    @IBOutlet weak var rolePicker: UIPickerView!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    let rolePickerData = ["Barber", "Client"]
    var user: User?
    var userRole: String = "Barber"
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        rolePicker.dataSource = self
        rolePicker.delegate = self
        setUpStyling()
    }

    @IBAction func signupClicked(_ sender: UIButton) {
        errorLabel.alpha = 0
        user = User.init(firstname: firstNameTextField.text, lastname: lastNameTextField.text, email: emailTextField.text ?? "", password: passwordTextField.text ?? "", role: userRole, signupVc: self)
        if user!.validateSignupField(){
            if(user!.validatePassword()){
                user!.cleanFields()
                user!.createUser()
                
            }
            else{
                errorLabel.text = User.passwordError
                errorLabel.alpha = 1
            }
        }
        else{
            errorLabel.text = User.fieldError
            errorLabel.alpha = 1
        }
        
    }
    
    func setUpStyling(){
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleFilledButton(signupButton)
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



extension SignupViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rolePickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rolePickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width / 10
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(rolePickerData[row])
        userRole = rolePickerData[row]
    }
}
