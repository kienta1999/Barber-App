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
        if (user?.id == profileUser?.id){
            User.getAllRoom((user?.id)!) { (roomsData) in
                if let roomsData = roomsData {
                    let roomVC = self.storyboard?.instantiateViewController(withIdentifier: StoryBoard.roomOverviewVC) as! RoomViewController
                    roomVC.configurate(userId: self.user?.id, roomsData: roomsData)
                    self.navigationController?.pushViewController(roomVC, animated: true)
                }
                else {
                    print("Error: Cannot view the rooms")
                }
            }
        }
        else {
            let chatVC = ChatViewController(user: user!, user2: profileUser!)
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    
    
}
