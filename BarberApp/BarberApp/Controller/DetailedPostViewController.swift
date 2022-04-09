//
//  DetailedPostViewController.swift
//  BarberApp
//
//  Created by admin on 4/4/22.
//

import UIKit

class DetailedPostViewController: UIViewController {
    
    // post information drawn from database
    var post: [String: Any]?
    var image: UIImage?
    // The user currently log in
    var currentUser: User?
    // post owner information drawn from database
    var postOwner: [String: Any] = [:] {
        didSet{
            nameLabel?.text = "\(postOwner["firstname"] as! String) \(postOwner["lastname"] as! String)"
        }
    }
    var like: Like?
    var likeCount = 0
    @IBOutlet weak var commentMsgLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var commentTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageView?.image = image
        captionTextView?.text = post!["caption"] as? String
        captionTextView?.isEditable = false
        
        if let firstname = postOwner["firstname"], let lastname =  postOwner["lastname"]{
            nameLabel?.text = "\(firstname as! String) \(lastname as! String)"
        }
        like = Like.init(currentUser!.id!, post!["id"] as! String)
        like?.checkPost(complete: { (exists) in
            if(exists){
                self.likeBtn.setImage(UIImage.init(systemName: "heart.fill"), for: .normal)
            } else {
                self.likeBtn.setImage(UIImage.init(systemName: "heart"), for: .normal)
            }
        })
        
        Like.getTotalLike(post!["id"] as! String) { (count) in
            self.likeCount = count
            self.likeLabel?.text = "\(self.likeCount) likes"
        }
        commentMsgLabel.text = ""
    }
    
    func configurate(_ post: [String: Any], _ image: UIImage?, _ currentUser: User?){
        self.post = post
        self.image = image
        self.currentUser = currentUser
        User.getUser(post["userid"] as! String) { (postOwnerData) in
            self.postOwner = postOwnerData!
        }
    }
    @IBAction func likeBtnClicked(_ sender: UIButton) {
        let like = Like.init(currentUser!.id!, post!["id"] as! String)
        like.likePost(){ success in
            if(success){
                self.likeCount += 1
                self.likeLabel?.text = "\(self.likeCount) likes"
                sender.setImage(UIImage.init(systemName: "heart.fill"), for: .normal)
            } else{
                like.dislikePost(){ success in
                    if(success){
                        self.likeCount -= 1
                        self.likeLabel?.text = "\(self.likeCount) likes"
                        sender.setImage(UIImage.init(systemName: "heart"), for: .normal)
                    }
                }
            }
        }
    }
    
    @IBAction func postComment(_ sender: Any) {
        if let content = commentTextView.text, let postid = post!["id"] {
            let comment = Comment.init(postid as! String, content)
            comment.newComment { (err) in
                if let err = err {
                    self.commentMsgLabel.text = "Error: \(String(describing: err))"
                } else {
                    self.commentMsgLabel.text = "Comment posted!"
                    self.commentTextView.text = "Start writing your comment here"
                }
            }
        }
    }
    
}
