//
//  Address.swift
//  Master
//
//  Created by Sina khanjani on 1/15/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import Foundation


// MARK: - AddressElement
struct AddressElement: Codable {
    let name: String
    let phoneNumbers: PhoneNumbers
    let province, city, zipcode, address: String
    let deliveryCost: Int
    let deliveryDuration: String
    let cities: [City]

    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumbers = "phone-numbers"
        case province, city, zipcode, address
        case deliveryCost = "delivery_cost"
        case deliveryDuration = "delivery_duration"
        case cities
    }
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let provinceID, deliveryCost: Int
    let deliveryDuration: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case provinceID = "province_id"
        case deliveryCost = "delivery_cost"
        case deliveryDuration = "delivery_duration"
    }
}
//
//// MARK: - PhoneNumbers
//struct PhoneNumbers: Codable {
//    let areaCode, phoneNumber, mobilePhoneNumber: String
//
//    enum CodingKeys: String, CodingKey {
//        case areaCode = "area-code"
//        case phoneNumber = "phone-number"
//        case mobilePhoneNumber = "mobile-phone-number"
//    }
//}

typealias Addresses = [AddressElement]
