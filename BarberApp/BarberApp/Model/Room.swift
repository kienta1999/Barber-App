//
//  Room.swift
//  BarberApp
//
//  Created by 최지원 on 4/19/22.
//

import Foundation
import FirebaseFirestore
struct Room {
    var id: String?
    let name: String
    
    init(id: String? = nil, name: String) {
        self.id = id
        self.name = name
    }
    
    init?(_ document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let name = data["name"] as? String else {
            return nil
        }
        
        id = document.documentID
        self.name = name
    }
}

extension Room: DatabaseRepresentation {
    var representation: [String: Any] {
        var rep = ["name": name]
        
        if let id = id {
            rep["id"] = id
        }
        
        return rep
    }
}

extension Room: Comparable {
    static func == (lhs: Room, rhs: Room) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Room, rhs: Room) -> Bool {
        return lhs.name < rhs.name
    }
}
