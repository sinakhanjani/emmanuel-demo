//
//  BasketViewController.swift
//  Master
//
//  Created by Sina khanjani on 2/11/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class BasketViewController: UIViewController {

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var views: [RoundedView]!
    var isParent: Navigate = .yes
    var data = [BasketElement]()
    var isFinalStep = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButton()
        backBarButtonAttribute(color: .white, name: "")
        fetch()
        if isFinalStep {
            self.views[0].backgroundColor = .gray
            self.views[1].backgroundColor = #colorLiteral(red: 0.3819646239, green: 0.7824724317, blue: 0.3859212995, alpha: 1)
        } else {
            self.views[1].backgroundColor = .gray
            self.views[0].backgroundColor = #colorLiteral(red: 0.3819646239, green: 0.7824724317, blue: 0.3859212995, alpha: 1)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if isFinalStep {
            let vc = FactorViewController.create()
            vc.title = "Send Order"
            self.navigationController?.pushViewController(vc, animated: true)

        } else {
            let vc = MyAddressViewController.create()
            vc.isParent = .no
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func fetch() {
        self.startIndicatorAnimate()
        _ = Network<BasketElements,Empty>.init(path: "api/customer/cart", ignoreAuth: false).get { (res) in
            res.ifSuccess { (data) in
                self.data = data.products
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
//                    let total = (self.data.map { Double($0.price ?? 0) }).reduce(0.0) { (total, num) -> Double in
//                        return total + num
//                    }
                    StepInfo.instance.Baskets = data.products
                    StepInfo.instance.totalPriceServer = data.finalPrice
                    self.totalPriceLabel.text = "Total : \(data.finalPrice) $"
                    self.tableView.reloadData()
                }
            }
        }
    }

}

extension BasketViewController: TableViewCellDelegate {
    
    func stepperValueChanged(sender: UIStepper, cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            self.startIndicatorAnimate()
            let item = self.data[indexPath.item]
            _ = Network<Defa,Empty>.init(path: "api/orders/\(item.orderID ?? 0)/set-quantity", ignoreAuth: false).setBodyType(type: .formdata).addParameters(params: ["quantity":"\(Int(sender.value))"]).post { (res) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                }
                res.ifSuccess { (data) in

                    self.fetch()
                }
            }
        }
    }
    func button1Tapped(sender: UIButton, cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let item = self.data[indexPath.item]
            _ = Network<Defa,Empty>.init(path: "api/orders/\(item.orderID ?? 0)/delete-from-cart", ignoreAuth: false).post { (res) in
                res.ifSuccess { (data) in
                    self.fetch()
                }
            }
        }
    }
    
    
}


extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.delegate = self
        let item = data[indexPath.item]
        cell.titleLabel1.text = item.title
        cell.titleLabel2.text = item.titleFull
        cell.titleLabel3.text = "\(item.discount ?? 0) $"
        if let price = item.price {
            switch price {
            case .integer(let p):
                cell.titleLabel4.text = "\(p) $"
            case .string(let p):
                cell.titleLabel4.text = "\(p) $"
            }
        }
        var names = ""
        if let selected = item.selectedFeatures?.innerArray {
            for (key,value) in selected {
                names += "\(key)" + " : " + value
                names += "\n"
            }
            cell.titleLabel5.text = names
        }
        if let images = item.images {
            if images.count > 0 {
                cell.imageView1.loadImageUsingCache(withUrl: images[0], isProduct: true)
            }
        }
        cell.titleLabel6.text = "\(item.quantity ?? 0)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}

extension BasketViewController {
    func addBarButton() {
        if isParent == .yes {
            let leftBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(backButtonTapped))
            leftBarButtonItem.image = UIImage(named: "down_icon")
            leftBarButtonItem.tintColor = .white
            navigationItem.leftBarButtonItem = leftBarButtonItem
            navigationController?.navigationItem.leftBarButtonItem = leftBarButtonItem
        }
        // Right
//        let rightBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(doneBarButtonTapped))
//        rightBarButtonItem.image = UIImage(named: "ic_toolbar_app_tik")
//        rightBarButtonItem.tintColor = .white
//        navigationItem.rightBarButtonItem = rightBarButtonItem
//        navigationController?.navigationItem.rightBarButtonItem = rightBarButtonItem
        // Left
    }
    
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

enum Navigate {
    case yes,no
}

// MARK: - ProductElement
//struct BasketElement: Codable {
//    let id: Int
//    let title: String?
//    let titleFull: String?
//    let price: Int?
//    let discount: Int?
//    let selectableFeatures: SelectableFeatures2?
//    let images: [String]?
//    let category: String?
//    let order_id: Int
//    let quantity: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id, title
//        case titleFull = "title_full"
//        case price
//        case discount
//        case selectableFeatures = "selected_features"
//        case category
//        case images
//        case order_id
//        case quantity
//    }
//}

// MARK: - BasketElement
struct BasketElements: Codable {
    let products: [BasketElement]
    let finalPrice: Double

    enum CodingKeys: String, CodingKey {
        case products
        case finalPrice = "final_price"
    }
}

struct BasketElement: Codable {
    let id: Int
    let title: String?
    let titleFull: String?
    let price: BadPrice?
    let discount, categoryID: Int?
//    let features: Features?
    let selectedFeatures: SelectableFeatures2?
    let productStatus: Int?
    let images: [String]?
    let orderStatus: Int?
    let stats: Stats?
    let  customerMessage: String?
    let inStorage, quantity: Int?
    let isGroupBuying, orderID: Int?
    let category: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case titleFull = "title_full"
        case price, discount
        case categoryID = "category_id"
//        case features
        case selectedFeatures = "selected_features"
        case productStatus = "product_status"
        case images
        case orderStatus = "order_status"
        case stats
        case customerMessage = "customer_message"
        case inStorage = "in_storage"
        case quantity
        case isGroupBuying = "is_group_buying"
        case orderID = "order_id"
        case category
    }
}

enum BadPrice: Codable {
    case integer(Double)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Price.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Price"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

struct SelectableFeatures2: Codable {
    public var innerArray: [String: String]

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
        self.innerArray = [String: String]()
        for key in container.allKeys {
            let value = try container.decode(String.self, forKey: CustomCodingKeys(stringValue: key.stringValue)!)
            self.innerArray[key.stringValue] = value
        }
    }
}

//struct Price2: Codable {
//    private struct CustomCodingKeys: CodingKey {
//        var stringValue: String
//        init?(stringValue: String) {
//            self.stringValue = stringValue
//        }
//        var intValue: Int?
//        init?(intValue: Int) {
//            self.intValue = intValue
//            return nil
//        }
//    }
//    var noInt: Int?
//    var noStr: String?
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
//        if let value = try? container.decode(String.self, forKey: CustomCodingKeys(stringValue: "price")!) {
//            self.noStr = value
//        }
//        if let value = try? container.decode(Int.self, forKey: CustomCodingKeys(stringValue: "price")!) {
//            self.noInt = value
//        }
//    }
//}

struct Defa:Codable {
    let status: Int?
    let message: String?
}
