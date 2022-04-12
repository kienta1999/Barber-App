//
//  User.swift
//  BarberApp
//
//  Created by admin on 2/11/22.
//

import UIKit
import Firebase

/// User struct contains user information such as firstname, lastname, etc
struct User {
    var id: String?
    var firstname: String?
    var lastname: String?
    var email: String
    var password: String
    var role: String?
    var age: Int?
    var gender: String?
    var bio: String?
    var profilePicPath: String?
    
    static let db = Firestore.firestore()
    static let userConstant = Collection.Users.self
    
    static let fieldError = "Please fill in all fields"
    static let passwordError = "Password must have at least 6 characters and contain a number"
    
    /// Validate if a filed is not empty
    /// - Parameter field: Optional String containing the user input
    /// - Returns: Bool value indicating if the field is valid or not
    func validateHelper(_ field: String?) -> Bool{
        if let text = field {
            if text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                return true
            }
        }
        return false
    }
    
    /// Validate if users entered valid fields for signup
    /// - Returns: Bool value indicating if all input fields are valid
    func validateSignupField() -> Bool {
        return validateHelper(firstname)  && validateHelper(lastname) && validateHelper(email) && validateHelper(password)
    }
    
    /// Validate if users entered valid fields for login
    /// - Returns: Bool value indicating if all input fields are valid
    func validateLoginField() -> Bool {
        return validateHelper(email) && validateHelper(password)
    }
    
    /// Validate if users entered valid password (at least 6 character long, contain a number)
    /// - Returns: Bool value indicating if password meets requirements
    func validatePassword() -> Bool {
            if password.count < 6 {
                return false
            }
            for c in password {
                if c <= "9" && c >= "0" {
                    return true
                }
            }
            return false
        }
    
    /// Remove the white spaces and new lines in user's input
    mutating func cleanFields(){
        firstname = firstname?.trimmingCharacters(in: .whitespacesAndNewlines)
        lastname = lastname?.trimmingCharacters(in: .whitespacesAndNewlines)
        email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        password = password.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// After validating fields, login user using FirebaseAuth
    /// - Parameter loginCompleted: closure that captures String error message, if any
    func loginUser(loginCompleted: @escaping (String?, [String : Any]?, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (authResult, err) in
            if let e = err {
                loginCompleted(e.localizedDescription, nil, nil)
            } else if let authRes = authResult {
                let userid = authRes.user.uid
                User.db.collection(User.userConstant.collectionName)
                    .document(userid)
                    .getDocument(completion: { (document, error) in
                        if let document = document, document.exists {
                            let data = document.data()
                            loginCompleted(nil, data, userid)
                        }
                    })
            } else {
                loginCompleted("Unknown error. Try again", nil, nil)
            }
        })
    }
    
    /// After validating fields, create a new  user using FirebaseAuth
    /// - Parameter signupCompleted: closure that captures String error message, if any
    func createUser(signupCompleted: @escaping (String?, String?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password, completion: { (authResult, err) in
            if let e = err {
                signupCompleted(e.localizedDescription, nil)
            } else if let authRes = authResult {
                let userid = authRes.user.uid
                User.db.collection(User.userConstant.collectionName)
                    .document(userid)
                    .setData([
                    User.userConstant.firstnameField: self.firstname!,
                    User.userConstant.lastnameField: self.lastname!,
                    User.userConstant.emailField: self.email,
                    User.userConstant.passwordField: self.password,
                    User.userConstant.profilePicPathField: self.profilePicPath,
                    User.userConstant.roleField: self.role!,
                        
                ]) { err in
                    if let err = err {
                        signupCompleted("Error adding document: \(err)", nil)
                    } else {
                        signupCompleted(nil, userid)
                    }
                }
            } else {
                signupCompleted("Unknown error. Try again", nil)
                
            }

        })
    }
    
    mutating func editUserProfile(age: Int?, gender: String?, bio: String?, path: String?, completion: @escaping (Error?) -> Void){
        self.age = age
        self.gender = gender
        self.bio = bio
        if let id = id {
            let userRef = Firestore.firestore().collection(User.userConstant.collectionName).document(id)

            // Set the "capital" field of the city 'DC'
            userRef.updateData([
                "age": age,
                "gender": gender,
                "bio": bio,
                "profilePicPath": path
            ]) { err in
                completion(err)
            }
        }
    }

    
    static func getUser(_ id: String, completion: @escaping ([String : Any]?) -> Void){
        let userRef = db.collection(User.userConstant.collectionName).document(id)
        userRef.getDocument { (snapshot, err) in
            if let snapshot = snapshot{
                var user = snapshot.data()
                user!["id"] = id
                completion(user)
            } else{
                completion(nil)
            }
        }
    }
}
