//
//  EditProfileBarberViewController.swift
//  BarberApp
//
//  Created by admin on 4/11/22.
//

import UIKit
import FirebaseStorage

class EditProfileBarberViewController: EditProfileViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    override func viewDidLoad(){
        super.viewDidLoad()
        if let phone = user?.phoneNumber{
            phoneTextField.text = String(phone)
        }
    }
    
    

}
