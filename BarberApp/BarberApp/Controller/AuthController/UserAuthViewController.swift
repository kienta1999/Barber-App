//
//  UserAuthViewController.swift
//  BarberApp
//
//  Created by admin on 2/17/22.
//

import UIKit

class UserAuthViewController: UIViewController {
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func transitionToHome(){
        let homeVC : HomepageViewController?
        var tabBarIdentifier: String?
        if user?.role == "Barber"{
            homeVC = self.storyboard?.instantiateViewController(identifier: StoryBoard.Barber.homeVC) as? HomepageBarberViewController
            tabBarIdentifier = StoryBoard.Barber.tabVC
        }
        else if user?.role == "Client"{
            homeVC = self.storyboard?.instantiateViewController(identifier: StoryBoard.Client.homeVC) as? HomepageClientViewController
            tabBarIdentifier = StoryBoard.Client.tabVC
        } else {
            return
        }
        homeVC?.user = user
        let tabVC = self.storyboard?.instantiateViewController(identifier: tabBarIdentifier!) as! UITabBarController
        tabVC.setViewControllers([homeVC!], animated: true)
        
        self.navigationController?.setViewControllers([tabVC], animated: true)
        
    }

}
