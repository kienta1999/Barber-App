//
//  HomepageClientViewController.swift
//  BarberApp
//
//  Created by admin on 2/12/22.
//

import UIKit

class HomepageClientViewController: HomepageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        Post.getAllPost() { (posts, err) in
            if let posts = posts {
                for post in posts {
                    let imagePath = post["path"] as! String
                    Post.getUrl(imagePath) {url, error in
                        if let url = url {
                            let postView: PostView = PostView.init()
                            postView.configurateView(url, post["caption"] as! String, post["likes"] as! Int)
                            self.view.addSubview(postView)
                            print(url)
                        }
                    }
                }
            } else {
                print(err!)
            }
        }
        
    }

}
