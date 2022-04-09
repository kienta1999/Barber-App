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
    var userid: String
    
    init(_ postid: String, _ userid: String, _ content: String){
        self.postid = postid
        self.content = content
        self.userid = userid
    }
    
    func newComment(complete: @escaping (Error?) -> Void){
        Firestore.firestore().collection("comments").document().setData([
                Collection.Comment.postid : self.postid,
                Collection.Comment.userid : self.userid,
                Collection.Comment.content : self.content
            ]) { err in
                complete(err)
            }
    }
    
    static func getAllComment(_ postid: String, complete: @escaping ([[String:Any]]?) -> Void){
        Firestore.firestore().collection("comments")
            .whereField(Collection.Comment.postid, isEqualTo: postid)
            .getDocuments { (querySnapshot, err) in
                if let querySnapshot = querySnapshot {
                    let data = querySnapshot.documents.map { (snapshot) -> [String:Any] in
                        var datum = snapshot.data()
                        datum["id"] = snapshot.documentID
                        return datum
                    }
                    complete(data)
                }
                else{
                    complete(nil)
                }
            }
    }
    
}

