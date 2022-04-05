//
//  HomepageClientViewController.swift
//  BarberApp
//
//  Created by admin on 2/12/22.
//

import UIKit

class HomepageClientViewController: HomepageViewController, UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var postTableView: UITableView!
    var allPost: [[String: Any]] = []
    var cachedImages: [UIImage?] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.register(UITableViewCell.self, forCellReuseIdentifier: "postCell")
        // Do any additional setup after loading the view.
        
        
        
        Post.getAllPost() { (posts, err) in
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPost.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell.init(style: .default, reuseIdentifier: "postCell")
        if(allPost.count > indexPath.row) {
            let post = allPost[indexPath.row]
            if let img = self.cachedImages[indexPath.row]{
                myCell.imageView?.image = img
            } else {
                let url = post["path"] as! URL
                if let data = try? Data(contentsOf: url) {
                    let imageView = UIImage(data: data);
                    let size = CGSize.init(width: 200.0, height: (imageView?.size.height)! / (imageView?.size.width)! * 200.0)
                    self.cachedImages[indexPath.row] = HomepageClientViewController.resizeImage(imageView!, size);
                    myCell.imageView?.image = self.cachedImages[indexPath.row]
                }
            }
            
            myCell.textLabel?.numberOfLines = 2
            myCell.textLabel?.lineBreakMode = NSLineBreakMode(rawValue: 0)!
            myCell.textLabel?.text = post["caption"] as? String
        }
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected: \(indexPath[1])")
        print(allPost[indexPath[1]])
        print(StoryBoard.detailedPostVC)
        let detailedVC = storyboard?.instantiateViewController(identifier: StoryBoard.detailedPostVC) as! DetailedPostViewController
        detailedVC.configurate(allPost[indexPath[1]], cachedImages[indexPath[1]])
        navigationController?.pushViewController(detailedVC, animated: true)
        
    }

}
