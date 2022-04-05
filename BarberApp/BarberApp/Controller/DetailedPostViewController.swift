//
//  DetailedPostViewController.swift
//  BarberApp
//
//  Created by admin on 4/4/22.
//

import UIKit

class DetailedPostViewController: UIViewController {
    
    var post: [String: Any]?
    var image: UIImage?
    var postOwner: [String: Any] = [:] {
        didSet{
            nameLabel?.text = "\(postOwner["firstname"] as! String) \(postOwner["lastname"] as! String)"
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var captionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageView?.image = image
        captionTextView?.text = post!["caption"] as? String
        likeLabel?.text = "\(post!["likes"] as! Int) likes"
        if let firstname = postOwner["firstname"], let lastname =  postOwner["lastname"]{
            nameLabel?.text = "\(firstname as! String) \(lastname as! String)"
        }
    }
    
    func configurate(_ post: [String: Any], _ image: UIImage?){
        self.post = post
        self.image = image
        User.getUser(post["userid"] as! String) { (postOwnerData) in
            self.postOwner = postOwnerData!
        }
    }
}
