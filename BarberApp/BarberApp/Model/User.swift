//
//  User.swift
//  BarberApp
//
//  Created by admin on 2/11/22.
//

import UIKit
import Firebase

struct User {
    var firstname: String?
    var lastname: String?
    var email: String
    var password: String
    var role: String?
    
    static let db = Firestore.firestore()
    static let userConstant = Collection.Users.self
    
    static let fieldError = "Please fill in all fields"
    static let passwordError = "Password must have at least 6 characters and contain a number"
    
    func validateHelper(_ field: String?) -> Bool{
        if let text = field {
            if text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                return true
            }
        }
        return false
    }
    
    func validateSignupField() -> Bool {
        return validateHelper(firstname)  && validateHelper(lastname) && validateHelper(email) && validateHelper(password)
    }
    
    func validateLoginField() -> Bool {
        return validateHelper(email) && validateHelper(password)
    }
    
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
    
    mutating func cleanFields(){
        firstname = firstname?.trimmingCharacters(in: .whitespacesAndNewlines)
        lastname = lastname?.trimmingCharacters(in: .whitespacesAndNewlines)
        email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        password = password.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func loginUser(loginCompleted: @escaping (String?, [String : Any]?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (authResult, err) in
            if let e = err {
                loginCompleted(e.localizedDescription, nil)
            } else if let authRes = authResult {
                let userid = authRes.user.uid
                User.db.collection(User.userConstant.name)
                    .document(userid)
                    .getDocument(completion: { (document, error) in
                        if let document = document, document.exists {
                            let data = document.data()
                            loginCompleted(nil, data)
                            print("data: \(String(describing: data))")
                        }
                    })
            } else {
                loginCompleted("Unknown error. Try again", nil)
            }
        })
    }
    
    func createUser(signupCompleted: @escaping (String?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password, completion: { (authResult, err) in
            if let e = err {
                signupCompleted(e.localizedDescription)
            } else if let authRes = authResult {
                let userid = authRes.user.uid
                User.db.collection(User.userConstant.name)
                    .document(userid)
                    .setData([
                    User.userConstant.firstnameField: self.firstname!,
                    User.userConstant.lastnameField: self.lastname!,
                    User.userConstant.emailField: self.email,
                    User.userConstant.passwordField: self.password,
                    User.userConstant.roleField: self.role!
                ]) { err in
                    if let err = err {
                        signupCompleted("Error adding document: \(err)")
                    } else {
                        signupCompleted(nil)
                    }
                }
            } else {
                signupCompleted("Unknown error. Try again")
                
            }

        })
    }
}
