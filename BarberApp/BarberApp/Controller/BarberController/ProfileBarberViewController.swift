//
//  ProfileViewController.swift
//  BarberApp
//
//  Created by admin on 2/17/22.
//

import UIKit

class ProfileBarberViewController: ProfileViewController {
    
    @IBOutlet weak var phoneLabel: UILabel!
    var address: Address?
    @IBOutlet weak var barberAddressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let phone = profileUser?.phoneNumber {
            phoneLabel.text = "\(phone)"
        }
        else {
            phoneLabel.text = "N/A"
        }
        
        address = Address.init(profileUser!.id!, "")
        address?.getAddress(completion: { (found) in
            if(found){
                self.barberAddressLabel.text = "\(self.address!.title), \(self.address!.subtitile ?? "")"
            }
            else {
                self.barberAddressLabel.text = "N/A"
            }
        })
    }
    
    @IBAction func editProfileClicked(_ sender: Any) {
        if(user!.id == profileUser!.id){
            let editProfileVC = self.storyboard?.instantiateViewController(identifier: StoryBoard.Barber.editProfileBarberVC) as! EditProfileBarberViewController
            editProfileVC.user = profileUser
            editProfileVC.profilePic = profilePictureView?.image
            navigationController?.pushViewController(editProfileVC, animated: true)
        }
    }
}
