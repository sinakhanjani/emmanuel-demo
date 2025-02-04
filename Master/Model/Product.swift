//
//  Product.swift
//  Master
//
//  Created by Sina khanjani on 1/18/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import Foundation

struct Product {
    var id: Int
    var name: String
    var price: Double // CHANGE
    var discountPrice: Int?
    var imageName: String
    var counter: Int?
}

struct Main {
    var banner: [Banner]
    var list: [List]
}

struct List {
    var type: DataType // list, specialoffer, lastest
    var name: String
    var products: [Product]
}

struct Banner {
    var categoryId: Int?
    var productId: Int?
    var id: String?
}
