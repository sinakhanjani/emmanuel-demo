//
//  DataManager.swift
//  Master
//
//  Created by Sinakhanjani on 10/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class DataManager {
    
    static let shared = DataManager()
        
    public var userInformation: UserInformation? {
        get {
            return UserInformation.decode(directory: UserInformation.archiveURL)
        }
        set {
            if let encode = newValue {
                UserInformation.encode(userInfo: encode, directory: UserInformation.archiveURL)
            }
        }
    }
    
    public var applicationLanguage: Constant.Language = .fa {
        didSet {
            NotificationCenter.default.post(name: Constant.Notify.LanguageChangedNotify, object: nil)
        }
    }
    
    public var isMultiLanguage: Bool = false
    public var profile: Profile?
    public var main: Main = Main(banner: [], list: [])
    public var basketCount: Int?

}
