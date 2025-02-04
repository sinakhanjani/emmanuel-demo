//
//  Product.swift
//  Master
//
//  Created by Sina khanjani on 1/24/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import Foundation


// MARK: - ProductElement
struct ProductElement: Codable {
    let id: Int
    let title, titleFull, productDescription: String?
    let price: Double?
    let otherPrices: [OtherPrice]?
    let discount: Int?
//    let color, warranty, gifts: String?
    let categoryID: Int?
    let features: Features?
    let selectableFeatures: SelectableFeatures?
    let productStatus, unit: Int?
    let images: [String]?
    let stats: Stats?
    let visits, sales, createdBy: Int?
    let createdAt, updatedAt: String?
    let isGroupBuying: Int?
    let category: String?
    let time: Time?

    enum CodingKeys: String, CodingKey {
        case id, title
        case titleFull = "title_full"
        case productDescription = "description"
        case price
        case otherPrices = "other_prices"
        case discount
//        case color, warranty, gifts
        case categoryID = "category_id"
        case features
        case selectableFeatures = "selectable_features"
        case productStatus = "product_status"
        case unit, images, stats, visits, sales
        case createdBy = "created_by"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isGroupBuying = "is_group_buying"
        case category, time
    }
}

 //MARK: - Features
struct Features: Codable {
//    let main: [String]?
    let sub: Sub?
}

struct Sub: Codable {
    public var innerArray: [String: [String]]

    private struct CustomCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        self.innerArray = [String: [String]]()
        for key in container.allKeys {
            let value = try container.decode([String].self, forKey: CustomCodingKeys(stringValue: key.stringValue)!)
            self.innerArray[key.stringValue] = value
        }
    }
}

struct SelectableFeatures: Codable {
    public var innerArray: [String: [String]]

    private struct CustomCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        self.innerArray = [String: [String]]()
        for key in container.allKeys {
            let value = try container.decode([String].self, forKey: CustomCodingKeys(stringValue: key.stringValue)!)
            self.innerArray[key.stringValue] = value
        }
    }
}


// MARK: - CompareSearchElement
struct CompareSearchElement: Codable {
    let id: Int
    let title, titleFull, images: String?
    let productStatus, price, discount: Int?

    enum CodingKeys: String, CodingKey {
        case id, title
        case titleFull = "title_full"
        case images
        case productStatus = "product_status"
        case price, discount
    }
}

typealias CompareSearchs = [CompareSearchElement]



///////////// ++++++++ COOMENT

// MARK: - CommentElement
struct CommentElement: Codable {
    let commentID, customerID: Int?
    let createdAt, text: String?
    let stats: Rate?
    let name: String?
    let sender: Sender?
    let time: String?

    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case customerID = "customer_id"
        case createdAt = "created_at"
        case text, stats, name, sender, time
    }
}

// MARK: - Sender
struct Sender: Codable {
    let id: Int?
    let name: String?
}

// MARK: - Stats
struct Rate: Codable {
    let rates, upvotes, downvotes: String
}

typealias Comments = [CommentElement]



struct Message:Codable {
    var message: String?
    var status:Int?
    var cart_count: Int?
}

// MARK: - CompareListGetElement
// MARK: - CompareListGetElement
struct CompareListGetElement: Codable {
    let id: Int
    let title, titleFull: String?
    let images: [String]?
    let productStatus: Int?

    enum CodingKeys: String, CodingKey {
        case id, title
        case titleFull = "title_full"
        case images
        case productStatus = "product_status"
    }
}

typealias CompareListGets = [CompareListGetElement]



class Sample {
//    func getProduct(id: Int) {
//        _ = Network<[ProductElement],Empty>.init(path: "products/\(id)", ignoreAuth: true).get { (res) in
//            res.ifSuccess { (data) in
//                if !data.isEmpty {
//                    let _ = data[0]
//                }
//                DispatchQueue.main.async {
//                    //
//                }
//            }
//        }
//    }
    func notifyAvailable(enable: Bool,productId: Int) {
        var path:String
        if enable {
           path = "api/products/\(productId)/notify-me"
            _ = Network<Empty,Empty>.init(path: path, ignoreAuth: false).setBodyType(type: .jsonBody).addParameters(params: ["type":"on_availability"]).post { (_) in

            }
        } else {
           path = "api/products/\(productId)/notify-me"
            _ = Network<Empty,Empty>.init(path: path, ignoreAuth: false).setBodyType(type: .jsonBody).addParameters(params: ["off":"1","type":"on_availability"]).post { (_) in

            }
        }
    }
    
//    func notifySpecialOffer(enable: Bool,productId: Int) {
//        var path:String
//        if enable {
//           path = "products/\(productId)/notify-me"
//            _ = Network<Empty,Empty>.init(path: path, ignoreAuth: false).setBodyType(type: .jsonBody).addParameters(params: ["type":"on_special_offer"]).post { (_) in
//
//            }
//        } else {
//           path = "products/\(productId)/notify-me"
//            _ = Network<Empty,Empty>.init(path: path, ignoreAuth: false).setBodyType(type: .jsonBody).addParameters(params: ["off":"1","type":"on_special_offer"]).post { (_) in
//
//            }
//        }
//    }
    
//    func getComment(id: Int) {
//        _ = Network<Comments,Empty>.init(path: "products/\(id)/comments", ignoreAuth: true).get { (res) in
//            res.ifSuccess { (data) in
//                DispatchQueue.main.async {
//                    //
//                }
//            }
//        }
//    }
//    
//    func sendVoteComment(productId: Int, reviewId:Int,isUpvote: Bool) {
//        var path: String
//        if isUpvote {
//            path = "products/\(productId)/comments/\(reviewId)/upvote"
//        } else {
//            path = "products/\(productId)/comments/\(reviewId)/downvote"
//        }
//      _ = Network<Comments,Empty>.init(path: path, ignoreAuth: false).post { (res) in
//          res.ifSuccess { (data) in
//              DispatchQueue.main.async {
//                  //
//              }
//          }
//      }
//  }
//    
//    func addComment(productId: Int, message: String, rate: Int) {
//        _ = Network<Message,Empty>.init(path: "products/\(productId)/add-comment", ignoreAuth: false).setBodyType(type: .formdata).addParameters(params: ["text":message,"rate":"\(rate)"]).post { (res) in
//            res.ifSuccess { (data) in
//                DispatchQueue.main.async {
//                    //
//                }
//            }
//        }
//    }
    
//    func addToBasket(productId:Int,picked_other_price: String,customer_message: String,selected_features: [String:String]) {
//        let jsonData = try! JSONSerialization.data(withJSONObject: selected_features, options: [])
//        let decoded = String(data: jsonData, encoding: .utf8)!
//        _ = Network<Message,Empty>.init(path: "products/\(productId)/add-to-cart", ignoreAuth: false).setBodyType(type: .formdata).addParameters(params: ["selected_features":decoded,"customer_message":customer_message,"picked_other_price":picked_other_price]).post { (res) in
//            res.ifSuccess { (data) in
//                if let basketCount = data.cart_count {
//                    DispatchQueue.main.async {
//                          //
//                      }
//                }
//
//            }
//        }
//    }
    
//    func comapareProducts(productId1:Int,productId2: Int) {
//        _ = Network<Sub,Empty>.init(path: "products/compare", ignoreAuth: true).addParameters(params: ["product1":"\(productId1)","product2":"\(productId2)"]).get { (res) in
//              res.ifSuccess { (data) in
//                DispatchQueue.main.async {
//                      //
//                  }
//              }
//          }
//      }
    
    func searchCompare(productTitle:String,categoryId: Int) {
        _ = Network<CompareSearchs,Empty>.init(path: "api/search", ignoreAuth: true).addParameters(params: ["query":productTitle,"category":"\(categoryId)"]).get { (res) in
              res.ifSuccess { (data) in
                DispatchQueue.main.async {
                      //
                  }
              }
          }
      }
//    func compareListGet(productId: Int) {
//        _ = Network<CompareListGets,Empty>.init(path: "products/related", ignoreAuth: true).addParameters(params: ["product_id":"\(productId)"]).get { (res) in
//              res.ifSuccess { (data) in
//                DispatchQueue.main.async {
//                      //
//                  }
//              }
//          }
//      }
}

