//
//  Invoice.swift
//  Master
//
//  Created by Sina khanjani on 1/14/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import Foundation

typealias Invoices = [InvoiceElement]
// MARK: - InvoiceElement
struct InvoiceElement: Codable {
    let id, customerID, totalPaid, cut: Int
    let usedDiscountCode: UsedDiscountCode?
    let payingInfo: PayingInfo
    let paymentMethod: Int
    let informations: Informations
    let status, statsUpdated: Int
    let createdAt, updatedAt, time: String

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case totalPaid = "total_paid"
        case cut
        case usedDiscountCode = "used_discount_code"
        case payingInfo = "paying_info"
        case paymentMethod = "payment_method"
        case informations, status
        case statsUpdated = "stats_updated"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case time
    }
}

// MARK: - Informations
struct Informations: Codable {
    let address: Address
    let deliveryCost: Int

    enum CodingKeys: String, CodingKey {
        case address
        case deliveryCost = "delivery_cost"
    }
}

// MARK: - Address
struct Address: Codable {
    let name: String
    let phoneNumbers: PhoneNumbers
    let province, city, zipcode, address: String

    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumbers = "phone-numbers"
        case province, city, zipcode, address
    }
}

// MARK: - PhoneNumbers
struct PhoneNumbers: Codable {
    let areaCode, phoneNumber, mobilePhoneNumber: String

    enum CodingKeys: String, CodingKey {
        case areaCode = "area-code"
        case phoneNumber = "phone-number"
        case mobilePhoneNumber = "mobile-phone-number"
    }
}

// MARK: - PayingInfo
struct PayingInfo: Codable {
    let ctoken: String
    let discountCode: String?
    let address, method: String

    enum CodingKeys: String, CodingKey {
        case ctoken
        case discountCode = "discount_code"
        case address, method
    }
}

// MARK: - UsedDiscountCode
struct UsedDiscountCode: Codable {
    let discountValue: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case discountValue = "discount_value"
        case title
    }
}

