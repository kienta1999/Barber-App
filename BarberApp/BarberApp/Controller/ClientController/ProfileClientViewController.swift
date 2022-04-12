//
//  ProfileClientViewController.swift
//  BarberApp
//
//  Created by admin on 2/18/22.
//

import UIKit

class ProfileClientViewController: ProfileViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func editProfileClicked(_ sender: Any) {
        let editProfileVC = self.storyboard?.instantiateViewController(identifier: StoryBoard.Client.editProfileClientVC) as! EditProfileClientViewController
        editProfileVC.user = user
        editProfileVC.profilePic = profilePictureView?.image
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
}
