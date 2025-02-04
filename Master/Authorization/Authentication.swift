//
//  Authorization.swift
//  Master
//
//  Created by Sinakhanjani on 10/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

class Authentication {
    
    static let auth = Authentication()
    
    enum Platform: Int {
        case none, android, ios
    }
    
    let defaults = UserDefaults.standard
    
    private var _isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: "IS_LOGGED_IN_KEY")
        }
        set {
            defaults.set(newValue, forKey: "IS_LOGGED_IN_KEY")
        }
    }
    private var _token: String {
        get {
            return defaults.value(forKey: "TOKEN_KEY") as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: "TOKEN_KEY")
        }
    }
    
    private var _ordertoken: String {
        get {
            return defaults.value(forKey: "ordertoken_KEY") as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: "ordertoken_KEY")
        }
    }
    
    public var isLoggedIn: Bool {
        return _isLoggedIn
    }
    
    public var token: String {
        return _token
    }
    
    public var orderToken: String {
        return _ordertoken
    }
    
    public func authenticationUser(token: String, oder_Token: String, isLoggedIn: Bool) {
        self._token = token
        self._ordertoken = oder_Token
        self._isLoggedIn = isLoggedIn
    }
    
    public func logOutAuth() {
        self._isLoggedIn = false
        self._token = ""
        self._ordertoken = ""
        let userInformation = UserInformation()
        DataManager.shared.profile = nil
        DataManager.shared.basketCount = nil
        DataManager.shared.userInformation = userInformation
    }
    
    
}
