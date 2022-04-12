//
//  ProfileViewController.swift
//  BarberApp
//
//  Created by admin on 2/17/22.
//

import UIKit

class ProfileBarberViewController: ProfileViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var profilePictureView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("------user?.profilePicPath------")
        print(user?.profilePicPath)
        if let profilePicPath = user?.profilePicPath {
            print("-----profilePicPath-------")
            print(profilePicPath)
            Post.getUrl(profilePicPath) { (url, err) in
                print("-----url-------")
                print(url)
                if let url = url {
                    if let data = try? Data(contentsOf: url) {
                        print("-----data-------")
                        print(data)
                        self.profilePictureView.image = UIImage(data: data)
                    }
                }
            }
        }
        nameLabel.text = "\(String(describing: user!.firstname!)) \(user!.lastname!)"
        if let age = user?.age {
            ageLabel.text = "\(age)"
        }
        else {
            ageLabel.text = "N/A"
        }
        
        genderLabel.text = user?.gender ?? "N/A"
        bioLabel.text = user?.bio ?? ""
    }
    
    
    @IBAction func editProfileClicked(_ sender: Any) {
        let editProfileVC = self.storyboard?.instantiateViewController(identifier: StoryBoard.Barber.editProfileBarberVC) as! EditProfileBarberViewController
        editProfileVC.user = user
        editProfileVC.profilePic = profilePictureView?.image
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
}
