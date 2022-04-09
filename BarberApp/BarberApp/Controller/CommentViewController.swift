//
//  CommentViewController.swift
//  BarberApp
//
//  Created by admin on 4/9/22.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    var postid: String?
    var comments: [[String: Any]] = []
    @IBOutlet weak var commentTable: UITableView!
    
    func configurate(postid: String?, comments: [[String: Any]]){
        self.postid = postid
        self.comments = comments
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        commentTable.delegate = self
        commentTable.dataSource = self
        commentTable.register(UITableViewCell.self, forCellReuseIdentifier: "commentCell")
        commentTable.reloadData()
//        print("viewWillAppear")
//        print(self.comments)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell.init(style: .default, reuseIdentifier: "commentCell")
        let commentInfor = self.comments[indexPath.row]
//        let userid = commentInfor["userid"] as? String
        myCell.textLabel?.text = commentInfor["content"] as? String
        return myCell
    }

}
