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
    
    func saveToDatabase(completion: @escaping (Error?) -> Void){
        Firestore.firestore().collection("addresses").document().setData([
            Collection.Address.userid: self.userid,
            Collection.Address.lat: self.lat,
            Collection.Address.lon: self.lon,
            Collection.Address.title: self.title,
            Collection.Address.subtitile: self.subtitile,
        ]) { err in
            completion(err)
        }
    }
    
    
}
