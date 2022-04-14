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
            nameBtn.setTitle("\(postOwner["firstname"] as! String) \(postOwner["lastname"] as! String)", for: .normal)
        }
    }
    var like: Like?
    var likeCount = 0
    @IBOutlet weak var commentMsgLabel: UILabel!
    
    @IBOutlet weak var nameBtn: UIButton!
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
            nameBtn?.setTitle("\(firstname as! String) \(lastname as! String)", for: .normal)
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
            let comment = Comment.init(postid as! String, (currentUser?.id)!, content)
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
    
    @IBAction func viewCommentBtnClicked(_ sender: Any) {
        let postid = self.post!["id"] as! String
        Comment.getAllComment(postid) { (data) in
            if let data = data {
                let commentVC = self.storyboard?.instantiateViewController(withIdentifier: StoryBoard.commentVC) as! CommentViewController
                commentVC.configurate(postid: postid, comments: data)
                self.navigationController?.pushViewController(commentVC, animated: true)
            }
            else {
                self.commentMsgLabel.text = "Some error occur - cannot view the comments"
            }
        }
    }
    
    @IBAction func onProfileSelect(_ sender: Any) {
        let profileUser = User.init(
            id: postOwner["id"] as? String,
            firstname: postOwner["firstname"] as? String,
            lastname: postOwner["lastname"] as? String,
            email: postOwner["email"] as! String,
            password: postOwner["password"] as! String,
            role: postOwner["role"] as? String,
            age: postOwner["age"] as? Int,
            gender: postOwner["gender"] as? String,
            bio: postOwner["bio"] as? String,
            profilePicPath: postOwner["profilePicPath"] as? String,
            phoneNumber: postOwner["phoneNumber"] as? Int
        )
        if(profileUser.role == "Barber"){
            let profileVc = storyboard?.instantiateViewController(identifier: StoryBoard.Barber.profileVC) as! ProfileBarberViewController
            profileVc.user = currentUser
            profileVc.profileUser = profileUser
            profileVc.editAllow = false
            navigationController?.pushViewController(profileVc, animated: true)
        }
        else if (profileUser.role == "Client"){
            let profileVc = storyboard?.instantiateViewController(identifier: StoryBoard.Client.profileVC) as! ProfileClientViewController
            profileVc.user = currentUser
            profileVc.profileUser = profileUser
            profileVc.editAllow = false
            navigationController?.pushViewController(profileVc, animated: true)
        }
    }
    
}
