//
//  ProductInformationViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/27/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class ProductInformationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var sub: Sub?
    var values = [[String]]()
    var keys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .white, name: "")
        if let sub = sub {
            convert(dict: sub.innerArray)
            self.tableView.reloadData()
        }
        tableView.tableFooterView = UIView()
    }
    
    func convert(dict:[String:[String]]) {
        var values = [[String]]()
        let keys = [String](dict.keys)
        self.keys = keys
        keys.forEach { (key) in
            let value = dict[key]!
            values.append(value)
        }
        self.values = values
    }
}

extension ProductInformationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sub?.innerArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let value = self.values[indexPath.item]
        let key = self.keys[indexPath.item]
        cell.textLabel?.text = key
        if !value.isEmpty {
            cell.detailTextLabel?.text = value[0]
        }
        return cell
    }
}
