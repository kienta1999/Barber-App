//
//  HomepageViewController.swift
//  BarberApp
//
//  Created by admin on 2/12/22.
//

import UIKit

class HomepageViewController: UIViewController {
    var user: User?
    
    @IBOutlet weak var helloLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        helloLabel.text = "Welcome \(user?.role ?? "Error")  \(user?.firstname ?? "Error") \(user?.lastname ?? "Error")"
        // Do any additional setup after loading the view.
    }

}
