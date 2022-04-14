//
//  EditProfileViewController.swift
//  BarberApp
//
//  Created by admin on 4/11/22.
//

import UIKit
import FirebaseStorage

class EditProfileViewController: HomepageViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var ageTextField: UITextField!
    
    
    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    
    let storageRef = Storage.storage().reference()
    var profilePic: UIImage?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    let imagePicker = UIImagePickerController()
    var imageUrl: URL?
    
    var gender: String =  "Male"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.text = ""
        ageTextField.textColor = .white
        maleButton.isSelected = true
        if let currGender = user?.gender{
            gender = currGender
            if currGender == "Female" {
                maleButton.isSelected = false
                femaleButton.isSelected = true
            }
            else if currGender == "Other" {
                maleButton.isSelected = false
                otherButton.isSelected = true
            }
        }
        if let age = user?.age {
            ageTextField.text = "\(age)"
        }
        if let bio = user?.bio {
            bioTextView.text = bio
        }
        if let profilePic = profilePic{
            profilePicture.image = profilePic
        }
        bioTextView?.layer.borderWidth = 1
        bioTextView?.layer.borderColor = UIColor.black.cgColor
        bioTextView?.layer.cornerRadius = bioTextView.frame.height / 10
        
    }
    
    @IBAction func genderButtonClicked(_ sender: UIButton) {
        maleButton.isSelected = false
        femaleButton.isSelected = false
        otherButton.isSelected = false
        sender.isSelected = true
        gender = sender.currentTitle!
    }
    
    
    @IBAction func saveProfile(_ sender: Any) {
        // validation
        var phoneNumber: Int? = nil
        if let phoneNumberText = (self as? EditProfileBarberViewController)?.phoneTextField?.text {
            phoneNumber = Int(phoneNumberText)
            if(phoneNumberText != "" && (phoneNumber == nil || phoneNumber! < 0)){
                errorMessage.text = "Phone number should either be blank or is a positive number"
                return
            }
            else if(phoneNumberText != "" && phoneNumberText.count != 10){
                errorMessage.text = "Phone number should have 10 digits"
                return
            }
        }
        
        if ageTextField.text != "" {
            if let age = Int(ageTextField.text!){
                if age > 100 || age < 0 {
                    errorMessage.text = "Age should be a number between 0 and 100"
                    return
                }
            }
            else {
                errorMessage.text = "Age should be a number or blank"
                return
            }
        }
    
        // save the data
        if let imageUrl = imageUrl, let userid = user?.id {
            spinner?.isHidden = false
            spinner?.startAnimating()
            profilePicture.alpha = 0.5
            view.alpha = 0.5
            let userImageRef = storageRef.child("Profile").child("\(userid)")
            userImageRef.putFile(from: imageUrl, metadata: nil) { metadata, error in
              guard let metadata = metadata else {
                print("image upload fail")
                return
              }
                let path = userImageRef.fullPath
                self.user?.editUserProfile(age: Int(self.ageTextField.text ?? ""), gender: self.gender, bio: self.bioTextView.text ?? "", path: path, phoneNumber: phoneNumber, completion: { (err) in
                    if let err = err {
                        self.errorMessage.text = err.localizedDescription
                        print(err)
                    } else{
                        self.navigateBackToProfile(self.profilePic)
                    }
                })
                print("Metadata: \(metadata)")
                print("Your image is posted successfully")
                self.spinner?.stopAnimating()
                self.spinner?.isHidden = true
            }
        }
        else {
            user?.editUserProfile(age: Int(ageTextField.text ?? ""), gender: gender, bio: bioTextView.text ?? "", path: nil, phoneNumber: phoneNumber, completion: { (err) in
                if let err = err {
                    print(err)
                    self.errorMessage.text = err.localizedDescription
                } else{
                    self.navigateBackToProfile(nil)
                }
            })
        }
    }
    
    func navigateBackToProfile(_ image: UIImage?){
        self.navigationController?.popViewController(animated: true)
        let tabVC = self.navigationController?.topViewController  as! UITabBarController
        tabVC.viewControllers?.forEach({ (vc) in
            (vc as! HomepageViewController).user = self.user
            if vc is ProfileViewController {
                if let profilePic = profilePic {
                    (vc as! ProfileViewController).profileUser = user
                    (vc as! ProfileViewController).profilePictureView.image = profilePic
                }
            }
        })
    }
    
    @IBAction func profileImageSelectClick(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let url = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerImageURL")] as? URL {
            imageUrl = url
        }
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            profilePicture.image = image
        }
    }

}
