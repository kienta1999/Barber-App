//
//  Room.swift
//  BarberApp
//
//  Created by 최지원 on 4/19/22.
//

import Foundation
struct Room {
    var id: String?
    let name: String
    
    init(id: String? = nil, name: String) {
        self.id = id
        self.name = name
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
