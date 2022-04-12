//
//  ProfileViewController.swift
//  BarberApp
//
//  Created by admin on 4/11/22.
//

import UIKit

class ProfileViewController: HomepageViewController {

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
        if let profilePicPath = user?.profilePicPath {
            print(profilePicPath)
            Post.getUrl(profilePicPath) { (url, err) in
                if let url = url {
                    if let data = try? Data(contentsOf: url) {
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
    
    
}
