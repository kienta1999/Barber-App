//
//  PostFromBarberViewController.swift
//  BarberApp
//
//  Created by admin on 4/18/22.
//

import UIKit

class PostFromBarberViewController: ViewAllPostViewController {

    override func viewDidLoad() {
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.register(UITableViewCell.self, forCellReuseIdentifier: "postCell")
        // Do any additional setup after loading the view.
        
        Post.getAllPostFrom(user!.id!) { (posts, err) in
            if let posts = posts {
                self.allPost = posts
                let group = DispatchGroup()
                for i in 0..<self.allPost.count{
                    group.enter()
                    self.cachedImages.append(nil)
                    let post = self.allPost[i]
                    let imagePath = post["path"] as! String
                    Post.getUrl(imagePath) { url, error in
                        if let url = url {
                            self.allPost[i]["path"] = url
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    self.postTableView.reloadData()
                }
            } else {
                print(err!)
            }
        }
        
    }
}
