//
//  ProductController.swift
//  Master
//
//  Created by Sina khanjani on 1/27/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import Foundation
protocol ProductControllerDelegate {

}

class ProductController: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var delegate: ProductControllerDelegate?
    var data: [OtherPrice] = []//[OtherPrice(title: "None", price: "0", hash: "0")]
    var selectedIndex: Int?
    
    var selectedItem = [OtherPrice]() {
        willSet {
            print(newValue)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = data[indexPath.item]
        cell.textLabel?.text = "\(item.title) \(item.price) £"
        if let index = self.selectedIndex {
            if index == indexPath.item {
                cell.accessoryType = .checkmark
            } else{
                cell.accessoryType = .none
            }
        } else {
            if indexPath.item == 0 {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedIndex = indexPath.item
        tableView.reloadData()
    }
}
