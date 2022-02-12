//
//  User.swift
//  BarberApp
//
//  Created by admin on 2/11/22.
//

import Foundation

struct User {
    var firstname: String?
    var lastname: String?
    var email: String?
    var password: String?
    
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
    
}
