//
//  Comment.swift
//  BarberApp
//
//  Created by admin on 4/8/22.
//

import Foundation
import Firebase

class Comment {
    var postid: String
    var content: String
    
    init(_ postid: String, _ content: String){
        self.postid = postid
        self.content = content
    }
    
    func newComment(complete: @escaping (Error?) -> Void){
        Firestore.firestore().collection("comments").document().setData([
                Collection.Comment.postid : self.postid,
            Collection.Comment.content : self.content
            ]) { err in
                complete(err)
            }
        }
    }

