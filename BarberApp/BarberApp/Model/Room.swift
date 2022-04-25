//
//  Room.swift
//  BarberApp
//
//  Created by 최지원 on 4/19/22.
//

import UIKit

struct Room {
    var users: [String]
    var dictionary: [String: Any] {
        return ["users": users]
    }
}

extension Room {
    init?(dictionary: [String:Any]) {
        guard let roomUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: roomUsers)
    }
}
