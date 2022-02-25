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
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    
    required init?(coder aDecoder: NSCoder) {
        self.barberPostRef = storageRef.child("BarberPost")
        imageUrl = nil
        super.init(coder: aDecoder)
    }
    
    // https://stackoverflow.com/questions/27652227/add-placeholder-text-inside-uitextview-in-swift
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        spinner.isHidden = true
        spinner.style = .large
    }
    
    @IBAction func imageSelectClicked() {
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
            imageView.image = image
        }
    }
    
    
    @IBAction func uploadImage(_ sender: UIButton) {
        if let imageUrl = imageUrl, let userid = user?.id {
            spinner.isHidden = false
            spinner.startAnimating()
            imageView.alpha = 0.5
            let imgName = imageUrl.relativeString.split(separator: "/").last ?? "default.jpeg"
            let userImageRef = barberPostRef.child("\(userid)/\(imgName)")
            userImageRef.putFile(from: imageUrl, metadata: nil) { metadata, error in
              guard let metadata = metadata else {
                self.uploadNotification("Upload Failed", error?.localizedDescription ?? "Unknown error", "Dismiss", false)
                return
              }
                print("Metadata: \(metadata)")
                let newPost = Post.init(userid, userImageRef.fullPath, self.captionTextView.text)
                newPost.saveToDatabase()
                self.uploadNotification("Upload Successful", "Your image is posted successfully", "Ok", true)
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
            }
        } else {
            uploadNotification("Upload Failed", "Please select an image", "Dismiss", false)
        }
    }
    
    func uploadNotification(_ title: String, _ message: String, _ actionTitle: String, _ isSuccess: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        if isSuccess {
            imageView.image = nil
            captionTextView.text = nil
            imageUrl = nil
            imageView.alpha = 1
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
