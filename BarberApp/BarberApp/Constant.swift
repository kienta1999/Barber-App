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
        static let editProfileBarberVC = "editProfileBarberVC"
    }
    struct Client {
        static let homeVC = "HomepageClientVC"
        static let tabVC = "HomepageClientTab"
        static let locationVC = "LocationClientVC"
        static let profileVC = "ProfileClientVC"
        static let editProfileClientVC = "editProfileClientVC"
    }
    static let detailedPostVC = "DetailedPostVC"
    static let commentVC = "CommentVC"
}
struct Collection {
    struct Users {
        static let collectionName = "users"
        static let firstnameField = "firstname"
        static let lastnameField = "lastname"
        static let emailField = "email"
        static let passwordField = "password"
        static let roleField = "role"
        static let genderField = "gender"
        static let bioField = "bio"
        static let ageField = "age"
        static let profilePicPathField = "profilePicPath"
        static let phoneNumberField = "phoneNumber"
    }
    
    struct Post {
        static let collectionName = "posts"
        static let userid = "userid"
        static let path = "path"
        static let caption = "caption"
    }
    
    struct Like {
        static let userid = "userid"
        static let postid = "postid"
    }
    
    struct Comment {
        static let postid = "postid"
        static let userid = "userid"
        static let content = "content"
    }
}
