//
//  ViewController.swift
//  BarberApp
//
//  Created by admin on 2/7/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginRedirect: UIButton!
    @IBOutlet weak var signupRedirect: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStyling()
    }
    
    func setUpStyling(){
        Utilities.styleFilledButton(loginRedirect)
        Utilities.styleHollowButton(signupRedirect)
    }
}

