//
//  PostViewController.swift
//  BarberApp
//
//  Created by admin on 2/17/22.
//

import UIKit
import FirebaseStorage

class PostViewController: HomepageViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

    let storageRef = Storage.storage().reference()
    let barberPostRef: StorageReference
    let imagePicker = UIImagePickerController()
    var imageUrl: URL?
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    var placeholderLabel : UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        self.barberPostRef = storageRef.child("BarberPost")
        imageUrl = nil
        super.init(coder: aDecoder)
    }
    
    // https://stackoverflow.com/questions/27652227/add-placeholder-text-inside-uitextview-in-swift
    override func viewDidLoad() {
        super.viewDidLoad()
        print("barber post ref \(self.barberPostRef)")
        captionTextView.layer.borderWidth = 1
        captionTextView.layer.borderColor = UIColor.black.cgColor
        captionTextView.layer.cornerRadius = captionTextView.frame.height / 10
        
        captionTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Caption"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (captionTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        captionTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (captionTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !captionTextView.text.isEmpty
    }
    
    @IBAction func imageSelectClicked() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")

            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print("info \(info)")
        print("info \(String(describing: info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerImageURL")]))")
        if let url = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerImageURL")] as? URL {
            imageUrl = url
        }
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            imageView.image = image
        }
    }
    
    
    @IBAction func uploadImage(_ sender: UIButton) {
        if let imageUrl = imageUrl, let userid = user?.id {
            let imgName = imageUrl.relativeString.split(separator: "/").last ?? "default.jpeg"
            let userImageRef = barberPostRef.child("\(userid)/\(imgName)")
            userImageRef.putFile(from: imageUrl, metadata: nil) { metadata, error in
              guard let metadata = metadata else {
                print("error ! \(String(describing: error))")
                let alert = UIAlertController(title: "Upload Failed", message: String(describing: error), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
              }
//                Add to Firestore Database
                print("Metadata: \(metadata)")
                let alert = UIAlertController(title: "Upload Successful", message: "Your image is posted successfully", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    
    
    

}
