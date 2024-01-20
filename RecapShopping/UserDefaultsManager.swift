//
//  UserDefaultsManager.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import Foundation

class UserDefaultsManager {
    private init() {}
    
    static let shared = UserDefaultsManager()
    
    enum UDKey: String {
        case setting
        case nickname
    }
    
    let ud = UserDefaults.standard
    var profileImage: Int {
        get {
            ud.integer(forKey: UDKey.setting.rawValue)
        }
        set {
            ud.setValue(newValue, forKey: UDKey.setting.rawValue)
        }
    }
    var nickname: String {
        get {
            ud.string(forKey: UDKey.nickname.rawValue) ?? ""
        }
        set {
            ud.setValue(newValue, forKey: UDKey.nickname.rawValue)
        }
    }
}
