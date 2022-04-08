//
//  Like.swift
//  BarberApp
//
//  Created by admin on 4/5/22.
//

import Foundation
import Firebase

class Like{
    var userid: String
    var postid: String
    let db = Firestore.firestore()
    
    init(_ userid: String, _ postid: String){
        self.userid = userid
        self.postid = postid
    }
    
    func checkPost(complete: @escaping (Bool) -> Void){
        db.collection("likes")
            .whereField(Collection.Like.userid, isEqualTo: userid)
            .whereField(Collection.Like.postid, isEqualTo: postid)
            .getDocuments() { (querySnapshot, err) in
                if querySnapshot!.documents.count == 0 {
                    complete(false)
                } else{
                    complete(true)
            }
        }
    }
    
    func likePost(complete: @escaping (Bool) -> Void){
        self.checkPost { (exists) in
            if(exists){
                complete(false)
                return
            }
            self.db.collection("likes").document().setData([
                Collection.Like.userid : self.userid,
                Collection.Like.postid : self.postid
            ]) { err in
                if err != nil {
                    complete(false)
                } else {
                    complete(true)
                }
            }
        }
    }
    
    func dislikePost(complete: @escaping (Bool) -> Void){
        db.collection("likes")
            .whereField(Collection.Like.userid, isEqualTo: userid)
            .whereField(Collection.Like.postid, isEqualTo: postid)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    complete(false)
                } else {
                    if querySnapshot!.documents.count == 0 {
                        complete(false)
                        return
                    }
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                        complete(true)
                    }
            }
        }
    }
    
    static func getTotalLike(_ postid: String, complete: @escaping (Int) -> Void){
        Firestore.firestore().collection("likes")
            .whereField(Collection.Like.postid, isEqualTo: postid)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    complete(0)
                } else {
                    complete(querySnapshot!.documents.count)
            }
        }
    }
}
