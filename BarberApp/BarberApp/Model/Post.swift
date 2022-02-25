//
//  Post.swift
//  BarberApp
//
//  Created by admin on 2/24/22.
//

import Foundation

class Post {
    var imageUrl: URL
    var userid: String
    
    
    init(_ imageUrl: URL, _ userid: String){
        self.imageUrl = imageUrl
        self.userid = userid
    }
    
}
