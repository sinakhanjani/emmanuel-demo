//
//  ViewController.swift
//  Master
//
//  Created by Sinakhanjani on 10/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol API {
    func fetchBasketCount()
}
extension API {
    func fetchBasketCount() {
        WebAPI.instance.getRequest { (str) in
            if let str = str {
                DataManager.shared.basketCount = Int(str)
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Constant.Notify.basketCount, object: nil)
                }
            }
        }
    }
}

class LoaderViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    
    fileprivate let dispathGroup = DispatchGroup()
    var activityIndicatorView: NVActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        if Authentication.auth.isLoggedIn {
            fetchProfile()
            print(Authentication.auth.token)
            print(Authentication.auth.orderToken,"X")
            
        }
    }
    
    func fetchProfile() {
        _ = Network<Profile,Empty>.init(path: "api/customer/info", ignoreAuth: false).get { (res) in
            res.ifSuccess { (profile) in
                DispatchQueue.main.async {
                    DataManager.shared.profile = profile
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchBasketCount()
        dispathGroup.notify(queue: .main) {
            print("COMPLETE FETCH ALL DATA")
        }
        if let current = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            print("appVersion: ",current)
            _ = Network<Version,Empty>.init(path: "api/version", ignoreAuth: true).get { (response) in
                response.ifSuccess { (version) in
                    if let appStore = Int(version.version) {
                        DispatchQueue.main.async {
                            let versionCompare = current.compare("\(appStore)", options: .numeric)
                            if versionCompare == .orderedSame {
                                print("same version")
                            } else if versionCompare == .orderedAscending {
                                // will execute the code here
                                print("ask user to update")
                            } else if versionCompare == .orderedDescending {
                                // execute if current > appStore
                                print("don't expect happen...")
                            }
                        }
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+5.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navVC = storyboard.instantiateViewController(withIdentifier: "MainViewControllerNav") as! UINavigationController
            let _ = navVC.viewControllers.first as! MainViewController
            self.present(navVC, animated: true, completion: nil)
        }
    }
    
    // Method
    func updateUI() {
        beginActivityIndicator()
        fetch()
    }

    @IBAction func unwindToLoaderViewController(_ segue: UIStoryboardSegue) {
        //
    }
    
    func beginActivityIndicator() {
        let padding: CGFloat = 40.0
        let frame = CGRect(x: 0.0, y: 0.0, width: padding, height: padding)
        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.circleStrokeSpin, color: .red, padding: padding)
        self.loadingView.addSubview(activityIndicatorView!)
        activityIndicatorView!.startAnimating()
    }
    
    func endActivityIndicator() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
            self.activityIndicatorView?.stopAnimating()
            self.removeAnimate()
        }
    }
}

extension LoaderViewController {
    // MARK: - SliderElement
    struct SliderElement: Codable {
        let id: String
        let categoryID, productID: Int?
        let createdAt: String
        enum CodingKeys: String, CodingKey {
            case id
            case categoryID = "category_id"
            case productID = "product_id"
            case createdAt = "created_at"
        }
    }
    typealias Sliders = [SliderElement]
    // This file was generated from JSON Schema using quicktype, do not modify it directly.
    // To parse the JSON, add this file to your project and do:
    //
    //   let specialOffer = try? newJSONDecoder().decode(SpecialOffer.self, from: jsonData)
    // MARK: - SpecialOfferElement
    struct SpecialOfferElement: Codable {
        let productID: Int
        let alternativePrice: Int?
        let createdTime, expirationTime: String?
        let id: Int
        let title, titleFull, specialOfferDescription: String?
        let price: Double // CHANGE
        let otherPrices: String?
        let discount: Int?
        let color, warranty, gifts: String?
        let categoryID: Int?
        let features: Features?
        let selectableFeatures: String?
        let productStatus, unit: Int?
        let images: [String]
        let stats: Stats?
        let visits, sales, createdBy: Int?
        let createdAt, updatedAt: String?
        let expiration, isSpecialOffer, specialOfferPrice: Int?
        let category, time: String?

        enum CodingKeys: String, CodingKey {
            case productID = "product_id"
            case alternativePrice = "alternative_price"
            case createdTime = "created_time"
            case expirationTime = "expiration_time"
            case id, title
            case titleFull = "title_full"
            case specialOfferDescription = "description"
            case price
            case otherPrices = "other_prices"
            case discount, color, warranty, gifts
            case categoryID = "category_id"
            case features
            case selectableFeatures = "selectable_features"
            case productStatus = "product_status"
            case unit, images, stats, visits, sales
            case createdBy = "created_by"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case expiration
            case isSpecialOffer = "is_special_offer"
            case specialOfferPrice = "special_offer_price"
            case category, time
        }
    }
    // MARK: - Features
    struct Features: Codable {
        let main, sub: [String]?
    }
    // MARK: - Stats
    struct Stats: Codable {
        let comments, ratesSum, ratesCount: String?
        enum CodingKeys: String, CodingKey {
            case comments
            case ratesSum = "rates_sum"
            case ratesCount = "rates_count"
        }
    }
    typealias SpecialOffers = [SpecialOfferElement]

    
    // MARK: - LastProductElement
    struct LastProductElement: Codable {
        let id: Int
        let title, titleFull: String?
//        let homeProductDescription: String?
        let price: Double // CHANGE
//        let otherPrices: String?
        let discount: Int?
//        let color, warranty, gifts: String?
//        let categoryID: Int?
//        let features: Features?
//        let selectableFeatures: String?
//        let productStatus, unit: Int?
        let images: [String]
//        let stats: Stats?
//        let visits, sales, createdBy: Int?
//        let createdAt, updatedAt: String?
//        let category: String?
//        let time: Time
//        let isGroupBuying: Int?

        enum CodingKeys: String, CodingKey {
            case id, title
            case titleFull = "title_full"
//            case homeProductDescription = "description"
            case price
//            case otherPrices = "other_prices"
            case discount
//            case color, warranty, gifts
//            case categoryID = "category_id"
//            case features
//            case selectableFeatures = "selectable_features"
//            case productStatus = "product_status"
            case images
//            case unit, stats, visits, sales
//            case createdBy = "created_by"
//            case createdAt = "created_at"
//            case updatedAt = "updated_at"
//            case category, time
//            case isGroupBuying = "is_group_buying"
        }
    }
    typealias LastProducts = [LastProductElement]

    
    // MARK: - HomeProductElement
    struct HomeProductElement: Codable {
        let title: String
        let items: [Item]
    }
    // MARK: - Item
    struct Item: Codable {
        let id: Int
        let title: String?
        let price: Double?
        let discount: Int?
        let gifts: String?
        let images: [String]
        let categoryID: Int?
        let stats: Stats?
        let productStatus: Int?
        let category: String?
        let features: Features?

        enum CodingKeys: String, CodingKey {
            case id, title, price, discount, gifts, images
            case categoryID = "category_id"
            case stats
            case productStatus = "product_status"
            case category, features
        }
    }
    typealias HomeProducts = [HomeProductElement]

    
    func fetch() {
        fetchHomeProducts()
        fetchSlider()
        fetchSpecialOffer()
        fetchLastProducts()
    }
    func fetchSlider() {
        _ = Network<Sliders,Empty>.init(path: "api/slider", ignoreAuth: true).get(completion: { (res) in
            res.ifSuccess { (data) in
                DataManager.shared.main.banner = data.map { Banner(categoryId: $0.categoryID, productId: $0.productID,id: $0.id) }
            }
        })
    }
    func fetchSpecialOffer() {
        _ = Network<SpecialOffers,Empty>.init(path: "api/products/special-offers", ignoreAuth: true).get(completion: { (res) in
            res.ifSuccess { (data) in
                let products = data.map { Product(id: $0.productID, name: $0.title ?? "", price: $0.price, discountPrice: $0.specialOfferPrice, imageName: $0.images.count > 0 ? $0.images[0]:"", counter: $0.expiration)}
                let list = List(type: .specialOffer, name: "Special Offer", products: products)
                if products.count > 0 {
                    DataManager.shared.main.list.append(list)
                }
            }
        })
    }
    func fetchLastProducts() {
        _ = Network<LastProducts,Empty>.init(path: "api/products", ignoreAuth: true).addParameters(params: ["home":"1"]).get(completion: { (res) in
            res.ifSuccess { (data) in
                let products = data.map { Product(id: $0.id, name: $0.title ?? "", price: $0.price, discountPrice: $0.discount, imageName: $0.images.count > 0 ? $0.images[0]:"", counter: nil)}
                let list = List(type: .lastest, name: "Lastest", products: products)
                DataManager.shared.main.list.append(list)
            }
        })
    }
    func fetchHomeProducts() {
        _ = Network<HomeProducts,Empty>.init(path: "api/products/homepage-categories-products", ignoreAuth: true).get(completion: { (res) in
            res.ifSuccess { (data) in
                var lists = data.map { List(type: .list, name: $0.title, products: $0.items.map { Product(id: $0.id, name: $0.title ?? "", price: $0.price ?? 0.0, discountPrice: ($0.discount ?? 0) == 0 ? nil:$0.discount!, imageName: $0.images.count > 0 ? $0.images[0]:"", counter: nil)}) }
                lists = lists.filter { $0.products.count > 0 }
                DataManager.shared.main.list.append(contentsOf: lists)
            }
        })
    }
    
}
extension LoaderViewController: API { }
// MARK: - Time
struct Time: Codable {
    let date: String?
    let timezoneType: Int?
    let timezone: String?

    enum CodingKeys: String, CodingKey {
        case date
        case timezoneType = "timezone_type"
        case timezone
    }
}
