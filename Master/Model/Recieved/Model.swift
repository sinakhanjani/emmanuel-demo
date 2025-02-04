//
//  Model.swift
//  Master
//
//  Created by Sina khanjani on 1/10/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import Foundation

struct Version:Codable {
    let version: String
}

// MARK: - Login
struct Login: Codable {
    let status: Int?
    let token, orderToken: String?
    let errors: LoginErr?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case status, token
        case orderToken = "order_token"
        case errors
        case message
    }
}

struct LoginErr: Codable {
    let password: [String]?
    let email: [String]?
}
struct LoginSend: Codable {
    let email: String
    let password: String
    let push_token: String
}



struct Province: Codable {
    let id: Int
    let name: String
}

// MARK: - Profile
struct Profile: Codable {
    let email, name, nationalCode: String?
    let gender: Int?
    let phoneNumbers: [String]?
    let province, city: Int?
    let birthday, orderToken, pushToken: String?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case email, name
        case nationalCode = "national_code"
        case gender
        case phoneNumbers = "phone_numbers"
        case province, city, birthday
        case orderToken = "order_token"
        case pushToken = "push_token"
        case message
    }
    
    public var isProfileComplete: Bool {
        let condition = self.name != nil && self.email != nil && self.province != nil && self.city != nil && self.phoneNumbers != nil && self.gender != nil
        return condition
    }
}




