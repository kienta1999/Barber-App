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
    let db = Firestore.firestore()
    static let postConstant = Collection.Post.self
    
    init(_ userid: String, _ path: String, _ caption: String?){
        self.userid = userid
        self.path = path
        self.caption = caption
    }
    
    func saveToDatabase(){
        db.collection("posts").document().setData([
            Post.postConstant.userid: self.userid,
            Post.postConstant.path: self.path,
            Post.postConstant.caption: self.caption as Any
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    static func getAllPost(getPostsComplete: @escaping ([[String : Any]]?, Error?) -> Void){
        Firestore.firestore().collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                getPostsComplete(nil, err)
            } else {
                let allPosts = querySnapshot!.documents.map(){ (document) -> [String : Any] in
                    var post = document.data()
                    post["id"] = document.documentID
                    return post
                }
                getPostsComplete(allPosts, nil)
            }
        }
    }
    
    static func getAllPostFrom(_ userid: String, getPostsComplete: @escaping ([[String : Any]]?, Error?) -> Void){
        Firestore.firestore().collection("posts").whereField(Collection.Post.userid, isEqualTo: userid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                getPostsComplete(nil, err)
            } else {
                let allPosts = querySnapshot!.documents.map(){ (document) -> [String : Any] in
                    var post = document.data()
                    post["id"] = document.documentID
                    return post
                }
                getPostsComplete(allPosts, nil)
            }
        }
    }
    
    static func getUrl(_ imagePath: String, getUrlComplete: @escaping (URL?, Error?) -> Void){
        let storage = Storage.storage()
        let imagePathReference = storage.reference(withPath: imagePath)
        imagePathReference.downloadURL { url, error in
          if let error = error {
            getUrlComplete(nil, error)
          } else {
            getUrlComplete(url, nil)
          }
        }
    }
}
