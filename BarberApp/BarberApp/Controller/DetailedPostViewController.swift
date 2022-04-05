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
    }
    
    func configurate(_ post: [String: Any], _ image: UIImage?){
        self.post = post
        self.image = image
    }
}
