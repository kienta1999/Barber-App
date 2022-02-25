//
//  Post.swift
//  BarberApp
//
//  Created by admin on 2/24/22.
//

import Foundation
import Firebase

class Post {
    var userid: String
    var path: String
    var caption: String?
    var likes: Int
    let db = Firestore.firestore()
    static let postConstant = Collection.Post.self
    
    init(_ userid: String, _ path: String, _ caption: String?){
        self.userid = userid
        self.path = path
        self.caption = caption
        self.likes = 0
    }
    
    func saveToDatabase(){
        db.collection("posts").document().setData([
            Post.postConstant.userid: self.userid,
            Post.postConstant.path: self.path,
            Post.postConstant.caption: self.caption as Any,
            Post.postConstant.likes: self.likes
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
}
