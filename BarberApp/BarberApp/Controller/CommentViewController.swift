//
//  CommentViewController.swift
//  BarberApp
//
//  Created by admin on 4/9/22.
//

import UIKit

class CommentViewController: UIViewController {
    
    var postid: String?
    var comments: [[String: Any]]?
    @IBOutlet weak var randomThings: UITextView!
    
    func configurate(postid: String?, comments: [[String: Any]]?){
        self.postid = postid
        self.comments = comments
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        randomThings.text = String.init(describing: self.comments!)
    }

}
