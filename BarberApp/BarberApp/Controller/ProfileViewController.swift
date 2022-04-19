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
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var profilePictureView: UIImageView!

    var editAllow = true
    var profileUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(!editAllow){
            editProfileBtn.isHidden = true
        }
//        if(user?.id == profileUser?.id){
//            // user cannot message themselves (edited: for viewing their own profile, the message button will redirect to chatoverviewpage)
//            messageBtn.isHidden = true
//        }
        if let profilePicPath = profileUser?.profilePicPath {
            Post.getUrl(profilePicPath) { (url, err) in
                if let url = url {
                    if let data = try? Data(contentsOf: url) {
                        self.profilePictureView.image = UIImage(data: data)
                    }
                }
            }
        }
        nameLabel.text = "\(String(describing: profileUser!.firstname!)) \(profileUser!.lastname!)"
        if let age = profileUser?.age {
            ageLabel.text = "\(age)"
        }
        else {
            ageLabel.text = "N/A"
        }
        
        genderLabel.text = profileUser?.gender ?? "N/A"
        bioLabel.text = profileUser?.bio ?? ""
    }
    
    @IBAction func onMessageClicked(_ sender: Any) {
        print("Messaging....")
        print("user1: \(user?.id)")
        print("user2: \(profileUser?.id)")
        print(StoryBoard.chatOverviewVC)
        let chatVC = storyboard?.instantiateViewController(identifier: StoryBoard.chatOverviewVC) as! ChatViewController
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
    
}
