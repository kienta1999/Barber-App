//
//  Constant.swift
//  BarberApp
//
//  Created by admin on 2/12/22.
//

import Foundation

struct StoryBoard {
    struct Barber {
        static let homeVC = "HomepageBarberVC"
        static let tabVC = "HomepageBarberTab"
        static let postVC = "PostBarberVC"
        static let profileVC = "ProfileBarberVC"
    }
    struct Client {
        static let homeVC = "HomepageClientVC"
        static let tabVC = "HomepageClientTab"
        static let locationVC = "LocationClientVC"
        static let profileVC = "ProfileClientVC"
    }
}
struct Collection {
    struct Users {
        static let name = "users"
        static let firstnameField = "firstname"
        static let lastnameField = "lastname"
        static let emailField = "email"
        static let passwordField = "password"
        static let roleField = "role"
    }
}
