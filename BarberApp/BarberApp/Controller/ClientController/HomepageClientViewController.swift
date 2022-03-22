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
        let postView: PostView = PostView.init()
        postView.configurateView(URL.init(string: "https://i.ytimg.com/vi/cX-Oqdt7gmc/hqdefault.jpg?sqp=-oaymwEbCKgBEF5IVfKriqkDDggBFQAAiEIYAXABwAEG&rs=AOn4CLD09HuYsHEh2TqhSSvzdmMUBJUIdA")!, "caption", 999)
        self.view.addSubview(postView)
        
        let postView2: PostView = PostView.init()
        postView2.configurateView(URL.init(string: "https://i.ytimg.com/vi/Rrr-5-4wcEs/hqdefault.jpg?sqp=-oaymwEbCKgBEF5IVfKriqkDDggBFQAAiEIYAXABwAEG&rs=AOn4CLAAYRnHuYcjK5xEEMCoh6jXRxW9rA")!, "caption 2", 10000)
        self.view.addSubview(postView2)
        
        
    }

}
