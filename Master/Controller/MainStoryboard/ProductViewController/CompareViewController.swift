//
//  CompareViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/27/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class CompareViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftImageview: UIImageView!
    @IBOutlet weak var leftTitleLabel: UILabel!
    
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var rightTitleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var isEnable = false {
        didSet {
            self.updateUI()
        }
    }
    
    var pro: ProductElement?
    var data: Sub?
    
    var values = [[String]]()
    var keys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        backBarButtonAttribute(color: .white, name: "")
        // Do any additional setup after loading the view.
        if let pro = pro {
            guard let im = pro.images, !im.isEmpty else {
                return
            }
            self.rightImageView.loadImageUsingCache(withUrl: pro.images?[0] ?? "", isProduct: true)
            self.rightTitleLabel.text = pro.title
        }
        self.tableView.tableFooterView = UIView()
    }
    
    func updateUI() {
        if isEnable {
            self.addButton.alpha = 0.0
            self.leftView.alpha = 1.0
        } else {
            self.leftView.alpha = 0.0
            self.addButton.alpha = 1.0
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let vc = ChoosenCompareViewController.create()
        vc.id = pro?.id
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.isEnable = false
        // clear data
        // relaod table
    }
    
    func comapareProducts(productId1:Int,productId2: Int) {
        _ = Network<Sub,Empty>.init(path: "api/products/compare", ignoreAuth: true).addParameters(params: ["product1":"\(productId1)","product2":"\(productId2)"]).get { (res) in
              res.ifSuccess { (data) in
                DispatchQueue.main.async {
                    self.data = data
                    self.convert(dict: data.innerArray)
                    self.tableView.reloadData()
                  }
              }
          }
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

extension CompareViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.keys.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = self.values[indexPath.item]
        if item.count > 1 {
            cell.textLabel?.text = item[0]
            cell.detailTextLabel?.text = item[1]
        } else {
            cell.textLabel?.text = item[0]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !self.keys.isEmpty {
            return self.keys[section]
        } else {
            return nil
        }
    }
}

extension CompareViewController: ChoosenCompareViewControllerDelegate {
    func callBackProduct(p: CompareListGetElement) {
        DispatchQueue.main.async {
            if let images = p.images {
                if images.count > 0 {
                    self.leftImageview.loadImageUsingCache(withUrl: images[0], isProduct: true)
                }
            }
            self.leftTitleLabel.text = p.title
            self.isEnable = true
        }
        if let prID = self.pro?.id {
            self.comapareProducts(productId1: p.id, productId2: prID)
        }
    }
}
