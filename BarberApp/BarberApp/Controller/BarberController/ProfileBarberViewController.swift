//
//  ProfileViewController.swift
//  BarberApp
//
//  Created by admin on 2/17/22.
//

import UIKit

class ProfileBarberViewController: ProfileViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func editProfileClicked(_ sender: Any) {
        let editProfileVC = self.storyboard?.instantiateViewController(identifier: StoryBoard.Barber.editProfileBarberVC) as! EditProfileBarberViewController
        editProfileVC.user = profileUser
        editProfileVC.profilePic = profilePictureView?.image
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
}
