//
//  User.swift
//  BarberApp
//
//  Created by admin on 2/11/22.
//

import Foundation
import Firebase

struct User {
    var firstname: String?
    var lastname: String?
    var email: String?
    var password: String?
    var role: String?
    static let db = Firestore.firestore()
    
    static let fieldError = "Please fill in all fields"
    static let passwordError = "Password must have at least 6 characters and contain a number"
    
    func validateHelper(_ field: String?) -> Bool{
        if let text = field{
            if text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                return true
            }
        }
        return false
    }
    
    func validateField() -> Bool {
        return validateHelper(firstname)  && validateHelper(lastname) && validateHelper(email) && validateHelper(password)
    }
    
    func validatePassword() -> Bool {
        if let psw = password {
            if psw.count < 6 {
                return false
            }
            for c in psw {
                if c <= "9" && c >= "0" {
                    return true
                }
            }
            return false
        }
        else {
            return false
        }
    }
    
    mutating func cleanFields(){
        firstname = firstname?.trimmingCharacters(in: .whitespacesAndNewlines)
        lastname = lastname?.trimmingCharacters(in: .whitespacesAndNewlines)
        email = email?.trimmingCharacters(in: .whitespacesAndNewlines)
        password = password?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func createUser() -> String?{
        var error: String?
        Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, err) in
            if let e = err {
                error = e.localizedDescription
            } else if authResult != nil {
                var ref: DocumentReference? = nil
                ref = User.db.collection("users").addDocument(data: [
                    "firstname": self.firstname!,
                    "lastname": self.lastname!,
                    "email": self.email!,
                    "password": self.password!,
                    "role": self.role!
                ]) { err in
                    if let err = err {
                        error =  "Error adding document: \(err)"
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
            } else {
                error = "Unknown error. Try again"
            }

        }
        return error
    }
}
