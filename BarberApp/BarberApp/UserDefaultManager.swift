//
//  UserDefaultManager.swift
//  BarberApp
//
//  Created by 최지원 on 4/21/22.
//

import Foundation

struct UserDefaultManager {
    static var displayName: String {
        get {
            UserDefaults.standard.string(forKey: "DisplayName") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "DisplayName")
        }
    }
}
