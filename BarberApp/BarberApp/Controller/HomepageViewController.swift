//
//  HomepageViewController.swift
//  BarberApp
//
//  Created by admin on 2/12/22.
//

import UIKit

class HomepageViewController: UIViewController {
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func logoutClicked(_ sender: UIButton) {
        self.navigationController?.setViewControllers([storyboard!.instantiateViewController(withIdentifier: "loginSignupView")], animated: true)
    }
    
}
