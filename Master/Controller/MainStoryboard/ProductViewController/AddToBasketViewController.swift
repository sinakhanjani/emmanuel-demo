//
//  AddToBasketViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/27/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class AddToBasketViewController: UIViewController, API {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var otherPricehash: String?
    var id: Int?
    var selectedFeature = [String:[String]]()
    var values = [[String]]()
    var keys = [String]()
    var selectedAll = [String:String]() {
        willSet {
            print(newValue)
        }
    }
    var selectedSection = [String]()
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let touch = UITapGestureRecognizer(target: self, action: #selector(tapped))
        bgView.addGestureRecognizer(touch)
        if let _ = id {
            self.keys = [String](selectedFeature.keys)
            self.values = self.convert(dict: selectedFeature)
            self.tableView.reloadData()
        }
    }
    
    func convert(dict:[String:[String]]) -> [[String]] {
        var values = [[String]]()
        let keys = [String](dict.keys)
        keys.forEach { (key) in
            let value = dict[key]!
            values.append(value)
        }
        return values
    }
    
    @objc func tapped() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addToBasketButtonTapped(_ sender: Any) {
        if let id = id, let otherHash = self.otherPricehash {
            let hashs = otherHash == "0" ? "":otherHash
            self.addToBasket(productId: id, picked_other_price: hashs, customer_message: self.descriptionTextView.text, selected_features: self.selectedAll)
        }
    }
    
    func addToBasket(productId:Int,picked_other_price: String,customer_message: String,selected_features: [String:String]) {
        let jsonData = try! JSONSerialization.data(withJSONObject: selected_features, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        print(decoded,customer_message,picked_other_price)
        _ = Network<Message,Empty>.init(path: "api/products/\(productId)/add-to-cart", ignoreAuth: false).setBodyType(type: .formdata).addParameters(params: ["selected_features":decoded,"customer_message":customer_message,"picked_other_price":picked_other_price]).post { (res) in
            res.ifSuccess { (data) in
//                if let _ = data.cart_count {
//
//                }
                DispatchQueue.main.async {
                    self.presentIOSAlertWarning(message: data.message ?? "", completion: {
                        self.dismiss(animated: true, completion: nil)
                    })
                    self.fetchBasketCount()
                }
            }
        }
    }
}

extension AddToBasketViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.keys.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.values[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let key = self.keys[indexPath.section]
        let items = self.values[indexPath.section]
        let item = items[indexPath.item]
        cell.textLabel?.text = item
        if let selectedIndexPath = self.selectedIndex {
            if selectedIndexPath.section == indexPath.section {
                if let _ = self.selectedAll[key] {
                    if let valueForKey = self.selectedAll[key] {
                        if valueForKey == item {
                            cell.accessoryType = .none
                            self.selectedAll[key] = nil
                        } else {
                            if indexPath.row == selectedIndexPath.row {
                                self.selectedAll.updateValue(item, forKey: key)
                                cell.accessoryType = .checkmark
                            } else {
                                cell.accessoryType = .none
                            }
                        }
                    } else {
                        // do nothing here
                    }
                } else {
                    // daqiqan khode section injas harchi row dare
                    if indexPath.row == selectedIndexPath.row {
                        self.selectedAll.updateValue(item, forKey: key)
                        cell.accessoryType = .checkmark
                    } else {
                        cell.accessoryType = .none
                    }
                }
            } else {
                // do nothing * for other section
            }
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.keys[section]
    }
}
