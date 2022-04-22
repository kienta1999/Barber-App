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
        
        if address == nil {
            address = Address.init(profileUser!.id!, "")
            address?.getAddress(completion: { (found) in
                if(found){
                    self.barberAddressLabel.text = "\(self.address!.title), \(self.address!.subtitile ?? "")"
                }
                else {
                    self.barberAddressLabel.text = "N/A"
                }
            })
        } else {
            self.barberAddressLabel.text = "\(self.address!.title), \(self.address!.subtitile ?? "")"
        }
        
    }
    
    @IBAction func editProfileClicked(_ sender: Any) {
        if(user!.id == profileUser!.id){
            let editProfileVC = self.storyboard?.instantiateViewController(identifier: StoryBoard.Barber.editProfileBarberVC) as! EditProfileBarberViewController
            editProfileVC.user = profileUser
            editProfileVC.profilePic = profilePictureView?.image
            navigationController?.pushViewController(editProfileVC, animated: true)
        }
    }
    @IBAction func onViewPostClicked(_ sender: Any) {
        let barberPostVC = storyboard?.instantiateViewController(identifier: StoryBoard.Barber.postFromBarberVC) as! PostFromBarberViewController
        barberPostVC.user = user
        barberPostVC.profileUser = profileUser
        navigationController?.pushViewController(barberPostVC, animated: true)
    }
    
    
}
