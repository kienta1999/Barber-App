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
    var signupVc: SignupViewController?
    var loginVc: LoginViewController?
//    var
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
    
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (authResult, err) in
            if let e = err {
                loginVc?.errorLabel?.text = e.localizedDescription
                loginVc?.errorLabel?.alpha = 1
            } else if let authRes = authResult {
                let userid = authRes.user.uid
                User.db.collection(User.userConstant.name)
                    .document(userid)
                    .getDocument(completion: { (document, error) in
                        if let document = document, document.exists {
                            let data = document.data()
                            print("data: \(String(describing: data))")
                            let userFirstname = data?[User.userConstant.firstnameField] as? String
                            let userLastName = data?[User.userConstant.lastnameField] as? String
                            let userRole = data?[User.userConstant.roleField]  as? String
                            loginVc?.user = User.init(
                                firstname: userFirstname,
                                lastname: userLastName,
                                email: self.email,
                                password: self.password,
                                role: userRole)
                            loginVc?.transitionToHome()
                        }
                    })
            } else {
                loginVc?.errorLabel?.text = "Unknown error. Try again"
                loginVc?.errorLabel?.alpha = 1
            }
        })
    }
    
    func createUser(){
        Auth.auth().createUser(withEmail: email, password: password, completion: { (authResult, err) in
            if let e = err {
                signupVc?.errorLabel?.text = e.localizedDescription
                signupVc?.errorLabel?.alpha = 1
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
                        signupVc?.errorLabel?.text =  "Error adding document: \(err)"
                        signupVc?.errorLabel?.alpha = 1
                    } else {
                        print("Document added with ID: \(userid)")
                        signupVc?.transitionToHome()
                    }
                }
            } else {
                signupVc?.errorLabel?.text = "Unknown error. Try again"
                signupVc?.errorLabel?.alpha = 1
            }

        })
    }
}
