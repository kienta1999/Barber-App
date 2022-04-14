//
//  Address.swift
//  BarberApp
//
//  Created by admin on 4/14/22.
//

import Foundation
import Firebase

class Address {
    var id: String?
    var userid: String
    var lat: Double?
    var lon: Double?
    var title: String
    var subtitile: String?
    
    init(_ userid: String, _ title: String){
        self.userid = userid
        self.title = title
    }
    
    func getAddress(completion: @escaping (Bool) -> Void){
        Firestore.firestore().collection("addresses")
            .whereField(Collection.Address.userid, isEqualTo: userid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    completion(false)
                    return
                }
                if querySnapshot!.documents.count >= 1 {
                    let ref = querySnapshot!.documents[0].reference
                    let data = querySnapshot!.documents[0].data()
                    self.id = ref.documentID
                    self.lat = data["lat"] as? Double
                    self.lon = data["lon"] as? Double
                    self.title = data["title"] as! String
                    self.subtitile = data["subtitile"] as? String
                    completion(true)
                } else {
                    completion(false)
                }
        }
    }
    
    func deleteDuplicate(completion: @escaping (Error?) -> Void){
        Firestore.firestore().collection("addresses")
            .whereField(Collection.Address.userid, isEqualTo: userid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    completion(err)
                    return
                }
                if querySnapshot!.documents.count >= 1 {
                    querySnapshot!.documents[0].reference.delete { (err) in
                        completion(err)
                        return
                    }
                } else {
                    completion(nil)
                }
        }
        
    }
    
    func saveToDatabase(completion: @escaping (Error?) -> Void){
        self.deleteDuplicate { (err) in
            if let err = err {
                completion(err)
                return
            } else {
                let newEntry  = Firestore.firestore().collection("addresses").document()
                newEntry.setData([
                    Collection.Address.userid: self.userid,
                    Collection.Address.lat: self.lat,
                    Collection.Address.lon: self.lon,
                    Collection.Address.title: self.title,
                    Collection.Address.subtitile: self.subtitile,
                ]) { err in
                    completion(err)
                    if err != nil{
                        self.id = newEntry.documentID
                    }
                }
            }
        }
    }
    
    static func getAllAddress(getAddressesComplete: @escaping ([[String : Any]]?, Error?) -> Void){
        Firestore.firestore().collection("addresses").getDocuments() { (querySnapshot, err) in
            if let err = err {
                getAddressesComplete(nil, err)
            } else {
                let allAddress = querySnapshot!.documents.map(){ (document) -> [String : Any] in
                    var address = document.data()
                    address["id"] = document.documentID
                    return address
                }
                getAddressesComplete(allAddress, nil)
            }
        }
    }
    
    
}
