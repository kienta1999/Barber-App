//
//  ProfileClientViewController.swift
//  BarberApp
//
//  Created by admin on 2/18/22.
//

import UIKit

class ProfileClientViewController: ProfileViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var profilePictureView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "\(String(describing: user!.firstname!)) \(user!.lastname!)"
        if let age = user?.age {
            ageLabel.text = "\(age)"
        }
        else {
            ageLabel.text = "N/A"
        }
        
        genderLabel.text = user?.gender ?? "N/A"
        bioLabel.text = user?.bio ?? ""
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editProfileClicked(_ sender: Any) {
        let editProfileVC = self.storyboard?.instantiateViewController(identifier: StoryBoard.Client.editProfileClientVC) as! HomepageViewController
        editProfileVC.user = user
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
}
