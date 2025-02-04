//
//  Favorite.swift
//  Master
//
//  Created by Sina khanjani on 1/14/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import Foundation

// MARK: - FavoriteElement
struct FavoriteElement: Codable {
    let id: Int
    let title, titleFull: String?
    let price, discount: Int?
//    let gifts: String?
    let categoryID: Int?
//    let features: Features?
    let productStatus: Int?
    let images: [String]?
    let stats: Stats?
    let category: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case titleFull = "title_full"
        case price, discount
//        case gifts
        case categoryID = "category_id"
//        case features
        case productStatus = "product_status"
        case images, stats, category
    }
}
//
//// MARK: - Features
//struct Features: Codable {
//    let main, sub: [String]
//}

// MARK: - Stats
//struct Stats: Codable {
//    let comments, ratesSum, ratesCount: String
//
//    enum CodingKeys: String, CodingKey {
//        case comments
//        case ratesSum = "rates_sum"
//        case ratesCount = "rates_count"
//    }
//}

typealias Favorites = [FavoriteElement]
